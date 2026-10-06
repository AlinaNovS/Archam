{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.IntoTheShadowlands.Content where

import Arkham.Homebrew.IntoTheShadowlands.Campaign (intotheshadowlands)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":into-the-shadowlands", HomebrewCampaign intotheshadowlands)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data IntoTheShadowlandsContent

instance IsHomebrewContent IntoTheShadowlandsContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
