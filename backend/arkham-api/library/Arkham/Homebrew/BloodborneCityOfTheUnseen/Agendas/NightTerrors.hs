module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.NightTerrors (nightTerrors) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards
import Arkham.Matcher

newtype NightTerrors = NightTerrors AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

nightTerrors :: AgendaCard NightTerrors
nightTerrors = agenda (3, B) NightTerrors Cards.nightTerrors (Static 5)

-- | "Each remaining investigator in play is defeated." Real losing-condition
-- text, confirmed by visually reading the card -- implemented for real
-- (not a stub), mirroring the same 'selectEach UneliminatedInvestigator'
-- pattern used by the official OtherworldlyStorms agenda for an identical
-- effect.
instance RunMessage NightTerrors where
  runMessage msg a@(NightTerrors attrs) = runQueueT $ case msg of
    AdvanceAgenda (isSide B attrs -> True) -> do
      selectEach UneliminatedInvestigator (investigatorDefeated attrs)
      pure a
    _ -> NightTerrors <$> liftRunMessage msg attrs
