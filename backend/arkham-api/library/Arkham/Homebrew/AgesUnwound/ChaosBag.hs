module Arkham.Homebrew.AgesUnwound.ChaosBag where

import Arkham.ChaosToken
import Arkham.Difficulty

{- FOURMOLU_DISABLE -}
{- | Campaign chaos bag (guide p3, "Campaign Setup" step 4). All four
difficulties share the same 3 skulls + 4 other special tokens; only the
numeric spread changes. The 4 non-skull special icons were read off a
compressed PDF render and are a best guess (Cultist, Tablet, ElderThing,
AutoFail, in that reading order) rather than a confirmed 1:1 icon match —
worth double-checking against the actual PnP chaos-bag reference card image
before relying on this in a real playthrough.
-}
chaosBagContents :: Difficulty -> [ChaosTokenFace]
chaosBagContents = \case
  Easy ->
    [ PlusOne, PlusOne, Zero, Zero, Zero, MinusOne, MinusOne, MinusOne, MinusTwo, MinusTwo
    , Skull, Skull, Skull, Cultist, Tablet, ElderThing, AutoFail
    ]
  Standard ->
    [ PlusOne, Zero, Zero, MinusOne, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusFour
    , Skull, Skull, Skull, Cultist, Tablet, ElderThing, AutoFail
    ]
  Hard ->
    [ Zero, Zero, Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFive
    , Skull, Skull, Skull, Cultist, Tablet, ElderThing, AutoFail
    ]
  Expert ->
    [ Zero, MinusOne, MinusOne, MinusTwo, MinusTwo, MinusThree, MinusThree, MinusFour, MinusFour, MinusFive, MinusSix, MinusEight
    , Skull, Skull, Skull, Cultist, Tablet, ElderThing, AutoFail
    ]
{- FOURMOLU_ENABLE -}
