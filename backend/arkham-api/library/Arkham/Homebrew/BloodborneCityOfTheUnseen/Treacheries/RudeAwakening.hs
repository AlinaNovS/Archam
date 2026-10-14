module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.RudeAwakening (rudeAwakening) where

import Arkham.Ability
import Arkham.Helpers.Modifiers (ModifierType (..), inThreatAreaGets)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Message.Lifted.Choose
import Arkham.Treachery.Import.Lifted

newtype RudeAwakening = RudeAwakening TreacheryAttrs
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

rudeAwakening :: TreacheryCard RudeAwakening
rudeAwakening = treachery RudeAwakening Cards.rudeAwakening

{- | Confirmed by visually reading the real card (code 086): "Omen.
Revelation - Test intellect (3). If you fail, put Rude Awakening into play in
your threat area. As an additional cost to take Move actions, you must
choose and discard a card from your hand. Forced - At the end of your turn,
test intellect or agility (3). If you succeed, discard Rude Awakening." The
additional-Move-cost half mirrors the official DarkMatter Infection card's
identical "additional cost to move: pay X" idiom.
-}
instance HasModifiersFor RudeAwakening where
  getModifiersFor (RudeAwakening a) =
    inThreatAreaGets a [AdditionalCostToPerformAction (IsAction #move) (HandDiscardCost 1 #any)]

instance HasAbilities RudeAwakening where
  getAbilities (RudeAwakening a) = [skillTestAbility $ restricted a 1 (InThreatAreaOf You) $ forced $ TurnEnds #when You]

instance RunMessage RudeAwakening where
  runMessage msg t@(RudeAwakening attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      sid <- getRandom
      revelationSkillTest sid iid attrs #intellect (Fixed 3)
      pure t
    FailedThisSkillTest iid (isSource attrs -> True) -> do
      placeInThreatArea attrs iid
      pure t
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      sid <- getRandom
      chooseOneM iid do
        for_ [#intellect, #agility] \s ->
          skillLabeled s $ beginSkillTest sid iid (attrs.ability 1) iid s (Fixed 3)
      pure t
    PassedThisSkillTest iid (isAbilitySource attrs 1 -> True) -> do
      toDiscardBy iid (attrs.ability 1) attrs
      pure t
    _ -> RudeAwakening <$> liftRunMessage msg attrs
