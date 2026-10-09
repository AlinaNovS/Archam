module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.UncontrolledFire (uncontrolledFire) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype UncontrolledFire = UncontrolledFire TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

uncontrolledFire :: TreacheryCard UncontrolledFire
uncontrolledFire = treachery UncontrolledFire Cards.uncontrolledFire

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage UncontrolledFire where
  runMessage msg t@(UncontrolledFire attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> UncontrolledFire <$> liftRunMessage msg attrs
