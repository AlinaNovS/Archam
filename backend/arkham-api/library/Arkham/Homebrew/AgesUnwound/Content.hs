{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.AgesUnwound.Content where

import Arkham.Homebrew.AgesUnwound.Campaign (agesUnwound)
import Arkham.Homebrew.AgesUnwound.CardEntries ()
import Arkham.Homebrew.AgesUnwound.Scenarios.NightOfFire (nightOfFire)
import Arkham.Homebrew.AgesUnwound.Sets
import Arkham.Homebrew.Import

scenarios :: HomebrewScenarios
scenarios =
  [ (":ages-unwound:001", HomebrewScenario NightOfFire nightOfFire)
  ]

campaigns :: HomebrewCampaigns
campaigns = [(":ages-unwound", HomebrewCampaign agesUnwound)]

data AgesUnwoundContent

instance IsHomebrewContent AgesUnwoundContent where
  homebrewContent =
    $(generateHomebrew)
      { scenarios = scenarios
      , campaigns = campaigns
      }
