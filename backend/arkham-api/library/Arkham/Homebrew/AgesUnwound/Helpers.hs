{- | Pre-existing gap in the orphaned scaffold AgesUnwound was recovered from
(see [[project-arkham-git-workflow]]) -- unlike every other homebrew campaign
(CircusExMortis, DarkMatter, BloodborneCityOfTheUnseen), this file never
existed, even though Campaign.hs and NightOfFire.hs both called
campaignI18n/scenarioI18n as if it did. Never caught before 2026-10-06/07
because this module had 0 references in the compiled binary prior to that.
-}
module Arkham.Homebrew.AgesUnwound.Helpers where

import Arkham.I18n
import Arkham.Prelude

campaignI18n :: (HasI18n => a) -> a
campaignI18n a = withI18n $ scope "agesUnwound" a

scenarioI18n :: Scope -> (HasI18n => a) -> a
scenarioI18n scenarioScope a = campaignI18n $ scope scenarioScope a
