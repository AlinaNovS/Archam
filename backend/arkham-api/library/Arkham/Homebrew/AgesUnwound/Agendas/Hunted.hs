module Arkham.Homebrew.AgesUnwound.Agendas.Hunted (hunted) where

import Arkham.Agenda.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Agendas qualified as Cards

newtype Hunted = Hunted AgendaAttrs
  deriving anyclass (IsAgenda, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

hunted :: AgendaCard Hunted
hunted = agenda (1, A) Hunted Cards.hunted (Static 3)

{- | "Doom on cards other than this agenda subtracts from the total doom in
play instead of adding to it."

NOT YET IMPLEMENTED. This rewrites how doom-in-play is totaled for the
purpose of the agenda's own advancement threshold, which likely needs a
custom 'HasModifiersFor'/doom-counting hook rather than anything in the
per-card ability DSL. Needs a look at how 'Arkham.Helpers.Agenda' /
'Arkham.Helpers.Doom' compute "total doom in play" before this can be wired
up correctly — flagging rather than guessing at an API that might not exist.

"Forced - At the end of your turn, if you did not move at least once during
your turn: Test [agility] (2). If you fail, take 1 damage."

NOT YET IMPLEMENTED. Needs an "investigator moved this turn" tracker — no
existing matcher for "did not move this turn" was found in the codebase in a
quick search; this likely needs either a turn-scoped meta flag (set by a
'HasModifiersFor'-style hook on movement, cleared each 'EndTurn') or a
different window this project doesn't use elsewhere yet. Left as a stub so
this at least compiles and the card exists in the deck, rather than blocking
on incorrect guesswork.
-}
instance HasModifiersFor Hunted where
  getModifiersFor _ = pure mempty

instance RunMessage Hunted where
  runMessage msg a@(Hunted attrs) = runQueueT $ case msg of
    _ -> Hunted <$> liftRunMessage msg attrs
