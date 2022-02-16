#include "nwnx_effect"
#include "nwnx_chat"
#include "x3_inc_string"
#include "inc_conopp"

void SetVisionEffect(object oPC, int nVisionType) {
    struct NWNX_EffectUnpacked eEffect = BlankEffect();
    eEffect.nType = 69;
    eEffect.nSubType = 9;
    eEffect.fDuration = 30.0;
    eEffect.nParam0 = nVisionType;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, NWNX_Effect_PackEffect(eEffect), oPC, eEffect.fDuration);
}

void SetAIState(object oPC, int nBit) {
    struct NWNX_EffectUnpacked eEffect = BlankEffect();
    eEffect.nType = 23;
    eEffect.nSubType = 9;
    eEffect.fDuration = 30.0;
    eEffect.nParam0 = nBit;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, NWNX_Effect_PackEffect(eEffect), oPC, eEffect.fDuration);
}

void PrintEffects2(object oPC) {
    SendMessageToPC(oPC, "XXXXX PRINT_EFFECTS XXXXX");

    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);

        if (eEffect.nType != 68) {
            SendMessageToPC(oPC, "sID = " + eEffect.sID);
            SendMessageToPC(oPC, "nType = " + IntToString(eEffect.nType));
            SendMessageToPC(oPC, "nSubType = " + IntToString(eEffect.nSubType));
            SendMessageToPC(oPC, "fDuration = " + FloatToString(eEffect.fDuration, 4, 1));
            SendMessageToPC(oPC, "bExpose = " + IntToString(eEffect.bExpose));
            SendMessageToPC(oPC, "bShowIcon = " + IntToString(eEffect.bShowIcon));
            SendMessageToPC(oPC, "nParam0 = " + IntToString(eEffect.nParam0));
            SendMessageToPC(oPC, "nParam1 = " + IntToString(eEffect.nParam1));
            SendMessageToPC(oPC, "nParam2 = " + IntToString(eEffect.nParam2));
            SendMessageToPC(oPC, "nParam3 = " + IntToString(eEffect.nParam3));
            SendMessageToPC(oPC, "nParam4 = " + IntToString(eEffect.nParam4));
            SendMessageToPC(oPC, "nParam5 = " + IntToString(eEffect.nParam5));
            SendMessageToPC(oPC, "fParam0 = " + FloatToString(eEffect.fParam0, 7, 2));
            SendMessageToPC(oPC, "vec0 = (" + FloatToString(eEffect.fVector0_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector0_y, 7, 2) + ", " + FloatToString(eEffect.fVector0_z, 7, 2) + ")");
            SendMessageToPC(oPC, "vec1 = (" + FloatToString(eEffect.fVector1_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector1_y, 7, 2) + ", " + FloatToString(eEffect.fVector1_z, 7, 2) + ")");

            if (NWNX_Effect_GetTrueEffectCount(oPC)-1 != i) {
                SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
            }
        }
    }

    SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void ClearEffects(object oPC) {
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        NWNX_Effect_RemoveEffectById(oPC, eEffect.sID);
    }
}

void TestStorage(object oPC) {
    // effect eEffect = EffectArcaneSpellFailure(100, SPELL_SCHOOL_EVOCATION);
    // effect eEffect = HideEffectIcon(EffectSpellFailure(100, SPELL_SCHOOL_EVOCATION)));
    effect eEffect = EffectVision(VISION_TYPE_BLIND);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oPC, 12.0);

    PrintEffects(oPC);
}

void main()
{
    if (!GetIsPC(OBJECT_SELF)) return;

    string sMsg = NWNX_Chat_GetMessage();

    if (FindSubString(sMsg, "/cmd ") == 0) {
        sMsg = StringReplace(sMsg, "/cmd ", "");

        if (sMsg == "clear") ClearEffects(OBJECT_SELF);
        else if (sMsg == "print") PrintEffects2(OBJECT_SELF);
        else if (sMsg == "store") TestStorage(OBJECT_SELF);

        NWNX_Chat_SkipMessage();
    }
}