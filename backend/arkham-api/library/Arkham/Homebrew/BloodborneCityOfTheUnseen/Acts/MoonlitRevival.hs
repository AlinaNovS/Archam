module Arkham.Homebrew.BloodborneCityOfTheUnseen.Acts.MoonlitRevival (moonlitRevival) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Constants
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Cards
import Arkham.Matcher hiding (DuringTurn)

newtype MoonlitRevival = MoonlitRevival ActAttrs
  deriving anyclass (IsAct, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

moonlitRevival :: ActCard MoonlitRevival
moonlitRevival = act (1, A) MoonlitRevival Cards.moonlitRevival Nothing

{- | "Objective - If each investigator is at the Hospital Courtyard, they may
spend the requisite amount of clues as a group to advance" (2 clues per
investigator, confirmed by visually reading the card). Real advance condition
wired via the same 'GroupClueCost' matcher the official ABotanicalSurvey act
uses for an identical "all investigators at location X, spend N/player clues"
pattern. The "spend 1 clue (or test agility 4) to remove a barricade"
ability is NOT YET IMPLEMENTED -- a real, reusable 'Barricades'/'placeBarrier'
mechanism already exists in this engine (see
'Arkham.Scenarios.InTooDeep.Helpers', used by The Innsmouth Conspiracy's
In Too Deep) and should be adapted here in a follow-up pass, rather than
built from scratch.
-}
instance HasAbilities MoonlitRevival where
  getAbilities = actAbilities1 \a ->
    restricted a ActAdvancement (exists $ InvestigatorAt "Hospital Courtyard")
      $ Objective
      $ triggered (RoundEnds #when)
      $ GroupClueCost (PerPlayer 2) "Hospital Courtyard"

instance RunMessage MoonlitRevival where
  runMessage msg a@(MoonlitRevival attrs) = runQueueT $ case msg of
    AdvanceAct (isSide B attrs -> True) _ _ -> do
      advanceActDeck attrs
      pure a
    _ -> MoonlitRevival <$> liftRunMessage msg attrs
