module Arkham.Homebrew.AgesUnwound.Acts.FindSafety (findSafety) where

import Arkham.Act.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CardDefs.Acts qualified as Cards

newtype FindSafety = FindSafety ActAttrs
  deriving anyclass (IsAct, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Placeholder — see 'Arkham.Homebrew.AgesUnwound.CardDefs.Acts.findSafety'.
findSafety :: ActCard FindSafety
findSafety = act (1, A) FindSafety Cards.findSafety Nothing

instance RunMessage FindSafety where
  runMessage msg (FindSafety attrs) = FindSafety <$> runMessage msg attrs
