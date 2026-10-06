{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.DarkhamHorror.Content where

import Arkham.Homebrew.DarkhamHorror.Campaign (darkhamhorror)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":darkham-horror", HomebrewCampaign darkhamhorror)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data DarkhamHorrorContent

instance IsHomebrewContent DarkhamHorrorContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
