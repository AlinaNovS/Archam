{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.Jumanji.Content where

import Arkham.Homebrew.Jumanji.Campaign (jumanji)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":jumanji", HomebrewCampaign jumanji)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data JumanjiContent

instance IsHomebrewContent JumanjiContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
