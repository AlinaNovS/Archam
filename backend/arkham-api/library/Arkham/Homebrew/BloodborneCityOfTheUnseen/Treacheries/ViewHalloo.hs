module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.ViewHalloo (viewHalloo) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype ViewHalloo = ViewHalloo TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

viewHalloo :: TreacheryCard ViewHalloo
viewHalloo = treachery ViewHalloo Cards.viewHalloo

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage ViewHalloo where
  runMessage msg t@(ViewHalloo attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> ViewHalloo <$> liftRunMessage msg attrs
