module Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins (huntBegins) where

import Arkham.Helpers.FlavorText
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Acts
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Agendas
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Locations
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Import
import Arkham.Scenario.Import.Lifted

newtype HuntBegins = HuntBegins ScenarioAttrs
  deriving anyclass (IsScenario, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasChaosTokenValue HuntBegins where
  getChaosTokenValue iid tokenFace (HuntBegins attrs) = getChaosTokenValue iid tokenFace attrs

huntBegins :: Difficulty -> HuntBegins
huntBegins difficulty = scenario HuntBegins ":bloodborne-city-of-the-unseen:001" "The Hunt Begins" difficulty []

{- | Pilot slice for the FIRST real (non-reused) scenario of this campaign --
see 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign' for why the earlier
18-standalone-scenario-chain approach was replaced. Real locations, real
3-stage agenda deck (doom 8/6/5, confirmed by reading the actual cards), and
the real 4-act chain in its correct play order are wired below. Deliberately
NOT in this slice (see per-file NOT YET IMPLEMENTED comments for specifics):
the "barricade" mechanic blocking some location connections (a real, already-
built mechanism exists in 'Arkham.Scenarios.InTooDeep.Helpers' and should be
adapted here next), the encounter deck's 8 unique treachery cards, the
Scourge Beast enemy, and the Insight chaos-bag token. This slice is enterable
end-to-end and its agenda deck can fully advance (including a real loss via
Night Terrors), which was the explicit goal for this pass.
-}
instance RunMessage HuntBegins where
  runMessage msg s@(HuntBegins attrs) = runQueueT $ scenarioI18n "huntBegins" $ case msg of
    Setup -> runScenarioSetup HuntBegins attrs do
      setup $ ul do
        li "placeLocations"
        li "startAt"

      setAgendaDeck [Agendas.huntBegins, Agendas.nightOfCurses, Agendas.mereBadDream]
      setActDeck [Acts.moonlitRevival, Acts.cityOfTheUnseen, Acts.violasWish, Acts.beastAndTheCrow]

      courtyard <- place Locations.hospitalCourtyard
      _ <- place Locations.examinationRoomA
      _ <- place Locations.examinationRoomB
      _ <- place Locations.sickroom
      startAt courtyard
    _ -> HuntBegins <$> liftRunMessage msg attrs
