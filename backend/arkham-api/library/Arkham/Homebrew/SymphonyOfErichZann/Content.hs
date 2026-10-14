{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.SymphonyOfErichZann.Content where

import Arkham.Homebrew.Import
import Arkham.Homebrew.SymphonyOfErichZann.CardEntries ()
import Arkham.Homebrew.SymphonyOfErichZann.Campaign (symphonyOfErichZann)
import Arkham.Homebrew.SymphonyOfErichZann.Scenarios.SymphonyOfErichZann (symphonyOfErichZannScenario)
import Arkham.Homebrew.SymphonyOfErichZann.Sets

scenarios :: HomebrewScenarios
scenarios =
  [ (":symphony-of-erich-zann:001", HomebrewScenario SymphonyOfErichZann symphonyOfErichZannScenario)
  ]

campaigns :: HomebrewCampaigns
campaigns = [(":symphony-of-erich-zann", HomebrewCampaign symphonyOfErichZann)]

data SymphonyOfErichZannContent

instance IsHomebrewContent SymphonyOfErichZannContent where
  homebrewContent =
    $(generateHomebrew)
      { scenarios = scenarios
      , campaigns = campaigns
      }
