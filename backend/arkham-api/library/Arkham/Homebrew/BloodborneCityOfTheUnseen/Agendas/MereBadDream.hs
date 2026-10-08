module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.MereBadDream (mereBadDream) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards

newtype MereBadDream = MereBadDream AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Doom threshold 5, confirmed by visually reading the card ("Agenda 3a") --
-- this is the FINAL agenda stage in this scenario, with the lowest doom
-- threshold of the three (confirmed correct, not a transcription error).
mereBadDream :: AgendaCard MereBadDream
mereBadDream = agenda (3, A) MereBadDream Cards.mereBadDream (Static 5)

instance RunMessage MereBadDream where
  runMessage msg a@(MereBadDream attrs) = runQueueT $ case msg of
    _ -> MereBadDream <$> liftRunMessage msg attrs
