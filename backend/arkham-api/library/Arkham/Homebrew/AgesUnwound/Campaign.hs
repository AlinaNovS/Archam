module Arkham.Homebrew.AgesUnwound.Campaign (agesUnwound) where

import Arkham.Campaign.Import.Lifted
import Arkham.Homebrew.AgesUnwound.CampaignSteps
import Arkham.Homebrew.AgesUnwound.Import

newtype AgesUnwound = AgesUnwound CampaignAttrs
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor)

agesUnwound :: Difficulty -> AgesUnwound
agesUnwound = campaign AgesUnwound (CampaignId ":ages-unwound") "Ages Unwound"

instance IsCampaign AgesUnwound where
  campaignTokens = chaosBagContents
  nextStep a = case (toAttrs a).normalizedStep of
    PrologueStep -> continue NightOfFireStep
    -- Scenarios II-VII are not implemented yet; the campaign pilot ends here.
    NightOfFireStep -> Nothing
    other -> defaultNextStep other

instance RunMessage AgesUnwound where
  runMessage msg c = runQueueT $ campaignI18n $ case msg of
    CampaignStep PrologueStep -> do
      scope "intro" $ flavor $ setTitle "title" >> p "body"
      record StrangeAssistance
      nextCampaignStep
      pure c
    _ -> lift $ defaultCampaignRunner msg c
