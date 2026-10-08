module Arkham.Homebrew.BloodborneCityOfTheUnseen.CampaignSteps where

import Arkham.CampaignStep
import Arkham.Prelude

pattern HuntBeginsStep :: CampaignStep
pattern HuntBeginsStep <- ScenarioStep ":bloodborne-city-of-the-unseen:001"
  where
    HuntBeginsStep = ScenarioStep ":bloodborne-city-of-the-unseen:001"
