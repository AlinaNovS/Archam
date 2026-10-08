module Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers where

import Arkham.Classes.HasQueue (push)
import Arkham.Helpers.Modifiers (ModifierType (Barricades), getModifiers)
import Arkham.I18n
import Arkham.Id
import Arkham.Message (Message (ScenarioCountDecrementBy))
import Arkham.Message.Lifted (ReverseQueue)
import Arkham.Message.Lifted.Choose
import Arkham.Prelude
import Arkham.ScenarioLogKey (ScenarioCountKey (Barriers))
import Arkham.SortedPair
import Data.Map.Strict qualified as Map

campaignI18n :: (HasI18n => a) -> a
campaignI18n a = withI18n $ scope "bloodborneCityOfTheUnseen" a

scenarioI18n :: Scope -> (HasI18n => a) -> a
scenarioI18n scenarioScope a = campaignI18n $ scope scenarioScope a

{- | "Barricade" mechanic, adapted from the official In Too Deep scenario
(Arkham.Scenarios.InTooDeep.Helpers), which has the exact same "blocks
movement between two connected locations until spent-clue/skill-test
removes it" mechanic -- confirmed via the real card text ("Investigators
may spend 1 clue... or Test agility (4) to remove a barricade") and the
Scenario Reference card's Tablet token effect ("place a barricade token
between your location and a connecting location"). No starting barrier
layout is set at Setup -- unlike In Too Deep, nothing in the Bloodborne
source material found so far specifies one; barriers are purely
chaos-token/agenda-triggered here, starting at zero.
-}
newtype Meta = Meta {barriers :: Map (SortedPair LocationId) Int}
  deriving stock (Show, Eq, Generic)
  deriving anyclass (ToJSON, FromJSON)

incrementBarriers :: Int -> LocationId -> LocationId -> Meta -> Meta
incrementBarriers n a b (Meta barriers) =
  Meta $ Map.insertWith (+) (sortedPair a b) n barriers

decrementBarriers :: Int -> LocationId -> LocationId -> Meta -> Meta
decrementBarriers n a b (Meta barriers) =
  Meta $ Map.insertWith ((max 0 .) . subtract) (sortedPair a b) n barriers

-- | Lets the given investigator pick one of their location's barricaded
-- connections to clear -- the "remove a barricade" half of every act's own
-- 1-clue ability. Mirrors In Too Deep's own helper of the same name.
removeBarrierBetweenConnected :: ReverseQueue m => InvestigatorId -> LocationId -> m ()
removeBarrierBetweenConnected iid lid = do
  mods <- getModifiers lid
  let barriers = concat [ls | Barricades ls <- mods]
  chooseTargetM iid barriers \lid' -> push $ ScenarioCountDecrementBy (Barriers lid lid') 1
