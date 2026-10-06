{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.EchoesOfTheAncientSands.Content where

import Arkham.Homebrew.EchoesOfTheAncientSands.Campaign (echoesoftheancientsands)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":echoes-of-the-ancient-sands", HomebrewCampaign echoesoftheancientsands)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data EchoesOfTheAncientSandsContent

instance IsHomebrewContent EchoesOfTheAncientSandsContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
