module Arkham.Homebrew.BloodborneCityOfTheUnseen.Agendas.HuntBegins (huntBegins) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Cards

newtype HuntBegins = HuntBegins AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Doom threshold 8, confirmed by visually reading the card
(bloodborne_city_of_the_unseen.json's Agenda Deck, "Agenda 1a"). Flavor text
and the shared "Beast enemies move as Blood-Drunk investigators and vice
versa" rule are NOT YET IMPLEMENTED (needs the Beast/Blood-Drunk enemy
traits, which don't have CardDefs yet) -- stub only, matches the project's
established minimal-stub agenda pattern.
-}
huntBegins :: AgendaCard HuntBegins
huntBegins = agenda (1, A) HuntBegins Cards.huntBegins (Static 8)

instance RunMessage HuntBegins where
  runMessage msg a@(HuntBegins attrs) = runQueueT $ case msg of
    _ -> HuntBegins <$> liftRunMessage msg attrs
