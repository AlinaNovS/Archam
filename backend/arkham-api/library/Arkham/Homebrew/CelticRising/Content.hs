{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.CelticRising.Content where

import Arkham.Homebrew.CelticRising.Campaign (celticrising)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":celtic-rising", HomebrewCampaign celticrising)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data CelticRisingContent

instance IsHomebrewContent CelticRisingContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
