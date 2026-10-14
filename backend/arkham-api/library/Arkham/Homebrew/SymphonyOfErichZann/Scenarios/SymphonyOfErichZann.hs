module Arkham.Homebrew.SymphonyOfErichZann.Scenarios.SymphonyOfErichZann (symphonyOfErichZannScenario) where

import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Acts qualified as Acts
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Agendas
import Arkham.Homebrew.SymphonyOfErichZann.Import
import Arkham.Homebrew.SymphonyOfErichZann.Sets qualified as EncounterSets
import Arkham.Scenario.Import.Lifted

{- | Named 'ErichZannScenario' (not 'SymphonyOfErichZann') purely to avoid
colliding with the identically-titled Campaign type/function in
'Arkham.Homebrew.SymphonyOfErichZann.Campaign' -- this is a single-scenario
"campaign" whose campaign name and only scenario's name are the real same
printed title, unlike CircusExMortis/Bloodborne where each scenario has its
own distinct name. No naming significance beyond disambiguation.
-}
newtype ErichZannScenario = ErichZannScenario ScenarioAttrs
  deriving anyclass IsScenario
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor ErichZannScenario

{- | NOT YET PLAYABLE -- this wires the agenda/act decks for real (doom
6/5/4, 3-act chain, all confirmed by visually reading the cards, see each
CardDefs module's own citations) but Setup deliberately stops short of
placing any locations or calling 'startAt': none of the 11 locations
(5 fixed theater rooms + 6-card randomized backstage pool) have CardDefs
yet, see project_arkham_homebrew_campaigns.md's 2026-10-14 entry for what's
catalogued about them. 'HasChaosTokenValue' is also not implemented yet --
see Arkham.Homebrew.SymphonyOfErichZann.ChaosBag's own placeholder caveat.
Locations are the concrete next step before this can actually be set up and
played.
-}
instance HasChaosTokenValue ErichZannScenario where
  getChaosTokenValue iid tokenFace (ErichZannScenario attrs) = getChaosTokenValue iid tokenFace attrs

symphonyOfErichZannScenario :: Difficulty -> ErichZannScenario
symphonyOfErichZannScenario difficulty =
  scenario
    ErichZannScenario
    ":symphony-of-erich-zann:001"
    "Symphony of Erich Zann"
    difficulty
    []

instance RunMessage ErichZannScenario where
  runMessage msg s@(ErichZannScenario attrs) = runQueueT $ case msg of
    Setup -> runScenarioSetup ErichZannScenario attrs do
      gather EncounterSets.SymphonyOfErichZann
      setAgendaDeck [Agendas.overture, Agendas.crescendo, Agendas.greatestCreation]
      setActDeck [Acts.musicFromTheAuseilTheatre, Acts.thePossessedConductor, Acts.theUnimaginableOrchestra]
    _ -> ErichZannScenario <$> liftRunMessage msg attrs
