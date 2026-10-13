module Arkham.Treachery.Cards.ChildrenOfBlood.ChildrenOfBlood.GraspingHands (graspingHandsChildrenOfBlood) where

import Arkham.Treachery.CardDefs.ChildrenOfBlood.ChildrenOfBlood qualified as Cards
import Arkham.Treachery.Cards.GraspingHands qualified as Base
import Arkham.Treachery.Import.Lifted

newtype GraspingHands = GraspingHands Base.GraspingHands
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor, HasAbilities)

graspingHandsChildrenOfBlood :: TreacheryCard GraspingHands
graspingHandsChildrenOfBlood = treachery (GraspingHands . Base.GraspingHands) Cards.graspingHandsChildrenOfBlood

instance RunMessage GraspingHands where
  runMessage msg (GraspingHands inner) = GraspingHands <$> runMessage msg inner
