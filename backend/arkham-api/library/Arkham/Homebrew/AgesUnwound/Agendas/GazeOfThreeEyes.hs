module Arkham.Homebrew.AgesUnwound.Agendas.GazeOfThreeEyes (gazeOfThreeEyes) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype GazeOfThreeEyes = GazeOfThreeEyes AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Doom threshold 5, confirmed via the SCED TTS card data (GMNotes
-- doomThreshold) for 2026-10-06's Ages Unwound source pull. Final agenda
-- stage of the pilot slice -- ability/resolution text not yet transcribed,
-- stub only.
gazeOfThreeEyes :: AgendaCard GazeOfThreeEyes
gazeOfThreeEyes = agenda (3, A) GazeOfThreeEyes Cards.gazeOfThreeEyes (Static 5)

instance RunMessage GazeOfThreeEyes where
  runMessage msg a@(GazeOfThreeEyes attrs) = runQueueT $ case msg of
    _ -> GazeOfThreeEyes <$> liftRunMessage msg attrs
