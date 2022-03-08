#include "inc_conopp"

void main() {
    object oPC = GetLastRespawnButtonPresser();

    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectHeal(GetMaxHitPoints(oPC)), oPC);

    SetHPOverrideLevel(oPC);
}