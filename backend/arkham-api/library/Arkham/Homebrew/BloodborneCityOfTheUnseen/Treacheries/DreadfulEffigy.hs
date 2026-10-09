module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.DreadfulEffigy (dreadfulEffigy) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype DreadfulEffigy = DreadfulEffigy TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

dreadfulEffigy :: TreacheryCard DreadfulEffigy
dreadfulEffigy = treachery DreadfulEffigy Cards.dreadfulEffigy

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage DreadfulEffigy where
  runMessage msg t@(DreadfulEffigy attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> DreadfulEffigy <$> liftRunMessage msg attrs
