module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.ScourgeBeast (scourgeBeast) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype ScourgeBeast = ScourgeBeast EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

scourgeBeast :: EnemyCard ScourgeBeast
scourgeBeast = enemy ScourgeBeast Cards.scourgeBeast

instance RunMessage ScourgeBeast where
  runMessage msg (ScourgeBeast attrs) = ScourgeBeast <$> runMessage msg attrs
