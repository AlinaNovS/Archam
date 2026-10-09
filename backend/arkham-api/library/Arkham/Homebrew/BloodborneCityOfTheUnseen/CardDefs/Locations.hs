module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set
import Arkham.Location.CardDefs.Import

-- hunt_begins
-- | Icon + connections confirmed via the SCED TTS source
-- (bloodborne_city_of_the_unseen.json GMNotes locationFront) -- 2026-10-07,
-- no guessing. The printed "Diamond" connector doesn't match any of this
-- scenario's 5 locations (none has a Diamond icon) -- appears to be an
-- unused connector slot on the physical card, not a missing location;
-- City Center Plaza connects via an explicit card-text override instead
-- (see Locations/CityCenterPlaza.hs), not via symbol matching.
hospitalCourtyard :: CardDef
hospitalCourtyard =
  location ":bloodborne-city-of-the-unseen:012" "Hospital Courtyard" mempty Square [Circle, Triangle, Diamond] Set.HuntBegins

-- | Two physical copies of this location exist in the scenario (confirmed
-- via the TTS source having two distinct GUIDs with identical GMNotes) --
-- defined as two CardDefs since this engine keys locations by unique code.
examinationRoomA :: CardDef
examinationRoomA =
  location ":bloodborne-city-of-the-unseen:013" "1st Floor Examination Room" mempty Triangle [Circle, Square] Set.HuntBegins

examinationRoomB :: CardDef
examinationRoomB =
  location ":bloodborne-city-of-the-unseen:014" "1st Floor Examination Room" mempty Triangle [Circle, Square] Set.HuntBegins

sickroom :: CardDef
sickroom =
  location ":bloodborne-city-of-the-unseen:015" "1st Floor Sickroom" mempty Circle [Triangle, Square] Set.HuntBegins

-- | Icon + connections confirmed via the real card image (GMNotes names
-- didn't match this engine's symbol vocabulary directly -- "Slash" in
-- GMNotes actually renders as a Triangle on the printed card, verified
-- visually, not guessed). Card text explicitly overrides symbol-based
-- connectivity: "Hospital Courtyard is connected to City Center Plaza and
-- vice versa" -- wired as an explicit 'ConnectedToWhen' modifier on both
-- locations (see Locations/CityCenterPlaza.hs and HospitalCourtyard.hs),
-- not via symbol matching, since Plus doesn't match any of Hospital
-- Courtyard's own printed connectors.
cityCenterPlaza :: CardDef
cityCenterPlaza =
  location ":bloodborne-city-of-the-unseen:016" "City Center Plaza" mempty Plus [Square, Triangle, T] Set.HuntBegins
