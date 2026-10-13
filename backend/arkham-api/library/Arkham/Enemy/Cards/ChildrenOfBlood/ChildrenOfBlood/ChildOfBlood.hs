module Arkham.Enemy.Cards.ChildrenOfBlood.ChildrenOfBlood.ChildOfBlood (childOfBloodChildrenOfBlood) where

import Arkham.Enemy.CardDefs.ChildrenOfBlood.ChildrenOfBlood qualified as Cards
import Arkham.Enemy.Import.Lifted
import Arkham.Matcher

newtype ChildOfBlood = ChildOfBlood EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor, RunMessage)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

childOfBloodChildrenOfBlood :: EnemyCard ChildOfBlood
childOfBloodChildrenOfBlood =
  enemy ChildOfBlood Cards.childOfBloodChildrenOfBlood
    & setPrey (InvestigatorWithMostSealedChaosToken #blood)
