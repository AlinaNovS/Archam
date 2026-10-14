module Arkham.Homebrew.SymphonyOfErichZann.Sets (
  module Arkham.EncounterSet,
  pattern SymphonyOfErichZann,
) where

import Arkham.EncounterSet

-- | Single encounter set for this standalone scenario, matching the
-- established one-set-per-pilot-slice pattern (see
-- Arkham.Homebrew.BloodborneCityOfTheUnseen.Sets). The author's own
-- material also names a "Погребальная месса" (Requiem Mass) sub-set (home
-- of "Пляшущие крысы" / Dancing Rats), not split out separately yet since
-- that card isn't implemented this round -- see
-- project_arkham_homebrew_campaigns.md's 2026-10-14 entry for what's left.
pattern SymphonyOfErichZann :: EncounterSet
pattern SymphonyOfErichZann = Homebrew ":symphony-of-erich-zann:symphony_of_erich_zann"
