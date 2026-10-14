module Arkham.Homebrew.BloodborneCityOfTheUnseen.Tokens where

import Arkham.ChaosToken.Types
import Arkham.Homebrew.TokenDefs

{- | The insight (eye) token. Campaign guide p.1 (downloaded and read directly
this session, not guessed): "This expansion introduces a new type of chaos
token: the insight token. [...] Each Scenario begins with three insight
tokens included in the Chaos bag. When an insight token is drawn during a
test, its modifier is treated as '+1 and draw another chaos token.' After
the effects of the test are resolved, do not return the insight token to the
chaos bag; instead, place the insight token in its designated display card
in your campaign log."

The "+1 and draw another" half is a generic reveal effect, handled below via
'RevealAnother' (same engine hook bless/curse/frost/the Circus Ex Mortis moon
token use). The "don't return to the bag, track toward Recognition instead"
half is scenario-state bookkeeping, not a generic reveal effect, so it is NOT
handled here -- see
'Arkham.Homebrew.BloodborneCityOfTheUnseen.Scenarios.HuntBegins' for that.
-}
pattern InsightToken :: ChaosTokenFace
pattern InsightToken = CustomToken ":bloodborne-city-of-the-unseen:insight"

customTokens :: [CustomTokenDef]
customTokens =
  [ CustomTokenDef
      { tokenSlug = ":bloodborne-city-of-the-unseen:insight"
      , tokenRevealEffect = RevealAnother
      }
  ]

data BloodborneCityOfTheUnseenTokens

instance IsHomebrewTokens BloodborneCityOfTheUnseenTokens where
  homebrewTokens = customTokens
