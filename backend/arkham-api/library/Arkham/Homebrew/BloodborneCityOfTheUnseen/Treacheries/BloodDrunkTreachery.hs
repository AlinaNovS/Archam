module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.BloodDrunkTreachery (bloodDrunkTreachery) where

import Arkham.Ability
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelect)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Placement
import Arkham.Treachery.Import.Lifted

newtype BloodDrunkTreachery = BloodDrunkTreachery TreacheryAttrs
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

bloodDrunkTreachery :: TreacheryCard BloodDrunkTreachery
bloodDrunkTreachery = treacheryWith BloodDrunkTreachery Cards.bloodDrunkTreachery (setMeta @Int 0)

{- | Confirmed by visually reading the real card (code 048): "Madness. Curse.
Revelation - Place Blood-Drunk in your threat area. You get -2 to Fight and
Investigate actions. [Action]: Test intellect (3). If you succeed, discard
Blood-Drunk. If you fail, reduce the difficulty of this test by 1 (to a
minimum of 1) until the end of the round." The -2 is modeled against the
default skill for each action (combat for Fight, intellect for Investigate)
-- a card that swaps the skill used wouldn't be covered, not investigated
further. 'meta' tracks the accumulated difficulty reduction (capped at 2,
since the test is Fixed 3 and the real minimum is 1), reset each round.
-}
instance HasModifiersFor BloodDrunkTreachery where
  getModifiersFor (BloodDrunkTreachery a) = case a.placement of
    InThreatArea iid ->
      modifySelect
        a
        (InvestigatorWithId iid)
        [ActionSkillModifier #fight #combat (-2), ActionSkillModifier #investigate #intellect (-2)]
    _ -> pure mempty

instance RunMessage BloodDrunkTreachery where
  runMessage msg t@(BloodDrunkTreachery attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      placeInThreatArea attrs iid
      pure t
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      sid <- getRandom
      let reduction = toResultDefault @Int 0 attrs.meta
      skillTestModifiers sid (attrs.ability 1) iid [SkillModifier #intellect reduction]
      beginSkillTest sid iid (attrs.ability 1) iid #intellect (Fixed 3)
      pure t
    PassedThisSkillTest iid (isAbilitySource attrs 1 -> True) -> do
      toDiscardBy iid (attrs.ability 1) attrs
      pure t
    FailedThisSkillTest _iid (isAbilitySource attrs 1 -> True) -> do
      let reduction = toResultDefault @Int 0 attrs.meta
      pure . BloodDrunkTreachery $ setMeta @Int (min 2 (reduction + 1)) attrs
    EndRound -> pure . BloodDrunkTreachery $ setMeta @Int 0 attrs
    _ -> BloodDrunkTreachery <$> liftRunMessage msg attrs
