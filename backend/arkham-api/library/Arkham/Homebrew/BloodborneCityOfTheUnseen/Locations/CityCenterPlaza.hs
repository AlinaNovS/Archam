module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.CityCenterPlaza (cityCenterPlaza) where

import Arkham.GameValue
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted
import Arkham.Matcher (be)

newtype CityCenterPlaza = CityCenterPlaza LocationAttrs
  deriving anyclass IsLocation
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

-- | Shroud 3, 1 clue/investigator, both confirmed by visually reading the
-- real card. "Hospital Courtyard is connected to City Center Plaza and vice
-- versa" is printed card text -- wired as an explicit connection, the
-- symmetric half lives on HospitalCourtyard.hs.
cityCenterPlaza :: LocationCard CityCenterPlaza
cityCenterPlaza = location CityCenterPlaza Cards.cityCenterPlaza 3 (PerPlayer 1)

instance HasModifiersFor CityCenterPlaza where
  getModifiersFor (CityCenterPlaza a) =
    modifySelf a [ConnectedToWhen (be a) "Hospital Courtyard"]

instance RunMessage CityCenterPlaza where
  runMessage msg (CityCenterPlaza attrs) = CityCenterPlaza <$> runMessage msg attrs
