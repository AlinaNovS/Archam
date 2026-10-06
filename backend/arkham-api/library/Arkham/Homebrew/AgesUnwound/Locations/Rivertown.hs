module Arkham.Homebrew.AgesUnwound.Locations.Rivertown (rivertown) where

import Arkham.GameValue
import Arkham.Homebrew.AgesUnwound.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted

newtype Rivertown = Rivertown LocationAttrs
  deriving anyclass (IsLocation, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Placeholder shroud/clue values pending the real card sheet transcription.
rivertown :: LocationCard Rivertown
rivertown = location Rivertown Cards.rivertown 2 (Static 2)

instance RunMessage Rivertown where
  runMessage msg (Rivertown attrs) = Rivertown <$> runMessage msg attrs
