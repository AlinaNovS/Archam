module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.ClericBeast (clericBeast) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype ClericBeast = ClericBeast EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

clericBeast :: EnemyCard ClericBeast
clericBeast = enemy ClericBeast Cards.clericBeast

instance RunMessage ClericBeast where
  runMessage msg (ClericBeast attrs) = ClericBeast <$> runMessage msg attrs
