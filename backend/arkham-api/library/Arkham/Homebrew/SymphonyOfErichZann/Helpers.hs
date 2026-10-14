module Arkham.Homebrew.SymphonyOfErichZann.Helpers where

import Arkham.I18n

campaignI18n :: (HasI18n => a) -> a
campaignI18n a = withI18n $ scope "symphonyOfErichZann" a

scenarioI18n :: Scope -> (HasI18n => a) -> a
scenarioI18n scenarioScope a = campaignI18n $ scope scenarioScope a
