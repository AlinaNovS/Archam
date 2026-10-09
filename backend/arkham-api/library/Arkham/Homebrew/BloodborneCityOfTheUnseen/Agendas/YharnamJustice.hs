module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.YharnamJustice (yharnamJustice) where

import Arkham.Agenda.Import.Lifted
import Arkham.Card (Card (EncounterCard), isCardCode)
import Arkham.Helpers (Deck (..))
import Arkham.Helpers.Location (getLocationOf)
import Arkham.Helpers.Query (getLead, getPlayerCount)
import Arkham.Helpers.Scenario (getEncounterDeck, getEncounterDiscard)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies qualified as Enemies
import Arkham.Matcher
import Arkham.Scenario.Deck (ScenarioEncounterDeckKey (RegularEncounterDeck))

newtype YharnamJustice = YharnamJustice AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

yharnamJustice :: AgendaCard YharnamJustice
yharnamJustice = agenda (1, B) YharnamJustice Cards.yharnamJustice (Static 8)

{- | "Search the encounter deck and discard pile for 1 per investigator
Blood-Drunk Hunter enemies. Spawn one engaged with the lead investigator
instead of its usual spawn conditions, and any others at the location
furthest from all investigators. Then, shuffle the discard pile into the
encounter deck." -- confirmed by visually reading the real card. Searches
synchronously (direct deck/discard query + 'SpawnEnemyAt'/'SpawnEnemyAtEngagedWith',
same message pair 'Arkham.Agenda.Cards.ShadowsDeepen' uses for its own
search-and-spawn effect) rather than the player-facing find-card flow, since
this card's search is not optional/interactive.
-}
instance RunMessage YharnamJustice where
  runMessage msg a@(YharnamJustice attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      n <- getPlayerCount
      deck <- unDeck <$> getEncounterDeck
      discardPile <- getEncounterDiscard RegularEncounterDeck
      let found = take n $ filter (isCardCode Enemies.bloodDrunkHunter) (deck <> discardPile)
      case found of
        [] -> pure ()
        (first : rest) -> do
          lead <- getLead
          mLid <- getLocationOf lead
          for_ mLid \lid -> push $ SpawnEnemyAtEngagedWith (EncounterCard first) lid lead
          for_ rest \card -> do
            flid <- selectJust $ FarthestLocationFromAll Anywhere
            push $ SpawnEnemyAt (EncounterCard card) flid
      push ShuffleEncounterDiscardBackIn
      advanceAgendaDeck attrs
      pure a
    _ -> YharnamJustice <$> liftRunMessage msg attrs
