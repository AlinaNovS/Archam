module Arkham.Homebrew.SymphonyOfErichZann.Agendas.GreatestCreation (greatestCreation) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype GreatestCreation = GreatestCreation AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Doom threshold 4 ("Замысел 3a", "Величайшее творение"), the final
agenda stage. Real text: "Пока вы стойко сопротивлялись яростной композиции,
в зале поднялся воющий ночной ветер. Занавес неистово дрожит и колышется в
такт ритму. Что бы ни приближалось, вы не знаете, что это ещё не конец. Не
более 3 напастей-музыки рядом с колодой замыслов. (Имейте в виду: сценарий
не закончится, если этот замысел продвинется, но конец произведения уже
близок.)" Cap mechanic widens to 3 -- NOT YET IMPLEMENTED, same as stages
1-2. Stub only.
-}
greatestCreation :: AgendaCard GreatestCreation
greatestCreation = agenda (3, A) GreatestCreation Cards.greatestCreation (Static 4)

instance RunMessage GreatestCreation where
  runMessage msg a@(GreatestCreation attrs) = runQueueT $ case msg of
    _ -> GreatestCreation <$> liftRunMessage msg attrs
