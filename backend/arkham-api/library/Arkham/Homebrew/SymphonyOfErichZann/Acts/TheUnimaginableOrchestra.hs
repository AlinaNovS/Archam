module Arkham.Homebrew.SymphonyOfErichZann.Acts.TheUnimaginableOrchestra (theUnimaginableOrchestra) where

import Arkham.Act.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Acts qualified as Cards

newtype TheUnimaginableOrchestra = TheUnimaginableOrchestra ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor TheUnimaginableOrchestra
instance HasAbilities TheUnimaginableOrchestra

{- | "Сцена 3a", final act. Real text: "Похоже, оркестр одержим музыкой
Эриха Цанна. Вы не знаете, что произойдёт, когда симфония закончится, но
уверены, что должны спасти как можно больше музыкантов от этого
одурманивающего очарования. Обязательно — После того, как враг-музыкант
побеждён, переверните его и разыграйте текст на обороте. Цель — Если в игре
не осталось врагов-музыкантов, продвиньтесь." (Forced -- whenever an
enemy-musician is defeated, flip it and resolve its back-side text [i.e.
defeating a musician "frees" them rather than removing them outright]. Goal
-- advance once no enemy-musicians remain in play.) NOT YET IMPLEMENTED --
needs all 4 musician-enemy CardDefs (with their flip/"freed" back sides) to
exist first; none are built yet. Stub only.
-}
theUnimaginableOrchestra :: ActCard TheUnimaginableOrchestra
theUnimaginableOrchestra = act (3, A) TheUnimaginableOrchestra Cards.theUnimaginableOrchestra Nothing

instance RunMessage TheUnimaginableOrchestra where
  runMessage msg a@(TheUnimaginableOrchestra attrs) = runQueueT $ case msg of
    _ -> TheUnimaginableOrchestra <$> liftRunMessage msg attrs
