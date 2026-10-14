module Arkham.Homebrew.SymphonyOfErichZann.ChaosBag where

import Arkham.ChaosToken
import Arkham.Difficulty

{- | NOT SOURCED YET -- unlike Bloodborne (which had a real frontend
campaign.json with confirmed per-difficulty counts), this fan scenario has
no deployed frontend entry and the scanned card set includes a "Легкий /
Обычный" (Easy/Standard) special-token reference card (file 1a.png) that
only documents the 4 SPECIAL token effects (Skull/a green token/a blue token/
a 4th token -- real mapping to ChaosTokenFace not confirmed, see below), not
bag composition counts, and a presumed Hard/Expert reference card (1b.png)
was never read. The values below are an explicit, documented PLACEHOLDER --
copied verbatim from Bloodborne's own baseline shape purely so this compiles
-- NOT a real Symphony of Erich Zann chaos bag. Do not treat this scenario as
playable until this is replaced with real sourced data (re-read 1a.png/1b.png
fully, confirm which of Skull/Cultist/Tablet/ElderThing each custom icon
actually corresponds to -- the icons' colors didn't cleanly match the
official base-game token art, so don't guess the mapping either).
-}
{- FOURMOLU_DISABLE -}
chaosBagContents :: Difficulty -> [ChaosTokenFace]
chaosBagContents = \case
  Easy ->
    [ PlusOne, PlusOne, Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign
    ]
  Standard ->
    [ PlusOne, Zero, Zero, MinusOne, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusFour
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign
    ]
  Hard ->
    [ Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFive
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign
    ]
  Expert ->
    [ Zero, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFour, MinusFive, MinusSix, MinusEight
    , Skull, Skull, Cultist, Cultist, AutoFail, ElderSign
    ]
{- FOURMOLU_ENABLE -}
