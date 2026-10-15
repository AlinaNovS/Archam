module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.DreadfulEffigy (dreadfulEffigy) where

import Arkham.Ability
import Arkham.GameValue
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Helpers.Modifiers (ModifierType (..), modified_)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Placement
import Arkham.Treachery.Import.Lifted

newtype DreadfulEffigy = DreadfulEffigy TreacheryAttrs
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

dreadfulEffigy :: TreacheryCard DreadfulEffigy
dreadfulEffigy = treachery DreadfulEffigy Cards.dreadfulEffigy

{- | Confirmed by visually reading the real card (code 053): "Terror. Omen.
Revelation - Attach Dreadful Effigy to your location. Forced - As an
additional cost to leave this location, you must either spend 2 resources as
a group or place 1 doom on the agenda. Once this cost is paid, discard
Dreadful Effigy."
-}
instance HasModifiersFor DreadfulEffigy where
  getModifiersFor (DreadfulEffigy a) = case a.placement of
    AttachedToLocation lid ->
      modified_
        a
        lid
        [ AdditionalCostToLeave
            $ OrCost [GroupResourceCost (Static 2) Anywhere, DoomCost (toSource a) (AgendaMatcherTarget AnyAgenda) 1]
        ]
    _ -> pure mempty

instance HasAbilities DreadfulEffigy where
  getAbilities (DreadfulEffigy a) = case a.placement of
    AttachedToLocation lid -> [mkAbility a 1 $ forced $ Leaves #after You (LocationWithId lid)]
    _ -> []

instance RunMessage DreadfulEffigy where
  runMessage msg t@(DreadfulEffigy attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      withLocationOf iid (attachTreachery attrs)
      pure t
    UseThisAbility _iid (isSource attrs -> True) 1 -> do
      toDiscard (attrs.ability 1) attrs
      pure t
    _ -> DreadfulEffigy <$> liftRunMessage msg attrs
