module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.AshenBloodBeast (ashenBloodBeast) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype AshenBloodBeast = AshenBloodBeast EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

ashenBloodBeast :: EnemyCard AshenBloodBeast
ashenBloodBeast = enemy AshenBloodBeast Cards.ashenBloodBeast

instance RunMessage AshenBloodBeast where
  runMessage msg (AshenBloodBeast attrs) = AshenBloodBeast <$> runMessage msg attrs
