module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.UncontrolledFire (uncontrolledFire) where

import Arkham.Ability
import Arkham.Helpers.Location (withLocationOf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Placement
import Arkham.Treachery.Import.Lifted

newtype UncontrolledFire = UncontrolledFire TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

uncontrolledFire :: TreacheryCard UncontrolledFire
uncontrolledFire = treachery UncontrolledFire Cards.uncontrolledFire

{- | Confirmed by visually reading the real card (code 121): "Hazard.
Revelation - Attach Uncontrolled Fire to your location. Forced - After you
end your turn at this location or a connecting location: Take 1 damage.
[Action] Test agility (3): Discard Uncontrolled Fire."
-}
instance HasAbilities UncontrolledFire where
  getAbilities (UncontrolledFire a) = case a.placement of
    AttachedToLocation lid ->
      [ mkAbility a 1
          $ forced
          $ TurnEnds #when (You <> InvestigatorAt (oneOf [LocationWithId lid, connectedTo (LocationWithId lid)]))
      , skillTestAbility $ restricted a 2 OnSameLocation actionAbility
      ]
    _ -> []

instance RunMessage UncontrolledFire where
  runMessage msg t@(UncontrolledFire attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      withLocationOf iid (place attrs . AttachedToLocation)
      pure t
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      assignDamage iid attrs 1
      pure t
    UseThisAbility iid (isSource attrs -> True) 2 -> do
      sid <- getRandom
      beginSkillTest sid iid (attrs.ability 2) iid #agility (Fixed 3)
      pure t
    PassedThisSkillTest iid (isAbilitySource attrs 2 -> True) -> do
      toDiscardBy iid (attrs.ability 2) attrs
      pure t
    _ -> UncontrolledFire <$> liftRunMessage msg attrs
