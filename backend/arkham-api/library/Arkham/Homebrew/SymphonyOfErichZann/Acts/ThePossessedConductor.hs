module Arkham.Homebrew.SymphonyOfErichZann.Acts.ThePossessedConductor (thePossessedConductor) where

import Arkham.Act.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Acts qualified as Cards

newtype ThePossessedConductor = ThePossessedConductor ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor ThePossessedConductor
instance HasAbilities ThePossessedConductor

{- | "Сцена 2a". Real text: "Наконец вы находите Огюста Годена в
одиночестве, дирижирующего несуществующим оркестром в концертном зале. Он
весь в поту и извивается, словно мартышка, ударяя воздух с неистовым и
бессознательным отчаянием. Вы должны привести его в чувство! Цель — Если
«Огюст Годен» побеждён, продвиньтесь." NOT YET IMPLEMENTED -- the advance
condition needs
Arkham.Homebrew.SymphonyOfErichZann.Enemies.AugusteGoden to exist and be
placed at Setup first (not done yet, see that module's own stub caveat).
There's also a real "Сцена 2b" card ("Музыка Эриха Цанна") with further
setup/transition text on defeating Goden -- see the caveat in CardDefs.Acts,
not modelled here yet. Stub only.
-}
thePossessedConductor :: ActCard ThePossessedConductor
thePossessedConductor = act (2, A) ThePossessedConductor Cards.thePossessedConductor Nothing

instance RunMessage ThePossessedConductor where
  runMessage msg a@(ThePossessedConductor attrs) = runQueueT $ case msg of
    _ -> ThePossessedConductor <$> liftRunMessage msg attrs
