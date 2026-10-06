{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.Lovecrafter3077.Content where

import Arkham.Homebrew.Lovecrafter3077.Campaign (lovecrafter3077)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":lovecrafter-3077", HomebrewCampaign lovecrafter3077)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data Lovecrafter3077Content

instance IsHomebrewContent Lovecrafter3077Content where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
