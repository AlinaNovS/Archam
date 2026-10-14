module Arkham.Homebrew.SymphonyOfErichZann.Enemies.AugusteGoden (augusteGoden) where

import Arkham.Enemy.Import.Lifted
import Arkham.Homebrew.SymphonyOfErichZann.CardDefs.Enemies qualified as Cards

newtype AugusteGoden = AugusteGoden EnemyAttrs
  deriving anyclass (IsEnemy, HasModifiersFor)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasAbilities)

{- | Act 2 boss. Stats confirmed for real (see CardDefs.Enemies.augusteGoden).
NOT YET IMPLEMENTED: the Forced "heal instead of defeat while a
music-treachery is in play" clause (needs the music-treachery Meta/cap
tracker from Agendas.Overture to exist first, so there's something to query
and discard from), and the "spend 1 clue: Negotiate, deal 2 damage" action
ability. Stub only, matches this project's established minimal-stub enemy
pattern.
-}
augusteGoden :: EnemyCard AugusteGoden
augusteGoden = enemy AugusteGoden Cards.augusteGoden

instance RunMessage AugusteGoden where
  runMessage msg (AugusteGoden attrs) = AugusteGoden <$> runMessage msg attrs
