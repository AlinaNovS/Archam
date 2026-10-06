{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.TheApproachingStorm.Content where

import Arkham.Homebrew.TheApproachingStorm.Campaign (theapproachingstorm)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-approaching-storm", HomebrewCampaign theapproachingstorm)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data TheApproachingStormContent

instance IsHomebrewContent TheApproachingStormContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
