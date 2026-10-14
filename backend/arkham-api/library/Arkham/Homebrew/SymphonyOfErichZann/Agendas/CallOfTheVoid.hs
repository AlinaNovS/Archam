module Arkham.Homebrew.SymphonyOfErichZann.Agendas.CallOfTheVoid (callOfTheVoid) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype CallOfTheVoid = CallOfTheVoid AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Back of Agenda 2 ("Замысел 2b", "Зов пустоты"). Real advance text:
"Замешайте сброс контактов в колоду контактов. Каждый сыщик, в локации
которого есть враг-музыкант, проходит проверку willpower(3) или agility(3).
При провале каждый враг-музыкант в вашей локации немедленно вас атакует.
Выложите отложенного врага «Птенец соловья» на «Балкон»." (Shuffle the
encounter discard pile into the encounter deck. Each investigator at a
location with an enemy-musician tests willpower(3) or agility(3); on fail,
each enemy-musician at their location immediately attacks them. Place the
set-aside enemy "Птенец соловья"/Nightingale Fledgling at Балкон/Balcony.)
NOT YET IMPLEMENTED -- needs the 4 musician-enemy CardDefs, "Птенец соловья"
CardDef, and the Балкон location, none exist yet. Stub only.
-}
callOfTheVoid :: AgendaCard CallOfTheVoid
callOfTheVoid = agenda (2, B) CallOfTheVoid Cards.callOfTheVoid (Static 5)

instance RunMessage CallOfTheVoid where
  runMessage msg a@(CallOfTheVoid attrs) = runQueueT $ case msg of
    _ -> CallOfTheVoid <$> liftRunMessage msg attrs
