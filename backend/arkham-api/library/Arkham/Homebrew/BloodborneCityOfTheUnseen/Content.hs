{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.BloodborneCityOfTheUnseen.Content where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign (bloodborneCityOfTheUnseen)
import Arkham.Homebrew.Import

campaigns :: HomebrewCampaigns
campaigns = [(":bloodborne-city-of-the-unseen", HomebrewCampaign bloodborneCityOfTheUnseen)]

{- | This campaign introduces zero new cards (it's a pure reuse of already-
implemented official standalone scenarios -- see 'Campaign.hs'), so unlike
every other Homebrew/<Campaign>/Content.hs, there is no CardDefs/ directory
and no CardEntries.hs/CardDefEntries.hs discovery step here: 'generateHomebrew'
is spliced with no local card-discovery imports feeding it, so acts/agendas/
assets/enemies/locations/stories/treacheries all come through as their
'HomebrewContent' Monoid-empty defaults, and only 'campaigns' is overridden.
-}
data BloodborneCityOfTheUnseenContent

instance IsHomebrewContent BloodborneCityOfTheUnseenContent where
  homebrewContent =
    $(generateHomebrew)
      { campaigns = campaigns
      }
