module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.AshenAffliction (ashenAffliction) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype AshenAffliction = AshenAffliction TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

ashenAffliction :: TreacheryCard AshenAffliction
ashenAffliction = treachery AshenAffliction Cards.ashenAffliction

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage AshenAffliction where
  runMessage msg t@(AshenAffliction attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> AshenAffliction <$> liftRunMessage msg attrs
