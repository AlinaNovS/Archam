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
