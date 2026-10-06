{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.HeartOfDarkness.Content where

import Arkham.Homebrew.HeartOfDarkness.Campaign (heartofdarkness)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":heart-of-darkness", HomebrewCampaign heartofdarkness)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data HeartOfDarknessContent

instance IsHomebrewContent HeartOfDarknessContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
