module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.SlakeTheThirst (slakeTheThirst) where

import Arkham.Ability
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Message.Lifted.Choose
import Arkham.Treachery.Import.Lifted

newtype SlakeTheThirst = SlakeTheThirst TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

slakeTheThirst :: TreacheryCard SlakeTheThirst
slakeTheThirst = treacheryWith SlakeTheThirst Cards.slakeTheThirst (setMeta @Bool False)

{- | Confirmed by visually reading the real card (code 049): "Madness.
Revelation - Place Slake the Thirst in your threat area. [Action]: You try
to maintain composure. Forced - At the end of your turn, if you did not
perform the above [Action] ability: Deal 1 damage and 1 horror to another
investigator at your location (if you cannot, take 2 damage or 2 horror).
Then, discard Slake the Thirst." 'meta' tracks whether the composure action
was taken this turn, same pattern as the official ArmInjury.
-}
instance HasAbilities SlakeTheThirst where
  getAbilities (SlakeTheThirst a) =
    [ restricted a 1 (InThreatAreaOf You) actionAbility
    , restricted a 2 (InThreatAreaOf You) $ forced $ TurnEnds #when You
    ]

instance RunMessage SlakeTheThirst where
  runMessage msg t@(SlakeTheThirst attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      placeInThreatArea attrs iid
      pure t
    UseThisAbility _iid (isSource attrs -> True) 1 -> do
      pure . SlakeTheThirst $ setMeta @Bool True attrs
    UseThisAbility iid (isSource attrs -> True) 2 | not (toResultDefault False attrs.meta) -> do
      others <- select $ colocatedWith iid <> not_ (InvestigatorWithId iid)
      case others of
        [] -> do
          chooseOneM iid do
            labeled "Take 2 damage" $ assignDamage iid attrs 2
            labeled "Take 2 horror" $ assignHorror iid attrs 2
        _ -> chooseOrRunOneM iid $ targets others \iid' -> do
          assignDamage iid' attrs 1
          assignHorror iid' attrs 1
      toDiscardBy iid (attrs.ability 2) attrs
      pure t
    UseThisAbility _iid (isSource attrs -> True) 2 -> do
      pure . SlakeTheThirst $ setMeta @Bool False attrs
    EndTurn _ -> pure . SlakeTheThirst $ setMeta @Bool False attrs
    _ -> SlakeTheThirst <$> liftRunMessage msg attrs
