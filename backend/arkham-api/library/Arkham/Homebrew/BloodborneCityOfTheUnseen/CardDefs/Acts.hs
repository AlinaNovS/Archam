module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts where

import Arkham.Act.CardDefs.Import
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set

-- hunt_begins
-- | Names and real play order confirmed by visually reading the act cards
-- from the SCED TTS source -- 2026-10-07. Printed deck-position labels on
-- the cards themselves (e.g. "Act 1a" on Moonlit Revival, "Act 4a" on The
-- Beast and the Crow) do NOT match this scenario's actual play order -- they
-- appear to be campaign-wide print numbers shared across all 8 scenarios,
-- not scenario-local sequence numbers. Trusted the printed flavor text
-- itself (Moonlit Revival references waking at the Hospital Courtyard,
-- matching Scenario 1's own opening) over the printed act label.
moonlitRevival :: CardDef
moonlitRevival = act ":bloodborne-city-of-the-unseen:008" "Moonlit Revival" 1 Set.HuntBegins

cityOfTheUnseen :: CardDef
cityOfTheUnseen = act ":bloodborne-city-of-the-unseen:009" "The City of the Unseen" 2 Set.HuntBegins

{- | "Barricade" removal (spend 1 clue, or test agility 4) and the "Viola
Gascoigne in victory display" advance condition are NOT YET IMPLEMENTED --
the barricade mechanic doesn't exist anywhere in this engine yet and would
need a new location-connection-state concept; Viola Gascoigne doesn't have a
CardDef. Stage number reserved correctly, no custom advance wired -- matches
the project's established "real name, placeholder mechanic" pattern (see
AgesUnwound's own Acts.findSafety).
-}
violasWish :: CardDef
violasWish = act ":bloodborne-city-of-the-unseen:010" "Viola's Wish" 3 Set.HuntBegins

-- | Same NOT YET IMPLEMENTED caveat as 'violasWish' -- barricade removal +
-- "if all investigators have resigned: advance" advance condition.
beastAndTheCrow :: CardDef
beastAndTheCrow = act ":bloodborne-city-of-the-unseen:011" "The Beast and the Crow" 4 Set.HuntBegins
