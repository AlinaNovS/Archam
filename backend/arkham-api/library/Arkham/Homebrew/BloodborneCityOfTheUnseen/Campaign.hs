module Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign (bloodborneCityOfTheUnseen) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.ChaosBag
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers

newtype BloodborneCityOfTheUnseen = BloodborneCityOfTheUnseen CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

bloodborneCityOfTheUnseen :: Difficulty -> BloodborneCityOfTheUnseen
bloodborneCityOfTheUnseen =
  campaign BloodborneCityOfTheUnseen (CampaignId ":bloodborne-city-of-the-unseen") "Bloodborne - City of the Unseen"

{- | Pilot slice: a pure "reuse already-implemented official standalone
scenarios in sequence" campaign, no new game mechanics at all. Each
'StandaloneScenarioStep' carries its own successor built in
('defaultNextStep' already unwinds this chain automatically -- confirmed by
reading 'Arkham.CampaignStep.defaultNextStep'), so the entire sequence can be
set up once from 'PrologueStep' with no further custom step-handling needed.

Matches 18 of the 19 confirmed-implemented standalone scenarios listed in
@frontend/homebrew/bloodborne-city-of-the-unseen/scenarios.json@, in the same
order the JSON lists them. 'guardiansOfTheAbyss' is skipped (see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers' for why) -- a real,
flagged gap, not an oversight. The other ~30 scenarios.json entries beyond
the first 19 are unrelated SCED-community fan scenarios of unconfirmed
implementation status in this engine; also not wired here.

No per-scenario narrative/interlude text has been transcribed (no official
guide exists for this fan "anthology" campaign to transcribe from) -- running
it will use each scenario's own existing prologue/setup text as normal, with
no Bloodborne-specific framing text between scenarios. This is a genuine,
openly-scoped gap for the pilot, not a bug.
-}
instance IsCampaign BloodborneCityOfTheUnseen where
  campaignTokens = chaosBagContents
  nextStep a = case (toAttrs a).normalizedStep of
    PrologueStep -> continue scenarioChain
    other -> defaultNextStep other
   where
    scenarioChain =
      StandaloneScenarioStep curseOfTheRougarouId
        $ StandaloneScenarioStep carnevaleOfHorrorsId
        $ StandaloneScenarioStep theLabyrinthsOfLunacyId
        $ StandaloneScenarioStep murderAtTheExcelsiorHotelId
        $ StandaloneScenarioStep theBlobThatAteEverythingId
        $ StandaloneScenarioStep warOfTheOuterGodsId
        $ StandaloneScenarioStep machinationsThroughTimeId
        $ StandaloneScenarioStep fortuneAndFollyId
        $ StandaloneScenarioStep theMidwinterGalaId
        $ StandaloneScenarioStep filmFataleId
        $ StandaloneScenarioStep allOrNothingId
        $ StandaloneScenarioStep badBloodId
        $ StandaloneScenarioStep byTheBookId
        $ StandaloneScenarioStep laidToRestId
        $ StandaloneScenarioStep readOrDieId
        $ StandaloneScenarioStep redTideRisingId
        $ StandaloneScenarioStep relicsOfThePastId
        $ StandaloneScenarioStep enthrallingEncoreId EpilogueStep

instance RunMessage BloodborneCityOfTheUnseen where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    CampaignStep EpilogueStep -> do
      push GameOver
      pure c
    _ -> lift $ defaultCampaignRunner msg c
