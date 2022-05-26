#include "inc_skin"
#include "inc_effects"

void main()
{
    // canceled out of char selection
    if (OBJECT_SELF == OBJECT_INVALID)
        return;

    object oPC = OBJECT_SELF;

    SetSkinLocation(oPC, PL_LOCATION, GetLocation(oPC));
    SetSkinInt(oPC, PL_HITPOINTS, GetCurrentHitPoints(oPC));
    SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));

    ExportSingleCharacter(oPC);
}