module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.YharnamHospitality (yharnamHospitality) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype YharnamHospitality = YharnamHospitality TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

yharnamHospitality :: TreacheryCard YharnamHospitality
yharnamHospitality = treachery YharnamHospitality Cards.yharnamHospitality

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage YharnamHospitality where
  runMessage msg t@(YharnamHospitality attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> YharnamHospitality <$> liftRunMessage msg attrs
