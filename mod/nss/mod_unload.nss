#include "inc_general"
#include "inc_skin"

void main()
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
        if (GetIsDead(oPC) || !GetIsLocationValid(GetLocation(oPC)))
            continue;

        SetSkinLocation(oPC, PL_LOCATION, GetLocation(oPC));
        SetSkinInt(oPC, PL_HITPOINTS, GetCurrentHitPoints(oPC));
        // SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));

        oPC = GetNextPC();
    }

    ExportAllCharacters();
}