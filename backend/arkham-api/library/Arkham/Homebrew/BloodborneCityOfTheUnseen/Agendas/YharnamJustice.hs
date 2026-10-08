module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.YharnamJustice (yharnamJustice) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards

newtype YharnamJustice = YharnamJustice AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

yharnamJustice :: AgendaCard YharnamJustice
yharnamJustice = agenda (1, B) YharnamJustice Cards.yharnamJustice (Static 8)

{- | "Search the encounter deck and discard pile for 1 Blood-Drunk enemy.
Spawn one engaged with the lead investigator instead of its usual spawn
conditions, and any others at the location furthest from all investigators.
Then, shuffle the discard pile into the encounter deck."

NOT YET IMPLEMENTED -- no Blood-Drunk enemy has a CardDef yet (deferred, same
as every enemy in this pilot slice -- see Scenarios/HuntBegins.hs). Only the
agenda advancement itself is wired up below, so the deck at least progresses.
-}
instance RunMessage YharnamJustice where
  runMessage msg a@(YharnamJustice attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      advanceAgendaDeck attrs
      pure a
    _ -> YharnamJustice <$> liftRunMessage msg attrs
