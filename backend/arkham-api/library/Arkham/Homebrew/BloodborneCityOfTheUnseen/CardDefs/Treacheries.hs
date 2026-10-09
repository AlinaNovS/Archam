module Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets qualified as Set
import Arkham.Trait (Trait (HomebrewTrait))
import Arkham.Treachery.CardDefs.Import

{- | hunt_begins encounter deck, 8 unique cards (2 copies each except Dreadful
Effigy, 1 copy -- confirmed by counting entries in the real TTS encounter
deck). Names/traits confirmed via each card's own GMNotes (visually
cross-checked against the deck listing, not guessed). Unique effects are
NOT YET IMPLEMENTED -- each card currently just reveals and resolves to the
default discard with no special effect; see the matching instance file in
Treacheries/ for the explicit placeholder RunMessage. "Scheme"/"Omen"/
"Hazard"/"Madness"/"Terror"/"Curse"/"Poison" aren't official traits for most
of these combinations -- used 'HomebrewTrait' for anything not already a
real constructor in 'Arkham.Trait', confirmed per-trait rather than assumed.
-}
yharnamHospitality :: CardDef
yharnamHospitality =
  (treachery ":bloodborne-city-of-the-unseen:019" "Yharnam Hospitality" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Scheme", Attack]
    }

uncontrolledFire :: CardDef
uncontrolledFire =
  (treachery ":bloodborne-city-of-the-unseen:020" "Uncontrolled Fire" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Hazard"]
    }

theSweetStench :: CardDef
theSweetStench =
  (treachery ":bloodborne-city-of-the-unseen:021" "The Sweet Stench" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Omen"]
    }

slakeTheThirst :: CardDef
slakeTheThirst =
  (treachery ":bloodborne-city-of-the-unseen:022" "Slake the Thirst" Set.HuntBegins 2)
    { cdCardTraits = setFromList [Madness]
    }

rudeAwakening :: CardDef
rudeAwakening =
  (treachery ":bloodborne-city-of-the-unseen:023" "Rude Awakening" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Omen"]
    }

dreadfulEffigy :: CardDef
dreadfulEffigy =
  (treachery ":bloodborne-city-of-the-unseen:024" "Dreadful Effigy" Set.HuntBegins 1)
    { cdCardTraits = setFromList [Terror, HomebrewTrait "Omen"]
    }

bloodDrunkTreachery :: CardDef
bloodDrunkTreachery =
  (treachery ":bloodborne-city-of-the-unseen:025" "Blood-Drunk" Set.HuntBegins 2)
    { cdCardTraits = setFromList [Madness, Curse]
    }

ashenAffliction :: CardDef
ashenAffliction =
  (treachery ":bloodborne-city-of-the-unseen:026" "Ashen Affliction" Set.HuntBegins 2)
    { cdCardTraits = setFromList [Poison]
    }

{- | "Act 2 Encounter Deck Additions" -- confirmed via the real TTS set-aside
pile, same batch as the 5 new enemies in CardDefs/Enemies.hs. 2 copies each,
confirmed by counting entries. Gathered into Set.HuntBegins from the start
for this pilot slice (see that file's note on the Enemies additions above).
-}
viewHalloo :: CardDef
viewHalloo =
  (treachery ":bloodborne-city-of-the-unseen:032" "View-Halloo!" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Scheme"]
    }

gleefulAtrocities :: CardDef
gleefulAtrocities =
  (treachery ":bloodborne-city-of-the-unseen:033" "Gleeful Atrocities" Set.HuntBegins 2)
    { cdCardTraits = setFromList [HomebrewTrait "Hazard"]
    }
