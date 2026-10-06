{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.SoulsOfDarkness.Content where

import Arkham.Homebrew.SoulsOfDarkness.Campaign (soulsofdarkness)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":souls-of-darkness", HomebrewCampaign soulsofdarkness)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data SoulsOfDarknessContent

instance IsHomebrewContent SoulsOfDarknessContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
