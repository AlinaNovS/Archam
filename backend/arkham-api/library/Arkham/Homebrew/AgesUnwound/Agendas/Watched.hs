module Arkham.Homebrew.AgesUnwound.Agendas.Watched (watched) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype Watched = Watched AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Doom threshold 8, confirmed via the SCED TTS card data (GMNotes
-- doomThreshold) for 2026-10-06's Ages Unwound source pull. Ability text not
-- yet transcribed -- stub only, matches 'Hunted' (1a)'s minimal pattern so
-- the agenda deck can at least advance through this stage without crashing.
watched :: AgendaCard Watched
watched = agenda (2, A) Watched Cards.watched (Static 8)

instance RunMessage Watched where
  runMessage msg a@(Watched attrs) = runQueueT $ case msg of
    _ -> Watched <$> liftRunMessage msg attrs
