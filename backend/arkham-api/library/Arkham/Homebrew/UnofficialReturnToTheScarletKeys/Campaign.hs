module Arkham.Homebrew.UnofficialReturnToTheScarletKeys.Campaign (unofficialreturntothescarletkeys) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.UnofficialReturnToTheScarletKeys.ChaosBag
import Arkham.Homebrew.UnofficialReturnToTheScarletKeys.Helpers

newtype UnofficialReturnToTheScarletKeys = UnofficialReturnToTheScarletKeys CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

unofficialreturntothescarletkeys :: Difficulty -> UnofficialReturnToTheScarletKeys
unofficialreturntothescarletkeys =
  campaign UnofficialReturnToTheScarletKeys (CampaignId ":unofficial-return-to-the-scarlet-keys") "(Unofficial) Return to The Scarlet Keys"

{- | Generated alongside the BloodborneCityOfTheUnseen pilot -- same shared
SCED-anthology template, same reuse-only-the-18-confirmed-official-scenarios
approach, same StandaloneScenarioStep chaining mechanism (see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign' for the full writeup of
how/why this works).
guardiansOfTheAbyss (nested mini-campaign, not a flat scenario) is skipped, same as Bloodborne.
-}
instance IsCampaign UnofficialReturnToTheScarletKeys where
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

instance RunMessage UnofficialReturnToTheScarletKeys where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    CampaignStep EpilogueStep -> do
      push GameOver
      pure c
    _ -> lift $ defaultCampaignRunner msg c
