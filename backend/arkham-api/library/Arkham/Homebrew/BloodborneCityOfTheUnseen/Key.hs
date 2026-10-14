{- | Campaign-log keys owned by the Bloodborne: City of the Unseen campaign.

Like an official campaign (e.g. @TheDunwichLegacyKey@), the campaign owns its own
key enum. It plugs into the core log via the single shared
'Arkham.CampaignLogKey.HomebrewCampaignLogKey' wrapper -- no per-campaign wiring
in core. Keys serialize by name through that wrapper. Mirrors
'Arkham.Homebrew.DarkMatter.Key''s pattern exactly.
-}
module Arkham.Homebrew.BloodborneCityOfTheUnseen.Key (module Arkham.Homebrew.BloodborneCityOfTheUnseen.Key) where

import Arkham.CampaignLogKey (CampaignLogKey (HomebrewCampaignLogKey), IsCampaignLogKey (..))
import Arkham.Prelude

{- | Campaign guide p.1-2: "Insight" rules. Each scenario begins with 3
insight tokens in the chaos bag; drawing one gives +1 and draws another
token, then (after the test resolves) it leaves the bag for the Insight
Display instead of returning to the pool. "If at any point there are three
insight tokens in the Insight Display, return all three tokens to the chaos
bag and mark +1 level of Recognition in your campaign log." This key is that
tally -- a campaign-wide count, incremented by
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins'. The
per-level Recognition effects described in the guide (additional Mythos sets
shuffled in at setup, unlocked story choices) are NOT YET IMPLEMENTED -- they
span scenarios 2-8 and the guide's later Campaign Setup pages, not read this
session.
-}
data BloodborneKey
  = Recognition
  deriving stock (Show, Read, Eq, Ord, Generic, Data)
  deriving anyclass (ToJSON, FromJSON)

instance IsCampaignLogKey BloodborneKey where
  toCampaignLogKey = HomebrewCampaignLogKey . ("bloodborneCityOfTheUnseen." <>) . tshow
  fromCampaignLogKey = \case
    HomebrewCampaignLogKey t ->
      readMay . unpack $ fromMaybe t (stripPrefix "bloodborneCityOfTheUnseen." t)
    _ -> Nothing
