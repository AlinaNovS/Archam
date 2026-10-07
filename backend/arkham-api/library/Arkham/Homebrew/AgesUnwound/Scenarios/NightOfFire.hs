module Arkham.Homebrew.AgesUnwound.Scenarios.NightOfFire (nightOfFire) where

import Arkham.Helpers.FlavorText
import Arkham.Homebrew.AgesUnwound.CardDefs.Acts qualified as Acts
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Agendas
import Arkham.Homebrew.AgesUnwound.CardDefs.Locations qualified as Locations
import Arkham.Homebrew.AgesUnwound.Import
import Arkham.Homebrew.AgesUnwound.Sets qualified as Set
import Arkham.Scenario.Import.Lifted

newtype NightOfFire = NightOfFire ScenarioAttrs
  deriving anyclass (IsScenario, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | No scenario-specific chaos token modifiers transcribed yet (pilot slice,
-- same as everything else flagged NOT YET IMPLEMENTED in this file) -- defer
-- entirely to the campaign's own chaosBagContents, same delegating pattern
-- used by several official scenarios (e.g. AThousandShapesOfHorror,
-- ALightInTheFog) for token faces they don't override.
instance HasChaosTokenValue NightOfFire where
  getChaosTokenValue iid tokenFace (NightOfFire attrs) = getChaosTokenValue iid tokenFace attrs

nightOfFire :: Difficulty -> NightOfFire
nightOfFire difficulty = scenario NightOfFire ":ages-unwound:001" "Night of Fire" difficulty []

{- | Setup pilot slice. Real setup (guide p4) also needs: the "Arkham
Streets" dynamic location deck (custom mechanic, not implemented — see
project notes), the remaining 4 Arkham Streets locations, the Agents of
Aforgomon / Nyctophobia / Thugs / Unravelling Ages encounter sets, and the
set-aside enemies (Myriad Assassin, Irregulars, Eternity's Sentinel, Time
Spirit) referenced by the agenda 1b flip. This slice only gathers the
Night of Fire set itself and gets one agenda/act/location on the table so
the scenario is enterable end-to-end.

2026-10-06: agenda deck now carries all 3 confirmed stages (doom thresholds
3/8/5 per the SCED TTS source's GMNotes) so the deck can actually advance
through to its final stage without a dispatch crash. Act deck is still only
1 stage -- the real act structure (how many acts, their names) still isn't
confirmed by any source found so far, intentionally not guessed at.
-}
instance RunMessage NightOfFire where
  runMessage msg s@(NightOfFire attrs) = runQueueT $ scenarioI18n "nightOfFire" $ case msg of
    Setup -> runScenarioSetup NightOfFire attrs do
      setup $ ul do
        li "gatherSets"
        li "placeRivertown"
        li "startAt"

      gather Set.NightOfFire

      setAgendaDeck [Agendas.hunted, Agendas.watched, Agendas.gazeOfThreeEyes]
      setActDeck [Acts.findSafety]

      rivertown <- place Locations.rivertown
      startAt rivertown
    _ -> NightOfFire <$> liftRunMessage msg attrs
