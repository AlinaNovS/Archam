module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.BeastAndTheCrow (beastAndTheCrow) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers (removeBarrierBetweenConnected)
import Arkham.Matcher hiding (DuringTurn)

newtype BeastAndTheCrow = BeastAndTheCrow ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor BeastAndTheCrow

{- | The "if all investigators have resigned: advance" objective is NOT YET
IMPLEMENTED. The "remove a barricade for 1 clue" half IS real, same
mechanism as 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.MoonlitRevival'.
-}
beastAndTheCrow :: ActCard BeastAndTheCrow
beastAndTheCrow = act (4, A) BeastAndTheCrow Cards.beastAndTheCrow Nothing

instance HasAbilities BeastAndTheCrow where
  getAbilities (BeastAndTheCrow a) =
    extend
      a
      [ restrictedAbility a 1 (exists $ YourLocation <> LocationWithAdjacentBarrier)
          $ FastAbility (GroupClueCost (StaticWithPerPlayer 1 1) Anywhere)
      ]

instance RunMessage BeastAndTheCrow where
  runMessage msg a@(BeastAndTheCrow attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      withLocationOf iid (removeBarrierBetweenConnected iid)
      pure a
    _ -> BeastAndTheCrow <$> liftRunMessage msg attrs
