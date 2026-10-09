module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.SlakeTheThirst (slakeTheThirst) where

import Arkham.Treachery.Import.Lifted
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards

newtype SlakeTheThirst = SlakeTheThirst TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

slakeTheThirst :: TreacheryCard SlakeTheThirst
slakeTheThirst = treachery SlakeTheThirst Cards.slakeTheThirst

-- | Unique Revelation effect NOT YET IMPLEMENTED -- reveals and resolves
-- with no special effect, matching the established pilot-slice discipline.
instance RunMessage SlakeTheThirst where
  runMessage msg t@(SlakeTheThirst attrs) = runQueueT $ case msg of
    Revelation _iid (isSource attrs -> True) -> do
      pure t
    _ -> SlakeTheThirst <$> liftRunMessage msg attrs
