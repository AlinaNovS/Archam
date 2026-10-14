{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.SymphonyOfErichZann.Defs (module Arkham.Homebrew.SymphonyOfErichZann.Defs) where

import Arkham.Homebrew.DefsBase
import Arkham.Homebrew.Generate (generateHomebrewCardDefs)
import Arkham.Homebrew.SymphonyOfErichZann.CardDefEntries ()

data SymphonyOfErichZannDefs

-- | Card definitions are discovered: every @<name> :: CardDef@ under
-- @CardDefs/@ is registered automatically (see
-- Arkham.Homebrew.BloodborneCityOfTheUnseen.Defs for why this file, not just
-- CardDefEntries.hs, is required).
instance IsHomebrewDefs SymphonyOfErichZannDefs where
  homebrewDefs = discoveredDefs $(generateHomebrewCardDefs)
