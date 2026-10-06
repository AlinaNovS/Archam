{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.HalfLife.Content where

import Arkham.Homebrew.HalfLife.Campaign (halflife)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":half-life", HomebrewCampaign halflife)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data HalfLifeContent

instance IsHomebrewContent HalfLifeContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
