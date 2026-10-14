module Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Acts where

import Arkham.Act.CardDefs.Import
import Arkham.Homebrew.SymphonyOfErichZann.Sets qualified as Set

{- | Names and play order confirmed 2026-10-14 by visually reading the real
act card scans (files 5a/6a/7a.png, "Сцена 1a"/"Сцена 2a"/"Сцена 3a"). Each
act here is modelled as a single CardDef (matching
Arkham.Homebrew.BloodborneCityOfTheUnseen's simpler acts, not the two-CardDef
pattern used for this scenario's own Agendas) -- note a real "Сцена 2b" card
("Музыка Эриха Цанна") also exists with its own setup/transition text
(discard Auguste Goden's defeated-tokens, place the backstage corridor + the
6-card randomized "???" location pool) that doesn't cleanly map onto either
"a single CardDef's A/B flip" or "a second paired CardDef" without checking
how this engine's homebrew framework expects a transition-only card to be
modelled -- NOT investigated further this session, flag before implementing
Act 2's advance.
-}
musicFromTheAuseilTheatre :: CardDef
musicFromTheAuseilTheatre = act ":symphony-of-erich-zann:008" "Music from the Auseil Theatre" 1 Set.SymphonyOfErichZann

thePossessedConductor :: CardDef
thePossessedConductor = act ":symphony-of-erich-zann:009" "The Possessed Conductor" 2 Set.SymphonyOfErichZann

theUnimaginableOrchestra :: CardDef
theUnimaginableOrchestra = act ":symphony-of-erich-zann:010" "The Unimaginable Orchestra" 3 Set.SymphonyOfErichZann
