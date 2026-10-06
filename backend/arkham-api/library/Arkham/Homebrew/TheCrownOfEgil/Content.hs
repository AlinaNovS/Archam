{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.TheCrownOfEgil.Content where

import Arkham.Homebrew.TheCrownOfEgil.Campaign (thecrownofegil)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":the-crown-of-egil", HomebrewCampaign thecrownofegil)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data TheCrownOfEgilContent

instance IsHomebrewContent TheCrownOfEgilContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
