module Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins (huntBegins) where

import Arkham.Helpers.FlavorText
import Arkham.Helpers.Location (getConnectedLocations, getLocationOf, withLocationOf)
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelectMaybe)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Acts qualified as Acts
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas qualified as Agendas
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Locations
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Import
import Arkham.Matcher
import Arkham.Message.Lifted.Choose
import Arkham.Scenario.Import.Lifted
import Arkham.ScenarioLogKey (ScenarioCountKey (Barriers))
import Arkham.SortedPair
import Arkham.Trait (Trait (HomebrewTrait))
import Data.Map.Strict qualified as Map
import Data.Set qualified as Set

newtype HuntBegins = HuntBegins ScenarioAttrs
  deriving anyclass IsScenario
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

{- | Barricade mechanic, adapted from the official In Too Deep scenario (see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Helpers' for the Meta type and
why no starting layout is set). No grid here (Bloodborne's locations use
plain icon/connection matching, not In Too Deep's Pos grid), so the
blocked-path BFS is done directly over 'getConnectedLocations' instead of
grid lookups.
-}
instance HasModifiersFor HuntBegins where
  getModifiersFor (HuntBegins a) = do
    investigators <- modifySelectMaybe a Anyone \iid -> do
      lid <- MaybeT $ getLocationOf iid
      Meta meta <- hoistMaybe $ maybeResult @Meta a.meta
      let
        unblocked x y = Map.findWithDefault 0 (sortedPair y x) meta == 0
        bfs visited [] = pure $ toList visited
        bfs visited (current : queue)
          | current `Set.member` visited = bfs visited queue
          | otherwise = do
              next <- filterBy [unblocked current, (`Set.notMember` visited)] <$> getConnectedLocations current
              bfs (Set.insert current visited) (queue <> next)
      reachable <- lift $ bfs Set.empty [lid]
      blocked <- lift $ select $ not_ $ beOneOf @_ @LocationMatcher reachable
      pure $ CannotEnter <$> blocked
    locations <- modifySelectMaybe a Anywhere \lid -> do
      Meta meta <- hoistMaybe $ maybeResult @Meta a.meta
      let
        barricaded (pair, n) = case unSortedPair pair of
          (l1, l2) | l1 == lid -> guard (n > 0) $> l2
          (l1, l2) | l2 == lid -> guard (n > 0) $> l1
          _ -> Nothing
      let barriers = mapMaybe barricaded $ Map.toList meta
      pure [Barricades barriers | notNull barriers]
    pure $ investigators <> locations

{- | Values confirmed by visually reading the "Scenario Reference" card
(code 001, a real, distinct card from the Agenda 1a of the same name --
found live 2026-10-08 after the English/Russian bags' GUIDs for same-named
cards didn't match up, causing an earlier wrong image swap, since fixed).

Skull/Cultist/Tablet implemented for real -- Tablet's failure now places a
real barricade (see 'FailedSkillTest' below). Elder Thing's number itself is
wired, but its side effect ("discard the top N cards, X = their printed
cost") is NOT YET IMPLEMENTED -- that needs its own token-resolution hook,
not just a modifier value; using a conservative fixed placeholder (-2/-3,
matching Cultist) rather than guessing at the real discard-sum.
-}
instance HasChaosTokenValue HuntBegins where
  getChaosTokenValue iid tokenFace (HuntBegins attrs) = case tokenFace of
    Skull -> do
      n <- selectCount $ EnemyWithTrait (HomebrewTrait "Beast")
      pure $ case attrs.difficulty of
        Easy -> ChaosTokenValue Skull (NegativeModifier (min 3 n))
        Standard -> ChaosTokenValue Skull (NegativeModifier (min 3 n))
        _ -> ChaosTokenValue Skull (NegativeModifier n)
    Cultist -> pure $ toChaosTokenValue attrs Cultist 2 4
    Tablet -> pure $ toChaosTokenValue attrs Tablet 2 3
    ElderThing -> pure $ toChaosTokenValue attrs ElderThing 2 3
    otherFace -> getChaosTokenValue iid otherFace attrs

{- | Grid layout was previously an empty list, which left every location's
on-screen position unset -- the frontend collapsed all 5 cards onto the
exact same pixel coordinates (confirmed via a live game's DB dump: every
location had identical 'position: null', and the rendered card
'getBoundingClientRect()'s were pixel-identical). This cross-shaped grid
matches the real connection graph: Hospital Courtyard is the hub (connects
to all 4 others, 2 by symbol match + City Center Plaza by explicit card
text); Sickroom also connects to both Examination Rooms by symbol match.
-}
huntBegins :: Difficulty -> HuntBegins
huntBegins difficulty =
  scenario
    HuntBegins
    ":bloodborne-city-of-the-unseen:001"
    "The Hunt Begins"
    difficulty
    [ "        .                examinationRoomA   .                "
    , "sickroom        hospitalCourtyard   cityCenterPlaza"
    , "        .                examinationRoomB   .                "
    ]

{- | Pilot slice for the FIRST real (non-reused) scenario of this campaign --
see 'Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign' for why the earlier
18-standalone-scenario-chain approach was replaced. Real locations, real
3-stage agenda deck (doom 8/6/5), the real 4-act chain in correct play
order, real chaos token values, and the real barricade mechanic (place via
failed Tablet tokens, remove via each act's own 1-clue ability) are all
wired below. Deliberately NOT in this slice: the "OR test agility (4)"
alternative to the clue-spend barrier removal (only the clue-spend option is
wired; the skill-test option needs its own ability variant, not added yet),
the encounter deck's 8 unique treachery cards, the Scourge Beast enemy, and
the Insight chaos-bag token.
-}
instance RunMessage HuntBegins where
  runMessage msg s@(HuntBegins attrs) = runQueueT $ scenarioI18n "huntBegins" $ case msg of
    Setup -> runScenarioSetup HuntBegins attrs do
      setup $ ul do
        li "placeLocations"
        li "startAt"

      setAgendaDeck [Agendas.huntBegins, Agendas.nightOfCurses, Agendas.mereBadDream]
      setActDeck [Acts.moonlitRevival, Acts.cityOfTheUnseen, Acts.violasWish, Acts.beastAndTheCrow]

      courtyard <- place Locations.hospitalCourtyard
      push $ SetLocationLabel courtyard "hospitalCourtyard"
      examA <- place Locations.examinationRoomA
      push $ SetLocationLabel examA "examinationRoomA"
      examB <- place Locations.examinationRoomB
      push $ SetLocationLabel examB "examinationRoomB"
      sick <- place Locations.sickroom
      push $ SetLocationLabel sick "sickroom"
      plaza <- place Locations.cityCenterPlaza
      push $ SetLocationLabel plaza "cityCenterPlaza"
      startAt courtyard
    ScenarioCountIncrementBy (Barriers l1 l2) n -> do
      let meta' = incrementBarriers n l1 l2 $ toResultDefault (Meta mempty) attrs.meta
      pure $ HuntBegins $ attrs & metaL .~ toJSON meta'
    ScenarioCountDecrementBy (Barriers l1 l2) n -> do
      let meta' = decrementBarriers n l1 l2 $ toResultDefault (Meta mempty) attrs.meta
      pure $ HuntBegins $ attrs & metaL .~ toJSON meta'
    FailedSkillTest iid _ _ (ChaosTokenTarget token) _ _ | token.face == Tablet -> do
      withLocationOf iid \lid -> do
        connected <- getConnectedLocations lid
        chooseTargetM iid connected \l -> push $ ScenarioCountIncrementBy (Barriers lid l) 1
      pure s
    _ -> HuntBegins <$> liftRunMessage msg attrs
