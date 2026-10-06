module Arkham.Homebrew.AgesUnwound.Agendas.SomethingUnnatural (somethingUnnatural) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype SomethingUnnatural = SomethingUnnatural AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

somethingUnnatural :: AgendaCard SomethingUnnatural
somethingUnnatural = agenda (1, B) SomethingUnnatural Cards.somethingUnnatural (Static 3)

{- | "For each investigator, spawn a set-aside copy of Time Spirit unless that
investigator spent 2 clues as a group. Shuffle Myriad Assassin, Irregulars and
the Agents of Aforgomon encounter set into the encounter deck, along with the
encounter discard pile. Advance to act 2a and agenda 2a."

The "spawn Time Spirit / spend 2 clues" choice and the encounter-set shuffle
are NOT YET IMPLEMENTED: they reference three enemy cards (Time Spirit,
Myriad Assassin, Irregulars) that don't have 'CardDef's yet — those need to be
transcribed and written first (see 'Arkham.Homebrew.AgesUnwound.CardDefs.Enemies',
not yet created). Only the agenda advancement itself is wired up below, so
the deck at least progresses correctly.
-}
instance RunMessage SomethingUnnatural where
  runMessage msg a@(SomethingUnnatural attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      advanceAgendaDeck attrs
      pure a
    _ -> SomethingUnnatural <$> liftRunMessage msg attrs
