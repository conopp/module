#include "nwnx_admin"

void main()
{
    // canceled out of char selection
    if (OBJECT_SELF == OBJECT_INVALID)
        return;

    object oPC = OBJECT_SELF;

    NWNX_Administration_DeleteTURD(GetPCPlayerName(oPC), GetName(oPC));
}