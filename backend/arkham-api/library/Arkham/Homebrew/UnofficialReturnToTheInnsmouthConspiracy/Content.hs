{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.UnofficialReturnToTheInnsmouthConspiracy.Content where

import Arkham.Homebrew.UnofficialReturnToTheInnsmouthConspiracy.Campaign (unofficialreturntotheinnsmouthconspiracy)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":unofficial-return-to-the-innsmouth-conspiracy", HomebrewCampaign unofficialreturntotheinnsmouthconspiracy)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data UnofficialReturnToTheInnsmouthConspiracyContent

instance IsHomebrewContent UnofficialReturnToTheInnsmouthConspiracyContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
