module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies where

import Arkham.Enemy.CardDefs.Import
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set
import Arkham.Keyword qualified as Keyword
import Arkham.Trait (Trait (HomebrewTrait))

-- hunt_begins
-- | Fight/Health/Evade confirmed by visually reading the real card scan
-- (bloodborne_city_of_the_unseen.json, "Blood-Drunk Hunter"). Damage/horror
-- dealt on attack are NOT legible on this card's non-standard icon layout
-- (two unlabeled red glyphs near "Victory 0", no printed numbers found) --
-- using the conservative LCG baseline of 1/0 as an explicit, documented
-- placeholder rather than guessing a specific unconfirmed value. "Spoils -
-- Threaded Cane" (an asset reward on defeat) is NOT YET IMPLEMENTED.
bloodDrunkHunter :: CardDef
bloodDrunkHunter =
  (enemy ":bloodborne-city-of-the-unseen:017" "Blood-Drunk Hunter" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 5
    , cdEvade = evade 5
    , cdHealth = health 2
    , cdKeywords = setFromList [Keyword.Hunter]
    , cdCardTraits =
        setFromList
          [ Humanoid
          , HomebrewTrait "Blood-Drunk"
          , HomebrewTrait "Hunter of Yharnam"
          , Elite
          ]
    , cdVictoryPoints = Just 0
    }

{- | Fight/Evade confirmed by visually reading the real card. Health is
"4, plus an additional 2 per investigator" (printed base 4 + a separate
per-investigator bonus line) -- 'StaticWithPerPlayer 4 2' matches this
exactly (base + per-player term), not 'healthPerInvestigator' alone (which
would scale the ENTIRE health with player count, not just a bonus on top of
a fixed base). The two "Objective" resolution-branch lines (->R2/->R3) are
NOT YET IMPLEMENTED -- no resolution/campaign-log structure exists yet for
this pilot scenario (single ending only), nothing to branch to.
-}
clericBeast :: CardDef
clericBeast =
  (enemy ":bloodborne-city-of-the-unseen:018" "Cleric Beast" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 4
    , cdEvade = evade 2
    , cdHealth = Just (Health (StaticWithPerPlayer 4 2))
    , cdKeywords = setFromList [Keyword.Hunter, Keyword.Massive]
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Beast", Mutated, Elite]
    , cdVictoryPoints = Just 1
    }

{- | "Act 2 Encounter Deck Additions" -- 7 more unique encounter cards
(5 enemies, 2 treacheries below) confirmed via the real TTS set-aside pile
(bloodborne_city_of_the_unseen.json, hunt's "Set-aside" -> "Act 2 Encounter
Deck Additions"), found live 2026-10-09 after the player reported the
encounter deck should have more than the original 8 unique cards. Officially
these shuffle into the deck only once Act 2 begins; for this pilot slice
they're gathered into Set.HuntBegins from the start instead (documented
simplification, not the exact official timing) -- see Scenarios/HuntBegins.hs.
Fight/Health/Evade/traits/keywords confirmed by visually reading each real
card. Unique text abilities (Prey, Forced effects, X-value Fight/Health) are
NOT YET IMPLEMENTED -- CardDef + stats only, matching the established
pilot-slice pattern.
-}
scourgeBeast :: CardDef
scourgeBeast =
  (enemy ":bloodborne-city-of-the-unseen:027" "Scourge Beast" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 3
    , cdEvade = evade 3
    , cdHealth = health 3
    , cdKeywords = setFromList [Keyword.Hunter]
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Beast"]
    , cdVictoryPoints = Just 2
    }

-- | "Swarming 1" confirmed on the real card.
huntingParty :: CardDef
huntingParty =
  (enemy ":bloodborne-city-of-the-unseen:028" "Hunting Party" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 3
    , cdEvade = evade 3
    , cdHealth = health 1
    , cdKeywords = setFromList [Keyword.Hunter, Keyword.Swarming (Static 1)]
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Blood-Drunk"]
    , cdVictoryPoints = Just 0
    }

elderlyHuntsman :: CardDef
elderlyHuntsman =
  (enemy ":bloodborne-city-of-the-unseen:029" "Elderly Huntsman" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 4
    , cdEvade = evade 1
    , cdHealth = health 1
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Blood-Drunk"]
    , cdVictoryPoints = Just 0
    }

{- | Printed Fight is "X" (= count of same-named enemies at its location,
including swarm cards) -- using a conservative fixed placeholder of 1
(documented, not guessed at the real dynamic value) since the X-value
Fight mechanic isn't wired yet. "Swarming 1" confirmed on the real card.
-}
bloodCrazedHuntingHounds :: CardDef
bloodCrazedHuntingHounds =
  (enemy ":bloodborne-city-of-the-unseen:030" "Blood-Crazed Hunting Hounds" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 1
    , cdEvade = evade 3
    , cdHealth = health 1
    , cdKeywords = setFromList [Keyword.Hunter, Keyword.Swarming (Static 1)]
    , cdCardTraits = setFromList [Creature, HomebrewTrait "Blood-Drunk"]
    , cdVictoryPoints = Just 0
    }

{- | Printed Health is "X" (= count of Beast enemies at its own location,
including itself) -- using a conservative fixed placeholder of 3 (documented,
not guessed at the real dynamic value) since the X-value Health mechanic
isn't wired yet.
-}
ashenBloodBeast :: CardDef
ashenBloodBeast =
  (enemy ":bloodborne-city-of-the-unseen:031" "Ashen Blood Beast" Set.HuntBegins 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 2
    , cdEvade = evade 4
    , cdHealth = health 3
    , cdKeywords = setFromList [Keyword.Hunter]
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Beast"]
    , cdVictoryPoints = Just 1
    }
