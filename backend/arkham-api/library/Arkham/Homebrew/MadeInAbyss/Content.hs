{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.MadeInAbyss.Content where

import Arkham.Homebrew.MadeInAbyss.Campaign (madeinabyss)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":made-in-abyss", HomebrewCampaign madeinabyss)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data MadeInAbyssContent

instance IsHomebrewContent MadeInAbyssContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
