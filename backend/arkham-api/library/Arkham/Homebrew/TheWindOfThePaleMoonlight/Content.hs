{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.TheWindOfThePaleMoonlight.Content where

import Arkham.Homebrew.TheWindOfThePaleMoonlight.Campaign (thewindofthepalemoonlight)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-wind-of-the-pale-moonlight", HomebrewCampaign thewindofthepalemoonlight)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data TheWindOfThePaleMoonlightContent

instance IsHomebrewContent TheWindOfThePaleMoonlightContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
