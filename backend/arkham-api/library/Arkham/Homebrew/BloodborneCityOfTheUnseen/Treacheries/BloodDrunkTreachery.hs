module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.BloodDrunkTreachery (bloodDrunkTreachery) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype BloodDrunkTreachery = BloodDrunkTreachery TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

bloodDrunkTreachery :: TreacheryCard BloodDrunkTreachery
bloodDrunkTreachery = treachery BloodDrunkTreachery Cards.bloodDrunkTreachery

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage BloodDrunkTreachery where
  runMessage msg t@(BloodDrunkTreachery attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> BloodDrunkTreachery <$> liftRunMessage msg attrs
