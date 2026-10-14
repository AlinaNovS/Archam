module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.ViewHalloo (viewHalloo) where

import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Message.Lifted (resolveHunterKeyword)
import Arkham.Projection
import Arkham.Trait (Trait (HomebrewTrait))
import Arkham.Treachery.Import.Lifted

newtype ViewHalloo = ViewHalloo TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

viewHalloo :: TreacheryCard ViewHalloo
viewHalloo = treachery ViewHalloo Cards.viewHalloo

{- | Reproduced live and reported by the user (code 019, Russian in-game text
"Охотничий клич!"): "Revelation - Test willpower (3). If you fail: Each
blood-drunk enemy in play performs its Hunter keyword. If no blood-drunk
enemy in play was moved by this effect, discard cards from the top of the
Contact [encounter] deck until you discard one, then put that enemy into
play at the connected location." NOTE: skill is willpower per the user's
live RU screenshot, NOT the agility this session's own English card-scan
read initially suggested -- trust her live source over the scan.

The "each Blood-Drunk enemy resolves Hunter" half is wired for real via
'resolveHunterKeyword', with before/after location snapshots to detect
whether anything actually moved. The "if nothing moved, dig the encounter
deck for an enemy and spawn it at a connected location" fallback is NOT YET
IMPLEMENTED -- no existing helper for "discard encounter cards until an
enemy, then spawn it" was found this session; needs its own deck-digging
loop, not guessed at here to avoid getting the engine's encounter-deck/
discard-pile bookkeeping subtly wrong.
-}
instance RunMessage ViewHalloo where
  runMessage msg t@(ViewHalloo attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      sid <- getRandom
      revelationSkillTest sid iid attrs #willpower (Fixed 3)
      pure t
    FailedThisSkillTest _iid (isSource attrs -> True) -> do
      bloodDrunkEnemies <- select $ EnemyWithTrait (HomebrewTrait "Blood-Drunk")
      before <- traverse (\eid -> (eid,) <$> field EnemyLocationId eid) bloodDrunkEnemies
      for_ bloodDrunkEnemies resolveHunterKeyword
      after <- traverse (\eid -> (eid,) <$> field EnemyLocationId eid) bloodDrunkEnemies
      when (before == after) do
        -- TODO: "discard the encounter deck until an enemy, spawn it at a
        -- connected location" is NOT YET IMPLEMENTED, see doc comment above.
        pure ()
      pure t
    _ -> ViewHalloo <$> liftRunMessage msg attrs
