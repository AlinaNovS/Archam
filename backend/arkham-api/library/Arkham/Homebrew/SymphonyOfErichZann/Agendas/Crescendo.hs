module Arkham.Homebrew.SymphonyOfErichZann.Agendas.Crescendo (crescendo) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype Crescendo = Crescendo AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Doom threshold 5 ("Замысел 2a", "Крещендо"). Real text: "В
беспорядочном грохоте звуков вы слышите изысканно низкую и бесконечно
далёкую ноту. И хотя этот звук нельзя назвать ужасным, вы не можете точно
определить, откуда он доносится. Не более 2 напастей-музыки рядом с колодой
замыслов." Cap mechanic (see Overture) widens to 2 at this stage -- NOT YET
IMPLEMENTED, same as stage 1. Stub only.
-}
crescendo :: AgendaCard Crescendo
crescendo = agenda (2, A) Crescendo Cards.crescendo (Static 5)

instance RunMessage Crescendo where
  runMessage msg a@(Crescendo attrs) = runQueueT $ case msg of
    _ -> Crescendo <$> liftRunMessage msg attrs
