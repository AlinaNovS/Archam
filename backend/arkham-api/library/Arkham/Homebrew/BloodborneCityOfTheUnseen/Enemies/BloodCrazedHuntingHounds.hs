module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.BloodCrazedHuntingHounds (bloodCrazedHuntingHounds) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype BloodCrazedHuntingHounds = BloodCrazedHuntingHounds EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

bloodCrazedHuntingHounds :: EnemyCard BloodCrazedHuntingHounds
bloodCrazedHuntingHounds = enemy BloodCrazedHuntingHounds Cards.bloodCrazedHuntingHounds

instance RunMessage BloodCrazedHuntingHounds where
  runMessage msg (BloodCrazedHuntingHounds attrs) = BloodCrazedHuntingHounds <$> runMessage msg attrs
