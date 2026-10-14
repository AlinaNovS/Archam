module Arkham.Homebrew.SymphonyOfErichZann.Acts.MusicFromTheAuseilTheatre (musicFromTheAuseilTheatre) where

import Arkham.Ability
import Arkham.Act.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Acts qualified as Cards
import Arkham.Matcher hiding (DuringTurn)

newtype MusicFromTheAuseilTheatre = MusicFromTheAuseilTheatre ActAttrs
  deriving anyclass IsAct
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

instance HasModifiersFor MusicFromTheAuseilTheatre

{- | Real text ("Сцена 1a", file 5a.png): Auguste Goden, the theater's
conductor, asks to meet you at the Vestibule to discuss Zann's disappearance.
Objective -- when the round ends, investigators may collectively spend the
required number of clues (3 per investigator, confirmed by the printed
threshold icon) to advance. Unlike Bloodborne's City Center Plaza version of
this same mechanic, this act's clue spend is NOT location-gated -- so there's
no 'restricted'/'exists' precondition wrapper here. Matches the official
ungated pattern in Arkham.Act.Cards.AFamiliarPattern (plain 'mkAbility' +
'Objective', no 'restricted'), combined with the 'triggered (RoundEnds
#when)' trigger shape both Bloodborne's own acts and the official
Arkham.Act.Cards.ABotanicalSurvey/DesperateSearch use for this exact "group
clue spend when round ends" mechanic.
-}
instance HasAbilities MusicFromTheAuseilTheatre where
  getAbilities (MusicFromTheAuseilTheatre a) =
    extend
      a
      [ mkAbility a 1 $ Objective $ triggered (RoundEnds #when) $ GroupClueCost (PerPlayer 3) Anywhere
      ]

musicFromTheAuseilTheatre :: ActCard MusicFromTheAuseilTheatre
musicFromTheAuseilTheatre = act (1, A) MusicFromTheAuseilTheatre Cards.musicFromTheAuseilTheatre Nothing

instance RunMessage MusicFromTheAuseilTheatre where
  runMessage msg a@(MusicFromTheAuseilTheatre attrs) = runQueueT $ case msg of
    AdvanceAct (isSide B attrs -> True) _ _ -> do
      advanceActDeck attrs
      pure a
    _ -> MusicFromTheAuseilTheatre <$> liftRunMessage msg attrs
