module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.HospitalCourtyard (hospitalCourtyard) where

import Arkham.GameValue
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted

newtype HospitalCourtyard = HospitalCourtyard LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Clue count (1/investigator) confirmed via GMNotes. Shroud value is a
-- placeholder pending real card-sheet transcription (not in GMNotes).
hospitalCourtyard :: LocationCard HospitalCourtyard
hospitalCourtyard = location HospitalCourtyard Cards.hospitalCourtyard 2 (PerPlayer 1)

instance RunMessage HospitalCourtyard where
  runMessage msg (HospitalCourtyard attrs) = HospitalCourtyard <$> runMessage msg attrs
