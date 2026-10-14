module Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Enemies where

import Arkham.Enemy.CardDefs.Import
import Arkham.Homebrew.SymphonyOfErichZann.Sets qualified as Set
import Arkham.Trait (Trait (HomebrewTrait))

{- | Fight/Health/Evade/traits/spawn location confirmed 2026-10-14 by
visually reading the real card scan (file 5b.png, "Враг", "Огюст Годен",
"Дирижёр пустоты"). Damage/horror dealt on attack are not legible/printed
distinctly on this card's layout -- using the conservative LCG baseline of
1/0 as an explicit documented placeholder, same convention as
Arkham.Homebrew.BloodborneCityOfTheUnseen.CardDefs.Enemies.bloodDrunkHunter.
Real text (both NOT YET IMPLEMENTED, see Enemies.AugusteGoden): "Обязательно
— Когда «Огюст Годен» должен быть побеждён, если хотя бы 1 напасть-музыка в
игре: вместо того, чтобы победить «Огюста Годена», сбросьте 1 напасть-музыку
из игры и вылечите ему все раны." / action ability "Потратьте 1 улику:
Переговоры. Нанесите 2 раны «Огюсту Годену»."
-}
augusteGoden :: CardDef
augusteGoden =
  (enemy ":symphony-of-erich-zann:011" "Auguste Goden" Set.SymphonyOfErichZann 0)
    { cdHealthDamage = healthDamage 1
    , cdSanityDamage = sanityDamage 0
    , cdFight = fight 3
    , cdEvade = evade 2
    , cdHealth = health 2
    , cdCardTraits = setFromList [Humanoid, HomebrewTrait "Musician", Elite]
    , cdVictoryPoints = Just 0
    }
