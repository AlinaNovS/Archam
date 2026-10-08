{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.BloodborneCityOfTheUnseen.Defs (module Arkham.Homebrew.BloodborneCityOfTheUnseen.Defs) where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefEntries ()
import Arkham.Homebrew.DefsBase
import Arkham.Homebrew.Generate (generateHomebrewCardDefs)

data BloodborneCityOfTheUnseenDefs

{- | Card definitions are discovered: every @<name> :: CardDef@ under
@CardDefs/@ is registered, and sorted by its card type (see 'discoveredDefs').
No campaign-specific traits or actions are needed yet for this pilot slice,
so 'hdTraits'/'hdActions'/'hdActionAffordability' are left at their
'discoveredDefs' defaults (empty). Missing this file (not just CardDefEntries.hs)
was the real root cause of "missing card def for location" at runtime --
2026-10-08, found live.
-}
instance IsHomebrewDefs BloodborneCityOfTheUnseenDefs where
  homebrewDefs = discoveredDefs $(generateHomebrewCardDefs)
