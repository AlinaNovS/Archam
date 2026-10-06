module Arkham.Homebrew.AgesUnwound.Agendas.Sentinel (sentinel) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype Sentinel = Sentinel AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Same doom threshold as 'Watched' (2a), matching the 'SomethingUnnatural'
-- (1b) convention of reusing the A-side's threshold. Ability text not yet
-- transcribed. Advances the agenda deck on flip, same minimal pattern as
-- 'SomethingUnnatural', so stage 3 is reachable.
sentinel :: AgendaCard Sentinel
sentinel = agenda (2, B) Sentinel Cards.sentinel (Static 8)

instance RunMessage Sentinel where
  runMessage msg a@(Sentinel attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      advanceAgendaDeck attrs
      pure a
    _ -> Sentinel <$> liftRunMessage msg attrs
