module Arkham.Homebrew.SymphonyOfErichZann.Agendas.InevitableEnd (inevitableEnd) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype InevitableEnd = InevitableEnd AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Back of Agenda 3 ("Замысел 3b", "Неизбежный конец") -- the loss/escape
resolution path. Real text: "Раскрытие — Разыграйте текст отложенной карты
сюжета «За кулисами». Затем замените текущую сцену и замысел на
«Неизбежный конец». Эта карта становится и текущей сценой, и текущим
замыслом. Цель — Спасайтесь! Если каждый не побежденный сыщик совершил
побег, (→R1)." (When revealed -- resolve the set-aside story card "За
кулисами"/Backstage, then this card becomes BOTH the current act and the
current agenda. Goal -- Escape! If every non-defeated investigator has fled,
resolve R1.) NOT YET IMPLEMENTED -- needs the "За кулисами" story CardDef,
a resolution-branch structure (no R1/etc. exists yet for this pilot scenario,
same "single ending only, not yet branched" caveat as Bloodborne's
clericBeast), and the dual act+agenda role this card plays has no existing
precedent anywhere else in this engine's homebrew content -- needs design
attention next session, not a routine stub. Stub only.
-}
inevitableEnd :: AgendaCard InevitableEnd
inevitableEnd = agenda (3, B) InevitableEnd Cards.inevitableEnd (Static 4)

instance RunMessage InevitableEnd where
  runMessage msg a@(InevitableEnd attrs) = runQueueT $ case msg of
    _ -> InevitableEnd <$> liftRunMessage msg attrs
