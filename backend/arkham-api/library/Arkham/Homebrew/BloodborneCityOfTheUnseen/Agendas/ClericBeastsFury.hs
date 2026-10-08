module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.ClericBeastsFury (clericBeastsFury) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards

newtype ClericBeastsFury = ClericBeastsFury AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

clericBeastsFury :: AgendaCard ClericBeastsFury
clericBeastsFury = agenda (2, B) ClericBeastsFury Cards.clericBeastsFury (Static 6)

{- | "If it is Act 1, 2, or 3: Put the set aside Atop the Great Bridge
location into play and spawn the set aside Cleric Beast at that location. If
it is Act 4: Immediately resolve the Cleric Beast's hunter keyword..."

NOT YET IMPLEMENTED -- neither "Atop the Great Bridge" (a later-act location)
nor "Cleric Beast" (an enemy) have CardDefs yet. Only the agenda advancement
itself is wired up below, so the deck at least progresses correctly.
-}
instance RunMessage ClericBeastsFury where
  runMessage msg a@(ClericBeastsFury attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      advanceAgendaDeck attrs
      pure a
    _ -> ClericBeastsFury <$> liftRunMessage msg attrs
