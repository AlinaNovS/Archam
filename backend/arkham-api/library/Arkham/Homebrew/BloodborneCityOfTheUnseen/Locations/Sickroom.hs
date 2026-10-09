module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.Sickroom (sickroom) where

import Arkham.GameValue
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted

newtype Sickroom = Sickroom LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

-- | Clue count (2/investigator) confirmed via GMNotes. Shroud value is a
-- placeholder pending real card-sheet transcription (not in GMNotes).
sickroom :: LocationCard Sickroom
sickroom = location Sickroom Cards.sickroom 2 (PerPlayer 2)

instance RunMessage Sickroom where
  runMessage msg (Sickroom attrs) = Sickroom <$> runMessage msg attrs
