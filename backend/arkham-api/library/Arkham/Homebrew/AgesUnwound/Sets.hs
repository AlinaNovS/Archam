module Arkham.Homebrew.AgesUnwound.Sets (
  module Arkham.EncounterSet,
  pattern NightOfFire,
  pattern AgentsOfAforgomon,
  pattern Nyctophobia,
  pattern Thugs,
  pattern UnravellingAges,
) where

import Arkham.EncounterSet

pattern NightOfFire :: EncounterSet
pattern NightOfFire = Homebrew ":ages-unwound:night_of_fire"

pattern AgentsOfAforgomon :: EncounterSet
pattern AgentsOfAforgomon = Homebrew ":ages-unwound:agents_of_aforgomon"

pattern Nyctophobia :: EncounterSet
pattern Nyctophobia = Homebrew ":ages-unwound:nyctophobia"

pattern Thugs :: EncounterSet
pattern Thugs = Homebrew ":ages-unwound:thugs"

pattern UnravellingAges :: EncounterSet
pattern UnravellingAges = Homebrew ":ages-unwound:unravelling_ages"
