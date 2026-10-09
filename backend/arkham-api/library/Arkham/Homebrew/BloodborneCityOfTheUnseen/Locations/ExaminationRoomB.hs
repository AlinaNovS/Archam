module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.ExaminationRoomB (examinationRoomB) where

import Arkham.GameValue
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted

newtype ExaminationRoomB = ExaminationRoomB LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

-- | Second physical copy of "1st Floor Examination Room" -- see
-- 'Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations.examinationRoomB'.
examinationRoomB :: LocationCard ExaminationRoomB
examinationRoomB = location ExaminationRoomB Cards.examinationRoomB 2 (PerPlayer 2)

instance RunMessage ExaminationRoomB where
  runMessage msg (ExaminationRoomB attrs) = ExaminationRoomB <$> runMessage msg attrs
