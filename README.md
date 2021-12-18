# Checklist:
## feature/persistence
- [ ] Store player's properties to .bic in "player_logout", "player_ready" (in case a key was required to enter the area and server crashed), and OnUsed transition (in case player crashes when trying to enter new area) to restore during login
  - [ ] Player's position; normally saves (with everything else) on exit
    - [ ] Save position on exit
  - [ ] Player's health; correct hp will show on character sheet on login also
  - [ ] Player's effects (spells, vfx, etc)
    - [ ] Clear caster ID when effects are casted unto player, so caster resting doesn't prematurely remove effects from player
    - [x] Delete TURD after player leaves, so all logins are consistent and don't have to account for edge cases for both before/after server resets
  - [x] Player's spells; persists automatically by enabling the "Restore Spell Uses On Login = 1" server option in nwnplayer.ini
- [] Currently unsolvable issues
  - [] Players read health values from TURDs, and if one doesn't exist for the player, their health is displayed as full on the character's login sheet (0x7f000000 is the starting value of the oID range TURDs use; also see CLastUpdateObject.hpp properties that likely make up the TURD when SaveTURD is called)

# Todo:
- [] Instead of trying to write to player's .bic database on logout, serialize the TURD to the player's .bic database, delete it from the game, and respawn it on NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE; with some luck, we don't need to persist any data because the player will call EatTURD during/after NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE