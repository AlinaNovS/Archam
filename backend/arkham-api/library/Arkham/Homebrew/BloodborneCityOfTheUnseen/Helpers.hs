module Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers where

import Arkham.I18n
import Arkham.Id
import Arkham.Prelude

campaignI18n :: (HasI18n => a) -> a
campaignI18n a = withI18n $ scope "bloodborneCityOfTheUnseen" a

{- | Scenario codes for the campaign's confirmed-implemented official standalone
scenarios (read from each scenario's own 'Arkham.Scenario.Scenarios.*'
module, the exact same codes the engine already uses to run them standalone
-- 2026-10-06, no guessing).

@frontend/homebrew/bloodborne-city-of-the-unseen/scenarios.json@ lists 49
entries total; the first 19 match already-implemented official standalone
scenarios (confirmed in [[project-arkham-rclone]]/[[project-arkham-localization]]'s
"RU standalone status: 19 done" tracking) and are wired below. The other ~30
("Barkham Horror - The Meddling of Meowlathotep", "The Witcher Horror", "Don't
Starve - Scenario", etc.) are other SCED-community fan scenarios whose
implementation status in THIS engine has not been checked -- not wired, not
guessed at.

'guardiansOfTheAbyss' is deliberately NOT included here: unlike every other
entry, it lives under 'Arkham.Campaign.Campaigns.GuardiansOfTheAbyss' (its
own mini-campaign with multiple internal steps), not a single
'Arkham.Scenario.Scenarios.*' module -- wiring it into a 'StandaloneScenarioStep'
chain the same way as the rest would need checking whether that's even the
right mechanism first. Skipped for this pilot slice rather than guessing.
-}
curseOfTheRougarouId :: ScenarioId
curseOfTheRougarouId = "81001"

carnevaleOfHorrorsId :: ScenarioId
carnevaleOfHorrorsId = "82001"

theLabyrinthsOfLunacyId :: ScenarioId
theLabyrinthsOfLunacyId = "70001"

murderAtTheExcelsiorHotelId :: ScenarioId
murderAtTheExcelsiorHotelId = "84001"

theBlobThatAteEverythingId :: ScenarioId
theBlobThatAteEverythingId = "85001"

warOfTheOuterGodsId :: ScenarioId
warOfTheOuterGodsId = "86001"

machinationsThroughTimeId :: ScenarioId
machinationsThroughTimeId = "87001"

fortuneAndFollyId :: ScenarioId
fortuneAndFollyId = "88001"

theMidwinterGalaId :: ScenarioId
theMidwinterGalaId = "71001"

filmFataleId :: ScenarioId
filmFataleId = "72001"

allOrNothingId :: ScenarioId
allOrNothingId = "90011"

badBloodId :: ScenarioId
badBloodId = "90020"

byTheBookId :: ScenarioId
byTheBookId = "90032"

laidToRestId :: ScenarioId
laidToRestId = "90054"

readOrDieId :: ScenarioId
readOrDieId = "90004"

redTideRisingId :: ScenarioId
redTideRisingId = "90041"

relicsOfThePastId :: ScenarioId
relicsOfThePastId = "90065"

enthrallingEncoreId :: ScenarioId
enthrallingEncoreId = "90094"
