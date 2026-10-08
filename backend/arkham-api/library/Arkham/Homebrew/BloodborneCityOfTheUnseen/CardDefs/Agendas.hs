module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas where

import Arkham.Agenda.CardDefs.Import
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set

-- hunt_begins
-- | Names, print order (1a/2a/3a), and doom thresholds all confirmed by
-- visually reading the real card scans from the SCED TTS source's Agenda
-- Deck for this scenario (bloodborne_city_of_the_unseen.json) -- 2026-10-07,
-- no guessing. Doom thresholds DEscend (8, 6, 5) across the three stages,
-- confirmed correct by reading each card directly rather than assuming
-- ascending like most official campaigns.
huntBegins :: CardDef
huntBegins =
  agenda ":bloodborne-city-of-the-unseen:002" "The Hunt Begins" 1 Set.HuntBegins
    & otherSideIs ":bloodborne-city-of-the-unseen:003"

yharnamJustice :: CardDef
yharnamJustice = agenda ":bloodborne-city-of-the-unseen:003" "Yharnam Justice" 1 Set.HuntBegins

nightOfCurses :: CardDef
nightOfCurses =
  agenda ":bloodborne-city-of-the-unseen:004" "A Night of Curses" 2 Set.HuntBegins
    & otherSideIs ":bloodborne-city-of-the-unseen:005"

clericBeastsFury :: CardDef
clericBeastsFury = agenda ":bloodborne-city-of-the-unseen:005" "The Cleric Beast's Fury" 2 Set.HuntBegins

mereBadDream :: CardDef
mereBadDream =
  agenda ":bloodborne-city-of-the-unseen:006" "A Mere Bad Dream" 3 Set.HuntBegins
    & otherSideIs ":bloodborne-city-of-the-unseen:007"

nightTerrors :: CardDef
nightTerrors = agenda ":bloodborne-city-of-the-unseen:007" "Night Terrors" 3 Set.HuntBegins
