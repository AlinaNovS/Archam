module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.HospitalCourtyard (hospitalCourtyard) where

import Arkham.GameValue
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted
import Arkham.Matcher (be)

newtype HospitalCourtyard = HospitalCourtyard LocationAttrs
  deriving anyclass IsLocation
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

-- | Clue count (1/investigator) confirmed via GMNotes. Shroud value is a
-- placeholder pending real card-sheet transcription (not in GMNotes).
hospitalCourtyard :: LocationCard HospitalCourtyard
hospitalCourtyard = location HospitalCourtyard Cards.hospitalCourtyard 2 (PerPlayer 1)

-- | "Hospital Courtyard is connected to City Center Plaza and vice versa" --
-- printed card text on City Center Plaza; symmetric half lives there too.
instance HasModifiersFor HospitalCourtyard where
  getModifiersFor (HospitalCourtyard a) =
    modifySelf a [ConnectedToWhen (be a) "City Center Plaza"]

instance RunMessage HospitalCourtyard where
  runMessage msg (HospitalCourtyard attrs) = HospitalCourtyard <$> runMessage msg attrs
