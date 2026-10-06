{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.CloseEncountersOfTheLv426Kind.Content where

import Arkham.Homebrew.CloseEncountersOfTheLv426Kind.Campaign (closeencountersofthelv426kind)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":close-encounters-of-the-lv-426-kind", HomebrewCampaign closeencountersofthelv426kind)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data CloseEncountersOfTheLv426KindContent

instance IsHomebrewContent CloseEncountersOfTheLv426KindContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
