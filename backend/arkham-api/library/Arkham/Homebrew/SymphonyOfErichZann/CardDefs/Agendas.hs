module Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Agendas where

import Arkham.Agenda.CardDefs.Import
import Arkham.Homebrew.SymphonyOfErichZann.Sets qualified as Set

{- | Names, print order (1a/1b/2a/2b/3a/3b), and doom thresholds (6/5/4, same
on both a/b side of a stage) all confirmed 2026-10-14 by visually reading the
real card scans at
"~/Downloads/Arkham_Horror_LCG/6. Фанатские Сценарии/Симфония Эриха Цанна/Покарточная сборка/"
(files 2a/2b/3a/3b/4a/4b.png -- file 1a.png is this scenario's chaos-bag
reference card, not an agenda). RU names are the real printed titles; EN
names here are a plain literal translation for the internal CardDef key
only, per this project's established convention (see
Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Agendas) -- actual RU
display text is wired separately through the locale JSON layer, not
invented game text.
-}
overture :: CardDef
overture =
  agenda ":symphony-of-erich-zann:002" "Overture" 1 Set.SymphonyOfErichZann
    & otherSideIs ":symphony-of-erich-zann:003"

polymorphia :: CardDef
polymorphia = agenda ":symphony-of-erich-zann:003" "Polymorphia" 1 Set.SymphonyOfErichZann

crescendo :: CardDef
crescendo =
  agenda ":symphony-of-erich-zann:004" "Crescendo" 2 Set.SymphonyOfErichZann
    & otherSideIs ":symphony-of-erich-zann:005"

callOfTheVoid :: CardDef
callOfTheVoid = agenda ":symphony-of-erich-zann:005" "Call of the Void" 2 Set.SymphonyOfErichZann

greatestCreation :: CardDef
greatestCreation =
  agenda ":symphony-of-erich-zann:006" "The Greatest Creation" 3 Set.SymphonyOfErichZann
    & otherSideIs ":symphony-of-erich-zann:007"

inevitableEnd :: CardDef
inevitableEnd = agenda ":symphony-of-erich-zann:007" "The Inevitable End" 3 Set.SymphonyOfErichZann
