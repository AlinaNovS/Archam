module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.NightOfCurses (nightOfCurses) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards

newtype NightOfCurses = NightOfCurses AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Doom threshold 6, confirmed by visually reading the card ("Agenda 2a").
nightOfCurses :: AgendaCard NightOfCurses
nightOfCurses = agenda (2, A) NightOfCurses Cards.nightOfCurses (Static 6)

instance RunMessage NightOfCurses where
  runMessage msg a@(NightOfCurses attrs) = runQueueT $ case msg of
    _ -> NightOfCurses <$> liftRunMessage msg attrs
