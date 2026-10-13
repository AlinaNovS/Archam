module Arkham.Treachery.CardDefs.ChildrenOfBlood.ChildrenOfBlood where

import Arkham.Treachery.CardDefs.Import

graspingHandsChildrenOfBlood :: CardDef
graspingHandsChildrenOfBlood =
  (treachery "13104" "Grasping Hands" ChildrenOfBlood 2)
    { cdCardTraits = singleton Hazard
    }
