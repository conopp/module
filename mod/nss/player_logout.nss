#include "nwnx_object"
#include "inc_conopp"

void main()
{
    // player was in character selection but canceled out
    if (OBJECT_SELF == OBJECT_INVALID) return;

    // save player's progress
    SetPlayerJson(OBJECT_SELF, PLAYER_LOCATION, JsonLocation(GetLocation(oPC)));
    SetPlayerJson(OBJECT_SELF, PLAYER_HITPOINTS, JsonInt(GetCurrentHitPoints(oPC)));
    SetPlayerJson(OBJECT_SELF, PLAYER_EFFECTS, GetCurrentEffects(oPC));
}