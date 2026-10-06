module Arkham.Homebrew.TheWarOfTheWorlds.Campaign (thewaroftheworlds) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.TheWarOfTheWorlds.ChaosBag
import Arkham.Homebrew.TheWarOfTheWorlds.Helpers

newtype TheWarOfTheWorlds = TheWarOfTheWorlds CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

thewaroftheworlds :: Difficulty -> TheWarOfTheWorlds
thewaroftheworlds =
  campaign TheWarOfTheWorlds (CampaignId ":the-war-of-the-worlds") "The War of the Worlds"

{- | Generated alongside the BloodborneCityOfTheUnseen pilot -- same shared
SCED-anthology template, same reuse-only-the-18-confirmed-official-scenarios
approach, same StandaloneScenarioStep chaining mechanism (see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign' for the full writeup of
how/why this works).
guardiansOfTheAbyss (nested mini-campaign, not a flat scenario) is skipped, same as Bloodborne.
-}
instance IsCampaign TheWarOfTheWorlds where
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

instance RunMessage TheWarOfTheWorlds where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    CampaignStep EpilogueStep -> do
      push GameOver
      pure c
    _ -> lift $ defaultCampaignRunner msg c
