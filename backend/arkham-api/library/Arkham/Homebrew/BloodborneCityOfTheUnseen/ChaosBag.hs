module Arkham.Homebrew.BloodborneCityOfTheUnseen.ChaosBag where

import Arkham.ChaosToken
import Arkham.Difficulty
import Arkham.Homebrew.BloodborneCityOfTheUnseen.Tokens (pattern InsightToken)

{- FOURMOLU_DISABLE -}
-- | Confirmed via frontend/homebrew/bloodborne-city-of-the-unseen/campaign.json
-- (the same difficultyLevels data the site's own campaign-picker UI already
-- reads) -- not a guess, this is the campaign's real, existing chaos bag
-- definition, just not yet consumed on the Haskell side. 'InsightToken' x3 is
-- NOT part of that JSON (the site's picker predates this token's
-- implementation) -- added per the real Campaign Guide PDF p.1, read directly
-- this session: "Each Scenario begins with three insight tokens included in
-- the Chaos bag," flat across every difficulty (not difficulty-scaled, unlike
-- Skull/Cultist -- confirmed by the TTS mod's token pool having exactly 3
-- physical insight tiles total, no difficulty-specific variants).
chaosBagContents :: Difficulty -> [ChaosTokenFace]
chaosBagContents = \case
  Easy ->
    [ PlusOne, PlusOne, Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign, InsightToken, InsightToken, InsightToken
    ]
  Standard ->
    [ PlusOne, Zero, Zero, MinusOne, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusFour
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign, InsightToken, InsightToken, InsightToken
    ]
  Hard ->
    [ Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFive
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign, InsightToken, InsightToken, InsightToken
    ]
  Expert ->
    [ Zero, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFour, MinusFive, MinusSix, MinusEight
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign, InsightToken, InsightToken, InsightToken
    ]
{- FOURMOLU_ENABLE -}
