module Arkham.Homebrew.BloodborneCityOfTheUnseen.Enemies.ElderlyHuntsman (elderlyHuntsman) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Cards

newtype ElderlyHuntsman = ElderlyHuntsman EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

elderlyHuntsman :: EnemyCard ElderlyHuntsman
elderlyHuntsman = enemy ElderlyHuntsman Cards.elderlyHuntsman

instance RunMessage ElderlyHuntsman where
  runMessage msg (ElderlyHuntsman attrs) = ElderlyHuntsman <$> runMessage msg attrs
