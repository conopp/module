#include "inc_skin"

void main() {
    object oPC = GetLastRespawnButtonPresser();

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);

    SetSkinInt(oPC, PL_HITPOINTS, GetCurrentHitPoints(oPC));
}