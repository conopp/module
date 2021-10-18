#include "x3_inc_skin"
#include "nwnx_object"

void main()
{
    object oPC = GetLastGuiEventPlayer();

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED:
            // apply to all players
            SetTextureOverride("isk_aniemp", Get2DAString("skills", "Icon", SKILL_ANIMAL_EMPATHY), oPC);
            SetTextureOverride("isk_olock", Get2DAString("skills", "Icon", SKILL_OPEN_LOCK), oPC);

            // apply to new players
            if (NWNX_Object_PeekUUID(oPC) != "") {
                // variables
                SetSkinString(oPC, "uuid", GetObjectUUID(oPC));
                SetSkinString(oPC, "cdkey", GetPCPublicCDKey(oPC));
            }

            break;
    }
}