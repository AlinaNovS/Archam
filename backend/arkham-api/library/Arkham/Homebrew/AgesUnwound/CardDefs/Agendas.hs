module Arkham.Homebrew.AgesUnwound.CardDefs.Agendas where

import Arkham.Agenda.CardDefs.Import
import Arkham.Homebrew.AgesUnwound.Sets qualified as Set

-- night_of_fire
hunted :: CardDef
hunted =
  agenda ":ages-unwound:002" "Hunted" 1 Set.NightOfFire
    & otherSideIs ":ages-unwound:003"

somethingUnnatural :: CardDef
somethingUnnatural = agenda ":ages-unwound:003" "Something Unnatural" 1 Set.NightOfFire

watched :: CardDef
watched =
  agenda ":ages-unwound:004" "Watched" 2 Set.NightOfFire
    & otherSideIs ":ages-unwound:005"

sentinel :: CardDef
sentinel = agenda ":ages-unwound:005" "Sentinel" 2 Set.NightOfFire

gazeOfThreeEyes :: CardDef
gazeOfThreeEyes =
  agenda ":ages-unwound:006" "Gaze of Three Eyes" 3 Set.NightOfFire
    & otherSideIs ":ages-unwound:007"

morningBreaks :: CardDef
morningBreaks = agenda ":ages-unwound:007" "Morning Breaks" 3 Set.NightOfFire
