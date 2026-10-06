module Arkham.Homebrew.AgesUnwound.Agendas.MorningBreaks (morningBreaks) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype MorningBreaks = MorningBreaks AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Same doom threshold as 'GazeOfThreeEyes' (3a). Final agenda card of the
-- pilot slice -- advancing past this falls through to the engine's default
-- "agenda deck exhausted" handling (same as every other scenario; no
-- Ages-Unwound-specific resolution text has been transcribed yet).
morningBreaks :: AgendaCard MorningBreaks
morningBreaks = agenda (3, B) MorningBreaks Cards.morningBreaks (Static 5)

instance RunMessage MorningBreaks where
  runMessage msg a@(MorningBreaks attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      advanceAgendaDeck attrs
      pure a
    _ -> MorningBreaks <$> liftRunMessage msg attrs
