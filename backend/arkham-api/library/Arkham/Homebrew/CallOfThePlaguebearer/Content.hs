{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.CallOfThePlaguebearer.Content where

import Arkham.Homebrew.CallOfThePlaguebearer.Campaign (calloftheplaguebearer)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":call-of-the-plaguebearer", HomebrewCampaign calloftheplaguebearer)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data CallOfThePlaguebearerContent

instance IsHomebrewContent CallOfThePlaguebearerContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
