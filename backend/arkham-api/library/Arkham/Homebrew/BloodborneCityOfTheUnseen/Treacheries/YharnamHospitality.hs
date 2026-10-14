module Arkham.Homebrew.BloodborneCityOfTheUnseen.Treacheries.YharnamHospitality (
  yharnamHospitality,
  yharnamHospitalityEffect,
) where

import Arkham.Ability
import Arkham.Effect.Import
import Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Treacheries qualified as Cards
import Arkham.Matcher
import Arkham.Message.Lifted.Choose
import Arkham.Treachery.Import.Lifted hiding (PerformAction)

newtype YharnamHospitality = YharnamHospitality TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

yharnamHospitality :: TreacheryCard YharnamHospitality
yharnamHospitality = treachery YharnamHospitality Cards.yharnamHospitality

{- | Confirmed by visually reading the real card (code 052): "Peril.
Revelation - Test agility or intellect (4). If you fail: until the end of
the round, take 1 damage each time you investigate or parley." The Peril
keyword itself is NOT separately modeled (this engine's Peril support, if
any, wasn't investigated this session). The round-scoped damage-on-action
consequence lives in the paired 'YharnamHospitalityEffect' below.
-}
instance RunMessage YharnamHospitality where
  runMessage msg t@(YharnamHospitality attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      sid <- getRandom
      chooseOneM iid do
        for_ [#agility, #intellect] \s ->
          skillLabeled s $ revelationSkillTest sid iid attrs s (Fixed 4)
      pure t
    FailedThisSkillTest iid (isSource attrs -> True) -> do
      createCardEffect Cards.yharnamHospitality Nothing attrs iid
      pure t
    _ -> YharnamHospitality <$> liftRunMessage msg attrs

newtype YharnamHospitalityEffect = YharnamHospitalityEffect EffectAttrs
  deriving anyclass (HasModifiersFor, IsEffect)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

yharnamHospitalityEffect :: EffectArgs -> YharnamHospitalityEffect
yharnamHospitalityEffect = cardEffect YharnamHospitalityEffect Cards.yharnamHospitality

instance HasAbilities YharnamHospitalityEffect where
  getAbilities (YharnamHospitalityEffect a) = case a.target of
    InvestigatorTarget iid ->
      [mkAbility a 1 $ forced $ PerformAction #after (InvestigatorWithId iid) (ActionOneOf [#investigate, #parley])]
    _ -> []

instance RunMessage YharnamHospitalityEffect where
  runMessage msg e@(YharnamHospitalityEffect attrs) = runQueueT $ case msg of
    UseThisAbility iid (isSource attrs -> True) 1 -> do
      assignDamage iid attrs.source 1
      pure e
    EndRound -> disableReturn e
    _ -> YharnamHospitalityEffect <$> liftRunMessage msg attrs
