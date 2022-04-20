#include "inc_skin"
#include "inc_effects"
#include "nwnx_admin"

void main()
{
    object oPC = OBJECT_SELF;
    NWNX_Administration_DeleteTURD(GetPCPlayerName(oPC), GetName(oPC));
}