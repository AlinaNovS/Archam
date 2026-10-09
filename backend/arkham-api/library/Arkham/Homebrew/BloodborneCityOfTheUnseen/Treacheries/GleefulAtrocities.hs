module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.GleefulAtrocities (gleefulAtrocities) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype GleefulAtrocities = GleefulAtrocities TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

gleefulAtrocities :: TreacheryCard GleefulAtrocities
gleefulAtrocities = treachery GleefulAtrocities Cards.gleefulAtrocities

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage GleefulAtrocities where
  runMessage msg t@(GleefulAtrocities attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> GleefulAtrocities <$> liftRunMessage msg attrs
