- Left off: Making sure Sqlite queries work properly when getting & saving data into players .bic database (potential issues with null values etc, and we must be sure only 1 row ever exists)

# Checklist:
## feature/persistence
- [ ] Store player's properties to .bic in "player_logout", "player_ready" (in case a key was required to enter the area and server crashed), and OnUsed transition (in case player crashes when trying to enter new area) to restore during login
  - [x] Player's position; normally saves (with everything else) on exit
    - [x] Save position on exit
  - [x] Player's health
  - [ ] Player's effects (spells, vfx, etc)
    - [ ] Clear caster ID when effects are casted unto player, so caster resting doesn't prematurely remove effects from player
    - [x] Delete TURD after player leaves, so all logins are consistent and don't have to account for edge cases for both before/after server resets
  - [x] Player's spells; persists automatically by enabling the "Restore Spell Uses On Login = 1" server option in nwnplayer.ini

# Notes:
- Players read health values from TURDs, and if one doesn't exist for the player, their health is displayed as full on the character's login sheet; only known fix is creating an NWNX extension to hook whatever function reads the TURD to populate with our own info
- We can't serialize the player's TURD on logout and replace it on login, because while it'd be a very efficient solution, even if EatTURD was called after NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE, some negative effects don't persist to TURD anyway