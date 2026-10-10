module Arkham.Homebrew.BloodborneCityOfTheUnseen.Locations.HospitalCourtyard (hospitalCourtyard) where

import Arkham.Ability
import Arkham.GameValue
import Arkham.Helpers.Modifiers (ModifierType (..), modifySelf)
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Locations qualified as Cards
import Arkham.Location.Import.Lifted
import Arkham.Matcher
import Arkham.Strategy
import Arkham.Trait (Trait (Item, Supply))

newtype HospitalCourtyard = HospitalCourtyard LocationAttrs
  deriving anyclass IsLocation
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

-- | Clue count (1/investigator) confirmed via GMNotes. Shroud value is a
-- placeholder pending real card-sheet transcription (not in GMNotes).
hospitalCourtyard :: LocationCard HospitalCourtyard
hospitalCourtyard = location HospitalCourtyard Cards.hospitalCourtyard 2 (PerPlayer 1)

-- | "Hospital Courtyard is connected to City Center Plaza and vice versa" --
-- printed card text on City Center Plaza; symmetric half lives there too.
instance HasModifiersFor HospitalCourtyard where
  getModifiersFor (HospitalCourtyard a) =
    modifySelf a [ConnectedToWhen (be a) "City Center Plaza"]

{- | "-> Find among the top 6 cards of your deck an Item or Supply card and
add it to your hand. Shuffle your deck. (Not more than once per
investigator.)" -- confirmed by visually reading the real card (same text
shown in the live zoomed-card view, found live 2026-10-10 when the user
pointed out the printed action arrow had no corresponding ability). Modeled
on the real official precedent 'Location.Cards.SecurityOffice_128' (search
top 6, draw found card), with the matcher narrowed to Item-or-Supply traits
and 'playerLimit PerGame' for the "once per investigator" restriction.
-}
instance HasAbilities HospitalCourtyard where
  getAbilities (HospitalCourtyard a) =
    extend a [playerLimit PerGame $ restricted a 1 Here $ FastAbility Free]

instance RunMessage HospitalCourtyard where
  runMessage msg l@(HospitalCourtyard attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      search iid (attrs.ability 1) iid [fromTopOfDeck 6] (basic $ oneOf [CardWithTrait Item, CardWithTrait Supply]) (DrawFound iid 1)
      pure l
    _ -> HospitalCourtyard <$> liftRunMessage msg attrs
