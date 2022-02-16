#include "inc_conopp"

void main()
{
    object oPC = GetLastPlayerDied();

    // save player's location and hp when they die
    SetPlayerJson(oPC, PLAYER_LOCATION, JsonLocation(GetLocation(oPC)));
    SetPlayerJson(oPC, PLAYER_HITPOINTS, JsonInt(GetCurrentHitPoints(oPC)));
}