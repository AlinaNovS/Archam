module Arkham.Homebrew.TheApproachingStorm.Campaign (theapproachingstorm) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.TheApproachingStorm.ChaosBag
import Arkham.Homebrew.TheApproachingStorm.Helpers

newtype TheApproachingStorm = TheApproachingStorm CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

theapproachingstorm :: Difficulty -> TheApproachingStorm
theapproachingstorm =
  campaign TheApproachingStorm (CampaignId ":the-approaching-storm") "The Approaching Storm"

{- | Generated alongside the BloodborneCityOfTheUnseen pilot -- same shared
SCED-anthology template, same reuse-only-the-18-confirmed-official-scenarios
approach, same StandaloneScenarioStep chaining mechanism (see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign' for the full writeup of
how/why this works).
guardiansOfTheAbyss (nested mini-campaign, not a flat scenario) is skipped, same as Bloodborne.
-}
instance IsCampaign TheApproachingStorm where
  campaignTokens = chaosBagContents
  nextStep a = case (toAttrs a).normalizedStep of
    PrologueStep -> continue scenarioChain
    other -> defaultNextStep other
   where
    scenarioChain =
      StandaloneScenarioStep curseOfTheRougarouId $
      StandaloneScenarioStep carnevaleOfHorrorsId $
      StandaloneScenarioStep theLabyrinthsOfLunacyId $
      StandaloneScenarioStep murderAtTheExcelsiorHotelId $
      StandaloneScenarioStep theBlobThatAteEverythingId $
      StandaloneScenarioStep warOfTheOuterGodsId $
      StandaloneScenarioStep machinationsThroughTimeId $
      StandaloneScenarioStep fortuneAndFollyId $
      StandaloneScenarioStep theMidwinterGalaId $
      StandaloneScenarioStep filmFataleId $
      StandaloneScenarioStep allOrNothingId $
      StandaloneScenarioStep badBloodId $
      StandaloneScenarioStep byTheBookId $
      StandaloneScenarioStep laidToRestId $
      StandaloneScenarioStep readOrDieId $
      StandaloneScenarioStep redTideRisingId $
      StandaloneScenarioStep relicsOfThePastId $
      StandaloneScenarioStep enthrallingEncoreId EpilogueStep

instance RunMessage TheApproachingStorm where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    CampaignStep EpilogueStep -> do
      push GameOver
      pure c
    _ -> lift $ defaultCampaignRunner msg c
