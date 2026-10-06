{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.CyclopeanFoundations.Content where

import Arkham.Homebrew.CyclopeanFoundations.Campaign (cyclopeanfoundations)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":cyclopean-foundations", HomebrewCampaign cyclopeanfoundations)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data CyclopeanFoundationsContent

instance IsHomebrewContent CyclopeanFoundationsContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
