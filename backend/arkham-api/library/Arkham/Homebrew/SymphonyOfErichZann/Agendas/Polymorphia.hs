module Arkham.Homebrew.SymphonyOfErichZann.Agendas.Polymorphia (polymorphia) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas qualified as Cards

newtype Polymorphia = Polymorphia AgendaAttrs
  deriving anyclass (IsAgenda, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Back of Agenda 1 ("Замысел 1b", "Полиморфия"). Real advance text:
"Выложите 1 отложенные «Уши пустоты» в «Вестибюль». Замешайте другие
отложенные «Уши пустоты», все отложенные экземпляры «Услышан непознанным» и
сброс контактов в колоду контактов." (Place 1 set-aside "Уши пустоты" at
Вестибюль/Vestibule; shuffle the other set-aside copies of "Уши пустоты",
all set-aside copies of "Услышан непознанным", and the encounter discard
pile back into the encounter deck.) NOT YET IMPLEMENTED -- needs "Уши
пустоты"/"Услышан непознанным" CardDefs and the Вестибюль location, neither
exist yet. Stub only.
-}
polymorphia :: AgendaCard Polymorphia
polymorphia = agenda (1, B) Polymorphia Cards.polymorphia (Static 6)

instance RunMessage Polymorphia where
  runMessage msg a@(Polymorphia attrs) = runQueueT $ case msg of
    _ -> Polymorphia <$> liftRunMessage msg attrs
