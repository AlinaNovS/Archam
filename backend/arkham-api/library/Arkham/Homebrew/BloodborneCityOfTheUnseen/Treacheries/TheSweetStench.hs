module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.TheSweetStench (theSweetStench) where

import Arkham.Ability
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelect, modifySelf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Placement
import Arkham.Trait (Trait (Humanoid))
import Arkham.Treachery.Import.Lifted

newtype TheSweetStench = TheSweetStench TreacheryAttrs
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

theSweetStench :: TreacheryCard TheSweetStench
theSweetStench = treachery TheSweetStench Cards.theSweetStench

{- | Confirmed by visually reading the real card (code 050): "Omen.
Revelation - Test intellect (3). If you fail: Place The Sweet Stench in your
threat area. You get -2 skill value during Evade actions and each Humanoid
enemy in play gains Prey - You. [Action x3]: Discard The Sweet Stench." The
-2 is modeled against agility specifically (the default/near-universal Evade
skill) -- a card effect that swaps which skill resolves an Evade test would
not be covered by this, not investigated further this session.
-}
instance HasModifiersFor TheSweetStench where
  getModifiersFor (TheSweetStench a) = case a.placement of
    InThreatArea iid -> do
      self <- modifySelf a [ActionSkillModifier #evade #agility (-2)]
      others <- modifySelect a (EnemyWithTrait Humanoid) [ForcePrey (Prey (InvestigatorWithId iid))]
      pure $ self <> others
    _ -> pure mempty

instance HasAbilities TheSweetStench where
  getAbilities (TheSweetStench a) = [restricted a 1 (InThreatAreaOf You) actionAbility]

instance RunMessage TheSweetStench where
  runMessage msg t@(TheSweetStench attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      sid <- getRandom
      revelationSkillTest sid iid attrs #intellect (Fixed 3)
      pure t
    FailedThisSkillTest iid (isSource attrs -> True) -> do
      placeInThreatArea attrs iid
      pure t
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      toDiscardBy iid (attrs.ability 1) attrs
      pure t
    _ -> TheSweetStench <$> liftRunMessage msg attrs
