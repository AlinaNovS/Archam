{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.AgesUnwound.Defs (module Arkham.Homebrew.AgesUnwound.Defs) where

import Arkham.Homebrew.AgesUnwound.CardDefEntries ()
import Arkham.Homebrew.DefsBase
import Arkham.Homebrew.Generate (generateHomebrewCardDefs)

data AgesUnwoundDefs

{- | Card definitions are discovered: every @<name> :: CardDef@ under
@CardDefs/@ is registered, and sorted by its card type (see 'discoveredDefs').
No campaign-specific traits or actions are needed yet for the Scenario I
pilot slice, so 'hdTraits'/'hdActions'/'hdActionAffordability' are left at
their 'discoveredDefs' defaults (empty).
-}
instance IsHomebrewDefs AgesUnwoundDefs where
  homebrewDefs = discoveredDefs $(generateHomebrewCardDefs)
