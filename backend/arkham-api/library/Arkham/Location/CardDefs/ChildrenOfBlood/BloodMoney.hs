module Arkham.Location.CardDefs.ChildrenOfBlood.BloodMoney where

import Arkham.Location.CardDefs.Import

foyerBoringParty :: CardDef
foyerBoringParty =
  otherSideIs "13076b"
    $ location "13076" ("Foyer" <:> "Boring Party") [Hall] Circle [Square, T] BloodMoney

foyerBloodyNight :: CardDef
foyerBloodyNight =
  otherSideIs "13076"
    $ location "13076b" ("Foyer" <:> "Bloody Night") [Hall] Circle [Square, T] BloodMoney

diningHall :: CardDef
diningHall =
  location "13077" "Dining Hall" [Hall] Square [Circle, T, Triangle, Diamond] BloodMoney

studyChildrenOfBlood :: CardDef
studyChildrenOfBlood = location "13078" "Study" [] T [Circle, Square, Triangle, Hourglass] BloodMoney

masterBedroomChildrenOfBlood :: CardDef
masterBedroomChildrenOfBlood =
  victory 1
    $ locationWithUnrevealed
      "13079"
      "Master Bedroom"
      []
      Triangle
      [Square, T, Moon]
      "Master Bedroom"
      [Lair]
      Triangle
      [Square, T, Moon]
      BloodMoney

kitchenChildrenOfBlood :: CardDef
kitchenChildrenOfBlood = victory 1 $ location "13080" "Kitchen" [] Diamond [Square] BloodMoney

officeChildrenOfBlood :: CardDef
officeChildrenOfBlood = victory 1 $ location "13081" "Office" [] Hourglass [T] BloodMoney

balconyChildrenOfBlood :: CardDef
balconyChildrenOfBlood = victory 1 $ location "13082" "Balcony" [] Moon [Triangle] BloodMoney
