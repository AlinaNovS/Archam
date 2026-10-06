module Arkham.Homebrew.AgesUnwound.CardDefs.Locations where

import Arkham.Homebrew.AgesUnwound.Sets qualified as Set
import Arkham.Location.CardDefs.Import

-- night_of_fire
-- | Icon + connections confirmed via the SCED TTS source (GMNotes
-- locationFront: icons "Circle", connections "Square|Moon|Diamond|Empty";
-- the "Empty" slot is an unlinked connector on the card art, not an actual
-- connection, so it's omitted here) -- 2026-10-06. Clue count (uses:
-- countPerInvestigator 1) not yet wired; shroud value still a placeholder.
rivertown :: CardDef
rivertown = location ":ages-unwound:008" "Rivertown" mempty Circle [Square, Moon, Diamond] Set.NightOfFire
