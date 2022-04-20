#include "inc_general"
#include "inc_skin"
#include "nwnx_player"
#include "nwnx_object"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = GetSkinLocation(oPC, PL_LOCATION);

    if (GetIsLocationValid(lLoc))
        NWNX_Player_SetSpawnLocation(oPC, lLoc);
}