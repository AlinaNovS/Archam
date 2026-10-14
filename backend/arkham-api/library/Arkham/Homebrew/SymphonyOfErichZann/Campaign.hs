module Arkham.Homebrew.SymphonyOfErichZann.Campaign (symphonyOfErichZann) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CampaignSteps
import Arkham.Homebrew.SymphonyOfErichZann.Import

newtype SymphonyOfErichZann = SymphonyOfErichZann CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

symphonyOfErichZann :: Difficulty -> SymphonyOfErichZann
symphonyOfErichZann =
  campaign SymphonyOfErichZann (CampaignId ":symphony-of-erich-zann") "Symphony of Erich Zann"

{- | Single-scenario design, matching the author's own dev notes (playable
standalone OR as a 2-XP "interlude" between any two scenarios of any other
campaign -- the "interlude" mode has no equivalent anywhere else in this
engine's homebrew framework and is NOT modelled here, standalone-only for
now). Wrapped in the trivial 1-scenario Campaign shape established by
Arkham.Homebrew.BloodborneCityOfTheUnseen.Campaign even though this isn't a
multi-scenario campaign, since that's this engine's only registrable
"playable unit" for homebrew content.
-}
instance IsCampaign SymphonyOfErichZann where
  campaignTokens = chaosBagContents
  nextStep a = case (toAttrs a).normalizedStep of
    PrologueStep -> continue SymphonyOfErichZannStep
    SymphonyOfErichZannStep -> Nothing
    other -> defaultNextStep other

instance RunMessage SymphonyOfErichZann where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      nextCampaignStep
      pure c
    _ -> lift $ defaultCampaignRunner msg c
