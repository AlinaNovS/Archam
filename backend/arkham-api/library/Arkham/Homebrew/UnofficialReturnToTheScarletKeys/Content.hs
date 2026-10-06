{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.UnofficialReturnToTheScarletKeys.Content where

import Arkham.Homebrew.UnofficialReturnToTheScarletKeys.Campaign (unofficialreturntothescarletkeys)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":unofficial-return-to-the-scarlet-keys", HomebrewCampaign unofficialreturntothescarletkeys)]

-- | Zero new cards, same as BloodborneCityOfTheUnseen -- see that module's
-- Content.hs for why no CardDefs/ discovery step is needed here.
data UnofficialReturnToTheScarletKeysContent

instance IsHomebrewContent UnofficialReturnToTheScarletKeysContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
