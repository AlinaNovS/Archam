module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.BeastAndTheCrow (beastAndTheCrow) where

import Arkham.Act.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards

newtype BeastAndTheCrow = BeastAndTheCrow ActAttrs
  deriving anyclass (IsAct, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Placeholder -- see 'Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts.beastAndTheCrow'.
Same NOT YET IMPLEMENTED caveat as 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.ViolasWish'
-- barricade removal + "if all investigators have resigned: advance".
-}
beastAndTheCrow :: ActCard BeastAndTheCrow
beastAndTheCrow = act (4, A) BeastAndTheCrow Cards.beastAndTheCrow Nothing

instance RunMessage BeastAndTheCrow where
  runMessage msg (BeastAndTheCrow attrs) = BeastAndTheCrow <$> runMessage msg attrs
