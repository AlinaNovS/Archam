{- | Campaign-log keys owned by the Ages Unwound campaign.

Like an official campaign, the campaign owns its own key enum, plugging into
the core log via the shared 'Arkham.CampaignLogKey.HomebrewCampaignLogKey'
wrapper — no per-campaign wiring in core.
-}
module Arkham.Homebrew.AgesUnwound.Key (module Arkham.Homebrew.AgesUnwound.Key) where

import Arkham.CampaignLogKey (CampaignLogKey (HomebrewCampaignLogKey), IsCampaignLogKey (..))
import Arkham.Prelude

data AgesUnwoundKey
  = -- | Scenario I: Night of Fire, resolution 1 (no resolution / defeat)
    YourHuntersFoundANewQuarry
  | -- | Scenario I: Night of Fire, resolution 2
    TheInvestigatorsSurvivedTheNightOfFire
  | -- | Scenario I: Night of Fire, resolution 3
    TheInvestigatorsSlewTheirStrangeObserver
  | -- | Prologue: recorded when the investigators' lives are saved
    StrangeAssistance
  deriving stock (Show, Read, Eq, Ord, Generic, Data)
  deriving anyclass (ToJSON, FromJSON)

instance IsCampaignLogKey AgesUnwoundKey where
  toCampaignLogKey = HomebrewCampaignLogKey . ("agesUnwound." <>) . tshow
  fromCampaignLogKey = \case
    HomebrewCampaignLogKey t ->
      readMay . unpack $ fromMaybe t (stripPrefix "agesUnwound." t)
    _ -> Nothing
