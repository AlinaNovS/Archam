module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.ScourgeBeast (scourgeBeast) where

import Arkham.Enemy.Import.Lifted
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelfWhen)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards
import Arkham.Matcher
import Arkham.Trait (Trait (HomebrewTrait))

{- | Confirmed by visually reading the real card (code 027): "Prey - Lowest
remaining health. Scourge Beast gets +1 fight for each other Beast enemy at
its location." Stats/keywords/traits were already wired in CardDefs/Enemies.hs
by an earlier session; only the two text abilities were left as placeholders.
-}
newtype ScourgeBeast = ScourgeBeast EnemyAttrs
  deriving anyclass IsEnemy
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

scourgeBeast :: EnemyCard ScourgeBeast
scourgeBeast =
  enemyWith
    ScourgeBeast
    Cards.scourgeBeast
    (preyL .~ Prey LowestRemainingHealth)

instance HasModifiersFor ScourgeBeast where
  getModifiersFor (ScourgeBeast a) = do
    n <- selectCount $ EnemyWithTrait (HomebrewTrait "Beast") <> not_ (be a) <> EnemyAt (locationWithEnemy a)
    modifySelfWhen a (n > 0) [EnemyFight n]

instance RunMessage ScourgeBeast where
  runMessage msg (ScourgeBeast attrs) = ScourgeBeast <$> runMessage msg attrs
