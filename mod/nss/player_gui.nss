#include "x3_inc_skin"
#include "nwnx_object"

void main()
{
    object oPC = GetLastGuiEventPlayer();

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED:
            // apply to new players
            if (NWNX_Object_PeekUUID(oPC) == "") {
                // variables
                SetSkinString(oPC, "uuid", GetObjectUUID(oPC));
                SetSkinString(oPC, "cdkey", GetPCPublicCDKey(oPC));
            }

            break;
    }
}