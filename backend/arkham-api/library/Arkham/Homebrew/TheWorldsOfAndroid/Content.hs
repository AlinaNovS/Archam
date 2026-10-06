{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.TheWorldsOfAndroid.Content where

import Arkham.Homebrew.TheWorldsOfAndroid.Campaign (theworldsofandroid)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-worlds-of-android", HomebrewCampaign theworldsofandroid)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data TheWorldsOfAndroidContent

instance IsHomebrewContent TheWorldsOfAndroidContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
