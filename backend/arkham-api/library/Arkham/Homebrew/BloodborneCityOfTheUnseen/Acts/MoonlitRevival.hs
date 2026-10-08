module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.MoonlitRevival (moonlitRevival) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Constants
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers (removeBarrierBetweenConnected)
import Arkham.Matcher hiding (DuringTurn)

newtype MoonlitRevival = MoonlitRevival ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor MoonlitRevival

moonlitRevival :: ActCard MoonlitRevival
moonlitRevival = act (1, A) MoonlitRevival Cards.moonlitRevival Nothing

{- | "Objective - If each investigator is at the Hospital Courtyard, they may
spend the requisite amount of clues as a group to advance" (2 clues per
investigator, confirmed by visually reading the card). Real advance condition
wired via the same 'GroupClueCost' matcher the official ABotanicalSurvey act
uses for an identical "all investigators at location X, spend N/player clues"
pattern.

Ability 2 is the real "spend 1 clue to remove a barricade" half of the
card's own text, adapted from the official In Too Deep scenario's identical
mechanic (see 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers'). The "OR
test agility (4)" alternative is NOT YET IMPLEMENTED -- only the clue-spend
option is wired.
-}
instance HasAbilities MoonlitRevival where
  getAbilities (MoonlitRevival a) =
    extend
      a
      [ restricted a ActAdvancement (exists $ InvestigatorAt "Hospital Courtyard")
          $ Objective
          $ triggered (RoundEnds #when)
          $ GroupClueCost (PerPlayer 2) "Hospital Courtyard"
      , restrictedAbility a 2 (exists $ YourLocation <> LocationWithAdjacentBarrier)
          $ FastAbility (GroupClueCost (StaticWithPerPlayer 1 1) Anywhere)
      ]

instance RunMessage MoonlitRevival where
  runMessage msg a@(MoonlitRevival attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 2 -> do
      withLocationOf iid (removeBarrierBetweenConnected iid)
      pure a
    AdvanceAct (isSide B attrs -> True) _ _ -> do
      advanceActDeck attrs
      pure a
    _ -> MoonlitRevival <$> liftRunMessage msg attrs
