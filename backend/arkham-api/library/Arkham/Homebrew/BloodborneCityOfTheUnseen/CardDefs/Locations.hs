module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set
import Arkham.Location.CardDefs.Import

-- hunt_begins
-- | Icon + connections confirmed via the SCED TTS source
-- (bloodborne_city_of_the_unseen.json GMNotes locationFront) -- 2026-10-07,
-- no guessing. The "Diamond" connection on Hospital Courtyard links to an
-- Act 2 location that isn't placed by this pilot's Setup (deferred, see
-- Scenarios/HuntBegins.hs) -- harmless, just unreachable until then.
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
