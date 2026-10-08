module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.ViolasWish (violasWish) where

import Arkham.Act.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards

newtype ViolasWish = ViolasWish ActAttrs
  deriving anyclass (IsAct, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Placeholder -- see 'Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts.violasWish'.
The "barricade" removal ability and the "Viola Gascoigne in victory display"
advance condition both need real content (an enemy CardDef for Viola
Gascoigne, and the already-identified reusable 'Barricades'/'placeBarrier'
mechanism from 'Arkham.Scenarios.InTooDeep.Helpers') before this can advance
for real.
-}
violasWish :: ActCard ViolasWish
violasWish = act (3, A) ViolasWish Cards.violasWish Nothing

instance RunMessage ViolasWish where
  runMessage msg (ViolasWish attrs) = ViolasWish <$> runMessage msg attrs
