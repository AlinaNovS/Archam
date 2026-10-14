module Arkham.Homebrew.SymphonyOfErichZann.Agendas.Overture (overture) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype Overture = Overture AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Doom threshold 6, confirmed by visually reading the real card ("Замысел
1a", "Увертюра"). Real text: "Тихий шелест призрачных нот доносится от входа
в театр «Осейль», резиденцию одного из самых обожаемых оркестров Франции.
Собрав волю в кулак, вы входите в здание в поисках ответов на вопросы о
пропавшем виолисте Эрихе Цанне. Не более 1 напасти-музыки рядом с колодой
замыслов." The "cap music-treacheries in play next to the agenda deck at 1,
discard oldest on overflow" enforcement (this scenario's core resource-
pressure mechanic, scaling to 2 then 3 across the 3 agenda stages) is NOT
YET IMPLEMENTED -- needs a Meta-backed counter + discard-oldest hook, same
shape as Bloodborne's barricade Meta (see
Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers) but tracking a FIFO list
of in-play music-treachery CardIds per agenda stage rather than a connection
map. Stub only, matches this project's established minimal-stub agenda
pattern (see Agendas.HuntBegins in the Bloodborne module).
-}
overture :: AgendaCard Overture
overture = agenda (1, A) Overture Cards.overture (Static 6)

instance RunMessage Overture where
  runMessage msg a@(Overture attrs) = runQueueT $ case msg of
    _ -> Overture <$> liftRunMessage msg attrs
