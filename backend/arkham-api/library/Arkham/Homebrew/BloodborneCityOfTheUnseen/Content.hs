{-# LANGUAGE TemplateHaskell #-}

module Arkham.Homebrew.BloodborneCityOfTheUnseen.Content where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardEntries ()
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign (bloodborneCityOfTheUnseen)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins (huntBegins)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets
import Arkham.Homebrew.Import

scenarios :: HomebrewScenarios
scenarios =
  [ (":bloodborne-city-of-the-unseen:001", HomebrewScenario HuntBegins huntBegins)
  ]

campaigns :: HomebrewCampaigns
campaigns = [(":bloodborne-city-of-the-unseen", HomebrewCampaign bloodborneCityOfTheUnseen)]

data BloodborneCityOfTheUnseenContent

instance IsHomebrewContent BloodborneCityOfTheUnseenContent where
  homebrewContent =
    $(generateHomebrew)
      { scenarios = scenarios
      , campaigns = campaigns
      }
