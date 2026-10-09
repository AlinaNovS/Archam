module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.ExaminationRoomA (examinationRoomA) where

import Arkham.GameValue
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted

newtype ExaminationRoomA = ExaminationRoomA LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

-- | Clue count (2/investigator) confirmed via GMNotes. Shroud value is a
-- placeholder pending real card-sheet transcription (not in GMNotes).
examinationRoomA :: LocationCard ExaminationRoomA
examinationRoomA = location ExaminationRoomA Cards.examinationRoomA 2 (PerPlayer 2)

instance RunMessage ExaminationRoomA where
  runMessage msg (ExaminationRoomA attrs) = ExaminationRoomA <$> runMessage msg attrs
