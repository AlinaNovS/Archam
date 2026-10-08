module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.CityOfTheUnseen (cityOfTheUnseen) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Constants
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers (removeBarrierBetweenConnected)
import Arkham.Matcher hiding (DuringTurn)

newtype CityOfTheUnseen = CityOfTheUnseen ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor CityOfTheUnseen

cityOfTheUnseen :: ActCard CityOfTheUnseen
cityOfTheUnseen = act (2, A) CityOfTheUnseen Cards.cityOfTheUnseen Nothing

{- | "Objective - Investigators at the City Center Plaza may spend the
requisite number of clues as a group to advance" (3 clues per investigator,
confirmed by visually reading the card). Real advance condition wired the
same way as 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.MoonlitRevival'.
City Center Plaza itself is NOT YET PLACED by this pilot's Setup (it's part
of the "Act 2 Locations" set-aside pile referenced on the Act 1 act card,
which this pilot doesn't reveal) -- so this ability is correctly wired but
currently unreachable until that location-reveal step is added in a
follow-up pass; not a crash risk, just inert until then.

Ability 2 (remove a barricade for 1 clue) IS reachable now, same as
MoonlitRevival's.
-}
instance HasAbilities CityOfTheUnseen where
  getAbilities (CityOfTheUnseen a) =
    extend
      a
      [ restricted a ActAdvancement (exists $ InvestigatorAt "City Center Plaza")
          $ Objective
          $ triggered (RoundEnds #when)
          $ GroupClueCost (PerPlayer 3) "City Center Plaza"
      , restrictedAbility a 2 (exists $ YourLocation <> LocationWithAdjacentBarrier)
          $ FastAbility (GroupClueCost (StaticWithPerPlayer 1 1) Anywhere)
      ]

instance RunMessage CityOfTheUnseen where
  runMessage msg a@(CityOfTheUnseen attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 2 -> do
      withLocationOf iid (removeBarrierBetweenConnected iid)
      pure a
    AdvanceAct (isSide B attrs -> True) _ _ -> do
      advanceActDeck attrs
      pure a
    _ -> CityOfTheUnseen <$> liftRunMessage msg attrs
