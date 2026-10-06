{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.TheWarOfTheWorlds.Content where

import Arkham.Homebrew.TheWarOfTheWorlds.Campaign (thewaroftheworlds)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-war-of-the-worlds", HomebrewCampaign thewaroftheworlds)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data TheWarOfTheWorldsContent

instance IsHomebrewContent TheWarOfTheWorldsContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
