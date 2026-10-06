{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.BetrayalAtTheMountainsOfMadness.Content where

import Arkham.Homebrew.BetrayalAtTheMountainsOfMadness.Campaign (betrayalatthemountainsofmadness)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":betrayal-at-the-mountains-of-madness", HomebrewCampaign betrayalatthemountainsofmadness)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data BetrayalAtTheMountainsOfMadnessContent

instance IsHomebrewContent BetrayalAtTheMountainsOfMadnessContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
