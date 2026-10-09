module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.HuntingParty (huntingParty) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype HuntingParty = HuntingParty EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

huntingParty :: EnemyCard HuntingParty
huntingParty = enemy HuntingParty Cards.huntingParty

instance RunMessage HuntingParty where
  runMessage msg (HuntingParty attrs) = HuntingParty <$> runMessage msg attrs
