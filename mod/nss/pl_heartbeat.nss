#include "inc_general"
#include "inc_skin"
#include "inc_effects"

void main()
{
    object oPC = OBJECT_SELF;

    if (GetIsDead(oPC) || !GetIsLocationValid(GetLocation(oPC)))
        return;

    SetSkinLocation(oPC, PL_LOCATION, GetLocation(oPC));
    SetSkinInt(oPC, PL_HITPOINTS, GetCurrentHitPoints(oPC));
    // SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));
}