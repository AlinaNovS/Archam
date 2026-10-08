module Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets (
  module Arkham.EncounterSet,
  pattern HuntBegins,
) where

import Arkham.EncounterSet

pattern HuntBegins :: EncounterSet
pattern HuntBegins = Homebrew ":bloodborne-city-of-the-unseen:hunt_begins"
