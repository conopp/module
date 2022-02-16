#include "nwnx_object"
#include "inc_conopp"

void main()
{
    // player was in character selection but canceled out
    if (OBJECT_SELF == OBJECT_INVALID) return;

    // save player's progress
    SetPlayerJson(OBJECT_SELF, PLAYER_LOCATION, JsonLocation(GetLocation(OBJECT_SELF)));
    SetPlayerJson(OBJECT_SELF, PLAYER_HITPOINTS, JsonInt(GetCurrentHitPoints(OBJECT_SELF)));
    SetPlayerJson(OBJECT_SELF, PLAYER_EFFECTS, GetCurrentEffects(OBJECT_SELF));
}