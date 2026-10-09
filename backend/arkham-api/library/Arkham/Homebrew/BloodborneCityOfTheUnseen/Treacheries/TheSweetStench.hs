module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.TheSweetStench (theSweetStench) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype TheSweetStench = TheSweetStench TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

theSweetStench :: TreacheryCard TheSweetStench
theSweetStench = treachery TheSweetStench Cards.theSweetStench

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage TheSweetStench where
  runMessage msg t@(TheSweetStench attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> TheSweetStench <$> liftRunMessage msg attrs
