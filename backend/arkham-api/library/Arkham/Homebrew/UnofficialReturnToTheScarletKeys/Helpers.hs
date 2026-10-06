module Arkham.Homebrew.UnofficialReturnToTheScarletKeys.Helpers where

import Arkham.I18n
import Arkham.Id
import Arkham.Prelude

campaignI18n :: (HasI18n => a) -> a
campaignI18n a = withI18n $ scope "unofficialreturntothescarletkeys" a

allOrNothingId :: ScenarioId
allOrNothingId = "90011"
badBloodId :: ScenarioId
badBloodId = "90020"
byTheBookId :: ScenarioId
byTheBookId = "90032"
carnevaleOfHorrorsId :: ScenarioId
carnevaleOfHorrorsId = "82001"
curseOfTheRougarouId :: ScenarioId
curseOfTheRougarouId = "81001"
enthrallingEncoreId :: ScenarioId
enthrallingEncoreId = "90094"
filmFataleId :: ScenarioId
filmFataleId = "72001"
fortuneAndFollyId :: ScenarioId
fortuneAndFollyId = "88001"
laidToRestId :: ScenarioId
laidToRestId = "90054"
machinationsThroughTimeId :: ScenarioId
machinationsThroughTimeId = "87001"
murderAtTheExcelsiorHotelId :: ScenarioId
murderAtTheExcelsiorHotelId = "84001"
readOrDieId :: ScenarioId
readOrDieId = "90004"
redTideRisingId :: ScenarioId
redTideRisingId = "90041"
relicsOfThePastId :: ScenarioId
relicsOfThePastId = "90065"
theBlobThatAteEverythingId :: ScenarioId
theBlobThatAteEverythingId = "85001"
theLabyrinthsOfLunacyId :: ScenarioId
theLabyrinthsOfLunacyId = "70001"
theMidwinterGalaId :: ScenarioId
theMidwinterGalaId = "71001"
warOfTheOuterGodsId :: ScenarioId
warOfTheOuterGodsId = "86001"
