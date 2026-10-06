{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.ThePutridTestament.Content where

import Arkham.Homebrew.ThePutridTestament.Campaign (theputridtestament)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-putrid-testament", HomebrewCampaign theputridtestament)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data ThePutridTestamentContent

instance IsHomebrewContent ThePutridTestamentContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
