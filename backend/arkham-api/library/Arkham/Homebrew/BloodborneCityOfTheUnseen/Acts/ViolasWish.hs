module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.ViolasWish (violasWish) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers (removeBarrierBetweenConnected)
import Arkham.Matcher hiding (DuringTurn)

newtype ViolasWish = ViolasWish ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor ViolasWish

{- | The "Viola Gascoigne in victory display: advance" objective is NOT YET
IMPLEMENTED -- Viola Gascoigne doesn't have a CardDef yet. The "remove a
barricade for 1 clue" half IS real, same mechanism as
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.MoonlitRevival'.
-}
violasWish :: ActCard ViolasWish
violasWish = act (3, A) ViolasWish Cards.violasWish Nothing

instance HasAbilities ViolasWish where
  getAbilities (ViolasWish a) =
    extend
      a
      [ restrictedAbility a 1 (exists $ YourLocation <> LocationWithAdjacentBarrier)
          $ FastAbility (GroupClueCost (StaticWithPerPlayer 1 1) Anywhere)
      ]

instance RunMessage ViolasWish where
  runMessage msg a@(ViolasWish attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      withLocationOf iid (removeBarrierBetweenConnected iid)
      pure a
    _ -> ViolasWish <$> liftRunMessage msg attrs
