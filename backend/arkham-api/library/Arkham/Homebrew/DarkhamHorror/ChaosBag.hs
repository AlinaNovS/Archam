module Arkham.Homebrew.DarkhamHorror.ChaosBag where

import Arkham.ChaosToken
import Arkham.Difficulty

{- FOURMOLU_DISABLE -}
-- | Transcribed verbatim from frontend/homebrew/darkham-horror/campaign.json's own
-- existing difficultyLevels (same shared SCED-anthology template as every
-- other Tier-A campaign generated alongside this one -- see
-- [[project-arkham-homebrew-campaigns]]), not a guess.
chaosBagContents :: Difficulty -> [ChaosTokenFace]
chaosBagContents = \case
  Easy -> [ PlusOne, PlusOne, Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, Skull, Skull, Cultist, Cultist, AutoFail, ElderSign ]
  Standard -> [ PlusOne, Zero, Zero, MinusOne, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusFour, Skull, Skull, Cultist, Cultist, AutoFail, ElderSign ]
  Hard -> [ Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFive, Skull, Skull, Cultist, Cultist, AutoFail, ElderSign ]
  Expert -> [ Zero, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFour, MinusFive, MinusSix, MinusEight, Skull, Skull, Cultist, Cultist, AutoFail, ElderSign ]
{- FOURMOLU_ENABLE -}
