{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.WinterWinds.Content where

import Arkham.Homebrew.WinterWinds.Campaign (winterwinds)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":winter-winds", HomebrewCampaign winterwinds)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data WinterWindsContent

instance IsHomebrewContent WinterWindsContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
