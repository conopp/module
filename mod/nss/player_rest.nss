#include "inc_conopp"

void main()
{
    object oPC = GetLastPCRested();

    switch (GetLastRestEventType()) {
        case REST_EVENTTYPE_REST_STARTED: {
            effect eHPOverride = TagEffect(EffectRunScript("", "effect_hpovr", "effect_hpovr", 0.5), "hpovr");
            float fDura = StringToFloat(Get2DAString("restduration", "DURATION", GetHitDice(oPC)));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHPOverride, oPC, fDura);
        }
        case REST_EVENTTYPE_REST_FINISHED: RemoveEffectsByType(oPC, NWNX_EFFECT_TYPE_RUNSCRIPT, "hpovr"); break;
        case REST_EVENTTYPE_REST_CANCELLED: RemoveEffectsByType(oPC, NWNX_EFFECT_TYPE_RUNSCRIPT, "hpovr"); break;
    }
}