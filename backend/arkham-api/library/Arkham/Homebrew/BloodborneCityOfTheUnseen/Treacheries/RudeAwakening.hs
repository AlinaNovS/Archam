module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.RudeAwakening (rudeAwakening) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype RudeAwakening = RudeAwakening TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

rudeAwakening :: TreacheryCard RudeAwakening
rudeAwakening = treachery RudeAwakening Cards.rudeAwakening

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage RudeAwakening where
  runMessage msg t@(RudeAwakening attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> RudeAwakening <$> liftRunMessage msg attrs
