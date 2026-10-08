module Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign (bloodborneCityOfTheUnseen) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CampaignSteps
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Import

newtype BloodborneCityOfTheUnseen = BloodborneCityOfTheUnseen CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

bloodborneCityOfTheUnseen :: Difficulty -> BloodborneCityOfTheUnseen
bloodborneCityOfTheUnseen =
  campaign BloodborneCityOfTheUnseen (CampaignId ":bloodborne-city-of-the-unseen") "Bloodborne - City of the Unseen"

{- | 2026-10-07: replaced the earlier pilot (which chained 18 unrelated
already-implemented OFFICIAL standalone scenarios under this campaign's name
-- a reskin, not real Bloodborne content, correctly flagged by the user as
misleading) with the start of a REAL implementation, sourced directly from
this campaign's own TTS mod data (bloodborne_city_of_the_unseen.json via the
Chr1Z93/SCED-downloads library.json catalog -- confirmed via the in-game
mod's own "Downloadable Content" loader, author 'aughhhh', 8 real scenarios).

Only Scenario 1 ("The Hunt Begins") exists so far -- see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins' for its own
scope notes. Scenarios 2-8 are not started.
-}
instance IsCampaign BloodborneCityOfTheUnseen where
  campaignTokens = chaosBagContents
  nextStep a = case (toAttrs a).normalizedStep of
    PrologueStep -> continue HuntBeginsStep
    HuntBeginsStep -> Nothing
    other -> defaultNextStep other

instance RunMessage BloodborneCityOfTheUnseen where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    _ -> lift $ defaultCampaignRunner msg c
