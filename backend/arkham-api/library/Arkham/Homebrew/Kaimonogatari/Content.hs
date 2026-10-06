{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.Kaimonogatari.Content where

import Arkham.Homebrew.Kaimonogatari.Campaign (kaimonogatari)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":kaimonogatari", HomebrewCampaign kaimonogatari)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data KaimonogatariContent

instance IsHomebrewContent KaimonogatariContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
