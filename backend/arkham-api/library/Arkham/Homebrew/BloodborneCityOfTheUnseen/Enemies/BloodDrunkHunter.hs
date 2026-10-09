module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.BloodDrunkHunter (bloodDrunkHunter) where

import Arkham.Enemy.Import.Lifted
import Arkham.Helpers.Modifiers (ModifierType (..), modifyEach)
import Arkham.Helpers.SkillTest (getSkillTest, getSkillTestAction, getSkillTestTargetedEnemy)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype BloodDrunkHunter = BloodDrunkHunter EnemyAttrs
  deriving anyclass (IsEnemy, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

bloodDrunkHunter :: EnemyCard BloodDrunkHunter
bloodDrunkHunter = enemy BloodDrunkHunter Cards.bloodDrunkHunter

{- | "When performing a Fight, Evade, or Parley action against Blood-Drunk
Hunter: Double the skill icons on any card committed to that test" --
confirmed by visually reading the real card. Same pattern (and same
'DoubleSkillIcons'-doesn't-special-case-wild engine gap) as
'Arkham.Homebrew.CircusExMortis.Enemies.NewMoonStrongman', extended to all
three actions instead of just Fight since this card's text explicitly says
all three.
-}
instance HasModifiersFor BloodDrunkHunter where
  getModifiersFor (BloodDrunkHunter a) = do
    getSkillTest >>= traverse_ \st -> do
      action <- getSkillTestAction
      menemy <- getSkillTestTargetedEnemy
      when (action `elem` [Just #fight, Just #evade, Just #parley] && menemy == Just a.id) do
        modifyEach a (concat $ toList st.committedCards) [DoubleSkillIcons]

instance RunMessage BloodDrunkHunter where
  runMessage msg (BloodDrunkHunter attrs) = BloodDrunkHunter <$> runMessage msg attrs
