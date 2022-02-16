#include "nwnx_effect"

int i = 0;

const string PLAYER_LOCATION  = "location";
const string PLAYER_HITPOINTS = "hitpoints";
const string PLAYER_EFFECTS   = "effects";
const string PLAYER_CONNECTED = "connected";

void PrintEffects(object oPC) {
    SendMessageToPC(oPC, "XXXXX PRINT_EFFECTS XXXXX");

    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);

        if (eEffect.nType != 68) {
            SendMessageToPC(oPC, "sID: " + eEffect.sID);
            SendMessageToPC(oPC, "nType: " + IntToString(eEffect.nType));
            SendMessageToPC(oPC, "nSubType: " + IntToString(eEffect.nSubType));

            SendMessageToPC(oPC, "fDuration: " + FloatToString(eEffect.fDuration, 4, 1));
            SendMessageToPC(oPC, "nExpiryCalendarDay: " + IntToString(eEffect.nExpiryCalendarDay));
            SendMessageToPC(oPC, "nExpiryTimeOfDay: " + IntToString(eEffect.nExpiryTimeOfDay));

            SendMessageToPC(oPC, "oCreator: " + ObjectToString(eEffect.oCreator));
            SendMessageToPC(oPC, "nSpellId: " + IntToString(eEffect.nSpellId));
            SendMessageToPC(oPC, "bExpose: " + IntToString(eEffect.bExpose));
            SendMessageToPC(oPC, "bShowIcon: " + IntToString(eEffect.bShowIcon));
            SendMessageToPC(oPC, "nCasterLevel: " + IntToString(eEffect.nCasterLevel));

            SendMessageToPC(oPC, "nNumIntegers: " + IntToString(eEffect.nNumIntegers));
            SendMessageToPC(oPC, "nParam0: " + IntToString(eEffect.nParam0));
            SendMessageToPC(oPC, "nParam1: " + IntToString(eEffect.nParam1));
            SendMessageToPC(oPC, "nParam2: " + IntToString(eEffect.nParam2));
            SendMessageToPC(oPC, "nParam3: " + IntToString(eEffect.nParam3));
            SendMessageToPC(oPC, "nParam4: " + IntToString(eEffect.nParam4));
            SendMessageToPC(oPC, "nParam5: " + IntToString(eEffect.nParam5));
            SendMessageToPC(oPC, "nParam6: " + IntToString(eEffect.nParam6));
            SendMessageToPC(oPC, "nParam7: " + IntToString(eEffect.nParam7));
            SendMessageToPC(oPC, "fParam0: " + FloatToString(eEffect.fParam0, 7, 2));
            SendMessageToPC(oPC, "fParam1: " + FloatToString(eEffect.fParam1, 7, 2));
            SendMessageToPC(oPC, "fParam2: " + FloatToString(eEffect.fParam2, 7, 2));
            SendMessageToPC(oPC, "fParam3: " + FloatToString(eEffect.fParam3, 7, 2));
            SendMessageToPC(oPC, "sParam0: " + eEffect.sParam0);
            SendMessageToPC(oPC, "sParam1: " + eEffect.sParam1);
            SendMessageToPC(oPC, "sParam2: " + eEffect.sParam2);
            SendMessageToPC(oPC, "sParam3: " + eEffect.sParam3);
            SendMessageToPC(oPC, "sParam4: " + eEffect.sParam4);
            SendMessageToPC(oPC, "oParam0: " + ObjectToString(eEffect.oParam0));
            SendMessageToPC(oPC, "oParam1: " + ObjectToString(eEffect.oParam1));
            SendMessageToPC(oPC, "oParam2: " + ObjectToString(eEffect.oParam2));
            SendMessageToPC(oPC, "oParam3: " + ObjectToString(eEffect.oParam3));
            SendMessageToPC(oPC, "vec0: (" + FloatToString(eEffect.fVector0_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector0_y, 7, 2) + ", " + FloatToString(eEffect.fVector0_z, 7, 2) + ")");
            SendMessageToPC(oPC, "vec1: (" + FloatToString(eEffect.fVector1_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector1_y, 7, 2) + ", " + FloatToString(eEffect.fVector1_z, 7, 2) + ")");

            if (NWNX_Effect_GetTrueEffectCount(oPC)-1 != i) {
                SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
            }
        }
    }

    SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
}

string SetPlayerJson(object oPC, string sCol, json jVal)
{
    sqlquery sqlUpdate = SqlPrepareQueryCampaign("conopp", "INSERT INTO persistence" +
        "(uuid, " + sCol + ") VALUES (@uuid, @jVal)" +
        "ON CONFLICT DO UPDATE SET " + sCol + " = @jVal");
    SqlBindString(sqlUpdate, "@uuid", GetObjectUUID(oPC));
    SqlBindJson(sqlUpdate, "@jVal", jVal);
    SqlStep(sqlUpdate);

    return SqlGetError(sqlUpdate);
}

json GetPlayerJson(object oPC, string sCol)
{
    sqlquery sqlSelect = SqlPrepareQueryCampaign("conopp", "SELECT uuid, " + sCol + " FROM persistence");
    SqlStep(sqlSelect);

    if (SqlGetError(sqlSelect) != "") {
        return JsonNull();
    }

    return SqlGetJson(sqlSelect, 1);
}

json JsonEffect(struct NWNX_EffectUnpacked eEffect)
{
    json joEffect = JsonObject();
    joEffect = JsonObjectSet(joEffect, "sID", JsonString(eEffect.sID));
    joEffect = JsonObjectSet(joEffect, "nType", JsonInt(eEffect.nType));
    joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(eEffect.nSubType));

    joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(eEffect.fDuration));
    joEffect = JsonObjectSet(joEffect, "nExpiryCalendarDay", JsonInt(eEffect.nExpiryCalendarDay));
    joEffect = JsonObjectSet(joEffect, "nExpiryTimeOfDay", JsonInt(eEffect.nExpiryTimeOfDay));

    joEffect = JsonObjectSet(joEffect, "oCreator", JsonString(ObjectToString(eEffect.oCreator)));
    joEffect = JsonObjectSet(joEffect, "nSpellId", JsonInt(eEffect.nSpellId));
    joEffect = JsonObjectSet(joEffect, "bExpose", JsonInt(eEffect.bExpose));
    joEffect = JsonObjectSet(joEffect, "bShowIcon", JsonInt(eEffect.bShowIcon));
    joEffect = JsonObjectSet(joEffect, "nCasterLevel", JsonInt(eEffect.nCasterLevel));

    if (eEffect.bLinkLeftValid) joEffect = JsonObjectSet(joEffect, "eLinkLeft", JsonEffect(NWNX_Effect_UnpackEffect(eEffect.eLinkLeft)));
    else joEffect = JsonObjectSet(joEffect, "eLinkLeft", JsonNull());
    joEffect = JsonObjectSet(joEffect, "bLinkLeftValid", JsonInt(eEffect.bLinkLeftValid));

    if (eEffect.bLinkLeftValid) joEffect = JsonObjectSet(joEffect, "eLinkRight", JsonEffect(NWNX_Effect_UnpackEffect(eEffect.eLinkRight)));
    else joEffect = JsonObjectSet(joEffect, "eLinkRight", JsonNull());
    joEffect = JsonObjectSet(joEffect, "bLinkRightValid", JsonInt(eEffect.bLinkRightValid));

    joEffect = JsonObjectSet(joEffect, "nNumIntegers", JsonInt(eEffect.nNumIntegers));
    joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
    joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(eEffect.nParam1));
    joEffect = JsonObjectSet(joEffect, "nParam2", JsonInt(eEffect.nParam2));
    joEffect = JsonObjectSet(joEffect, "nParam3", JsonInt(eEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "nParam4", JsonInt(eEffect.nParam4));
    joEffect = JsonObjectSet(joEffect, "nParam5", JsonInt(eEffect.nParam5));
    joEffect = JsonObjectSet(joEffect, "nParam6", JsonInt(eEffect.nParam6));
    joEffect = JsonObjectSet(joEffect, "nParam7", JsonInt(eEffect.nParam7));
    joEffect = JsonObjectSet(joEffect, "fParam0", JsonFloat(eEffect.fParam0));
    joEffect = JsonObjectSet(joEffect, "fParam1", JsonFloat(eEffect.fParam1));
    joEffect = JsonObjectSet(joEffect, "fParam2", JsonFloat(eEffect.fParam2));
    joEffect = JsonObjectSet(joEffect, "fParam3", JsonFloat(eEffect.fParam3));
    joEffect = JsonObjectSet(joEffect, "sParam0", JsonString(eEffect.sParam0));
    joEffect = JsonObjectSet(joEffect, "sParam1", JsonString(eEffect.sParam1));
    joEffect = JsonObjectSet(joEffect, "sParam2", JsonString(eEffect.sParam2));
    joEffect = JsonObjectSet(joEffect, "sParam3", JsonString(eEffect.sParam3));
    joEffect = JsonObjectSet(joEffect, "sParam4", JsonString(eEffect.sParam4));
    joEffect = JsonObjectSet(joEffect, "sParam5", JsonString(eEffect.sParam5));
    joEffect = JsonObjectSet(joEffect, "oParam0", JsonString(ObjectToString(eEffect.oParam0)));
    joEffect = JsonObjectSet(joEffect, "oParam1", JsonString(ObjectToString(eEffect.oParam1)));
    joEffect = JsonObjectSet(joEffect, "oParam2", JsonString(ObjectToString(eEffect.oParam2)));
    joEffect = JsonObjectSet(joEffect, "oParam3", JsonString(ObjectToString(eEffect.oParam3)));
    joEffect = JsonObjectSet(joEffect, "fVector0_x", JsonFloat(eEffect.fVector0_x));
    joEffect = JsonObjectSet(joEffect, "fVector0_y", JsonFloat(eEffect.fVector0_y));
    joEffect = JsonObjectSet(joEffect, "fVector0_z", JsonFloat(eEffect.fVector0_z));
    joEffect = JsonObjectSet(joEffect, "fVector1_x", JsonFloat(eEffect.fVector1_x));
    joEffect = JsonObjectSet(joEffect, "fVector1_y", JsonFloat(eEffect.fVector1_y));
    joEffect = JsonObjectSet(joEffect, "fVector1_z", JsonFloat(eEffect.fVector1_z));

    joEffect = JsonObjectSet(joEffect, "sTag", JsonString(eEffect.sTag));

    joEffect = JsonObjectSet(joEffect, "sItemProp", JsonString(eEffect.sItemProp));

    return joEffect;
}

struct NWNX_EffectUnpacked JsonGetEffect(json joEffect)
{
    struct NWNX_EffectUnpacked eEffect;
    eEffect.sID = JsonGetString(JsonObjectGet(joEffect, "sID"));
    eEffect.nType = JsonGetInt(JsonObjectGet(joEffect, "nType"));
    eEffect.nSubType = JsonGetInt(JsonObjectGet(joEffect, "nSubType"));

    eEffect.fDuration = JsonGetFloat(JsonObjectGet(joEffect, "fDuration"));
    eEffect.nExpiryCalendarDay = JsonGetInt(JsonObjectGet(joEffect, "nExpiryCalendarDay"));
    eEffect.nExpiryTimeOfDay = JsonGetInt(JsonObjectGet(joEffect, "nExpiryTimeOfDay"));

    eEffect.oCreator = StringToObject(JsonGetString(JsonObjectGet(joEffect, "oCreator")));
    eEffect.nSpellId = JsonGetInt(JsonObjectGet(joEffect, "nSpellId"));
    eEffect.bExpose = JsonGetInt(JsonObjectGet(joEffect, "bExpose"));
    eEffect.bShowIcon = JsonGetInt(JsonObjectGet(joEffect, "bShowIcon"));
    eEffect.nCasterLevel = JsonGetInt(JsonObjectGet(joEffect, "nCasterLevel"));

    int bLinkLeftValid = JsonGetInt(JsonObjectGet(joEffect, "bLinkLeftValid"));
    if (bLinkLeftValid) eEffect.eLinkLeft = NWNX_Effect_PackEffect(JsonGetEffect(JsonObjectGet(joEffect, "eLinkLeft")));
    eEffect.bLinkLeftValid = bLinkLeftValid;

    int bLinkRightValid = JsonGetInt(JsonObjectGet(joEffect, "bLinkRightValid"));
    if (bLinkRightValid) eEffect.eLinkRight = NWNX_Effect_PackEffect(JsonGetEffect(JsonObjectGet(joEffect, "eLinkRight")));
    eEffect.bLinkRightValid = bLinkRightValid;

    eEffect.nNumIntegers = JsonGetInt(JsonObjectGet(joEffect, "nNumIntegers"));
    eEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
    eEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
    eEffect.nParam2 = JsonGetInt(JsonObjectGet(joEffect, "nParam2"));
    eEffect.nParam3 = JsonGetInt(JsonObjectGet(joEffect, "nParam3"));
    eEffect.nParam4 = JsonGetInt(JsonObjectGet(joEffect, "nParam4"));
    eEffect.nParam5 = JsonGetInt(JsonObjectGet(joEffect, "nParam5"));
    eEffect.nParam6 = JsonGetInt(JsonObjectGet(joEffect, "nParam6"));
    eEffect.nParam7 = JsonGetInt(JsonObjectGet(joEffect, "nParam7"));
    eEffect.fParam0 = JsonGetFloat(JsonObjectGet(joEffect, "fParam0"));
    eEffect.fParam1 = JsonGetFloat(JsonObjectGet(joEffect, "fParam1"));
    eEffect.fParam2 = JsonGetFloat(JsonObjectGet(joEffect, "fParam2"));
    eEffect.fParam3 = JsonGetFloat(JsonObjectGet(joEffect, "fParam3"));
    eEffect.sParam0 = JsonGetString(JsonObjectGet(joEffect, "sParam0"));
    eEffect.sParam1 = JsonGetString(JsonObjectGet(joEffect, "sParam1"));
    eEffect.sParam2 = JsonGetString(JsonObjectGet(joEffect, "sParam2"));
    eEffect.sParam3 = JsonGetString(JsonObjectGet(joEffect, "sParam3"));
    eEffect.sParam4 = JsonGetString(JsonObjectGet(joEffect, "sParam4"));
    eEffect.sParam5 = JsonGetString(JsonObjectGet(joEffect, "sParam5"));
    eEffect.oParam0 = StringToObject(JsonGetString(JsonObjectGet(joEffect, "oParam0")));
    eEffect.oParam1 = StringToObject(JsonGetString(JsonObjectGet(joEffect, "oParam1")));
    eEffect.oParam2 = StringToObject(JsonGetString(JsonObjectGet(joEffect, "oParam2")));
    eEffect.oParam3 = StringToObject(JsonGetString(JsonObjectGet(joEffect, "oParam3")));
    eEffect.fVector0_x = JsonGetFloat(JsonObjectGet(joEffect, "fVector0_x"));
    eEffect.fVector0_y = JsonGetFloat(JsonObjectGet(joEffect, "fVector0_y"));
    eEffect.fVector0_z = JsonGetFloat(JsonObjectGet(joEffect, "fVector0_z"));
    eEffect.fVector1_x = JsonGetFloat(JsonObjectGet(joEffect, "fVector1_x"));
    eEffect.fVector1_y = JsonGetFloat(JsonObjectGet(joEffect, "fVector1_y"));
    eEffect.fVector1_z = JsonGetFloat(JsonObjectGet(joEffect, "fVector1_z"));

    eEffect.sTag = JsonGetString(JsonObjectGet(joEffect, "sTag"));

    eEffect.sItemProp = JsonGetString(JsonObjectGet(joEffect, "sItemProp"));

    return eEffect;
}

json GetCurrentEffects(object oObject)
{
    json jaEffects = JsonArray();
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oObject); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oObject, i);
        jaEffects = JsonArrayInsert(jaEffects, JsonEffect(eEffect));
    }

    return jaEffects;
}

void ApplyStoredEffects(object oObject, json jaEffects)
{
    for (i = 0; i < JsonGetLength(jaEffects); i++) {
        json joEffect = JsonArrayGet(jaEffects, 0);
        NWNX_Effect_Apply(NWNX_Effect_PackEffect(JsonGetEffect(joEffect)), oObject);
        jaEffects = JsonArrayDel(jaEffects, 0);
    }

    SendMessageToPC(oObject, "-------------------------");
    SendMessageToPC(oObject, "------- SQL_APPLY -------");
    SendMessageToPC(oObject, "-------------------------");
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oObject); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oObject, i);

        if (eEffect.nType != 68) {
            SendMessageToPC(oObject, "sID: " + eEffect.sID);
            SendMessageToPC(oObject, "nType: " + IntToString(eEffect.nType));
            SendMessageToPC(oObject, "nSubType: " + IntToString(eEffect.nSubType));
            SendMessageToPC(oObject, "fDuration: " + FloatToString(eEffect.fDuration, 4, 1));
            SendMessageToPC(oObject, "bExpose: " + IntToString(eEffect.bExpose));
            SendMessageToPC(oObject, "bShowIcon: " + IntToString(eEffect.bShowIcon));
            SendMessageToPC(oObject, "nParam0: " + IntToString(eEffect.nParam0));
            SendMessageToPC(oObject, "nParam1: " + IntToString(eEffect.nParam1));
            SendMessageToPC(oObject, "nParam2: " + IntToString(eEffect.nParam2));
            SendMessageToPC(oObject, "nParam3: " + IntToString(eEffect.nParam3));
            SendMessageToPC(oObject, "nParam4: " + IntToString(eEffect.nParam4));
            SendMessageToPC(oObject, "nParam5: " + IntToString(eEffect.nParam5));
            SendMessageToPC(oObject, "fParam0: " + FloatToString(eEffect.fParam0, 7, 2));
            SendMessageToPC(oObject, "vec0: (" + FloatToString(eEffect.fVector0_x, 7, 2) + ", " + FloatToString(eEffect.fVector0_y, 7, 2) + ", " + FloatToString(eEffect.fVector0_z, 7, 2) + ")");
            SendMessageToPC(oObject, "vec1: (" + FloatToString(eEffect.fVector1_x, 7, 2) + ", " + FloatToString(eEffect.fVector1_y, 7, 2) + ", " + FloatToString(eEffect.fVector1_z, 7, 2) + ")");

            if (NWNX_Effect_GetTrueEffectCount(oObject)-1 != i) {
                SendMessageToPC(oObject, "-------------------------");
            }
        }
    }
    SendMessageToPC(oObject, "-------------------------");
    SendMessageToPC(oObject, "-------------------------");
    SendMessageToPC(oObject, "-------------------------");
}

void SaveEffects(object oPC) {
    SetPlayerJson(oPC, PLAYER_EFFECTS, GetCurrentEffects(oPC));

    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        NWNX_Effect_RemoveEffectById(oPC, eEffect.sID);
    }
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        NWNX_Effect_RemoveEffectById(oPC, eEffect.sID);
    }
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        NWNX_Effect_RemoveEffectById(oPC, eEffect.sID);
    }
}

void main()
{
    object oPC = GetLastUsedBy();

    // player uses object
    //   1. run a switch on GetTag(OBJECT_SELF) to determine which effect to apply
    //   2. PrintString() all effects on the player to deduce which effects were added
    //   3. wait 1s and remove the effect & add it to database for the player
    //   4. wait 1s and reapply the effect gotten from the database to PrintString() all
    //      player effects again, adding a separator at the end so it's easy to
    //      distinguish between other effects testing following the current one (make note
    //      if in any cases effects aren't able to be re-applied to the player properly)

    // clear any existing effects on player so they don't conflict with next effect
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        NWNX_Effect_RemoveEffectById(oPC, eEffect.sID);
    }

    switch (StringToInt(GetTag(OBJECT_SELF))) {
        case 1: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectHaste(), oPC, 10.); break;
        case 3: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSlow(), oPC, 10.); break;
        case 28: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedIncrease(99), oPC, 10.); break;
        case 29: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMovementSpeedDecrease(99), oPC, 10.); break;
        case 15: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(100), oPC, 10.); break;
        case 7: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectRegenerate(1, 0.5), oPC, 10.); break;
        case 45: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectCurse(), oPC, 10.); break;
        case 82: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNegativeLevel(1), oPC, 10.); break;
        case 21: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDeaf(), oPC, 10.); break;
        case 46: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSilence(), oPC, 10.); break;
        case 73: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectBlindness(), oPC, 10.); break;
        case 63: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEthereal(), oPC, 10.); break;
        case 75: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectMissChance(95), oPC, 10.); break;
        case 70: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSeeInvisible(), oPC, 10.); break;
        case 47: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectInvisibility(INVISIBILITY_TYPE_NORMAL), oPC, 10.); break;
        case 71: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectUltravision(), oPC, 10.); break;
        case 72: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTrueSeeing(), oPC, 10.); break;
        case 76: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectConcealment(95), oPC, 10.); break;
        case 92: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellFailure(95, SPELL_SCHOOL_EVOCATION), oPC, 10.); break;
        case 65: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellLevelAbsorption(5, 15, SPELL_SCHOOL_EVOCATION), oPC, 10.); break;
        case 50: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellImmunity(SPELL_STONESKIN), oPC, 10.); break;
        case 33: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellResistanceIncrease(55), oPC, 10.); break;
        case 34: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSpellResistanceDecrease(55), oPC, 10.); break;
        case 77: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTurnResistanceIncrease(55), oPC, 10.); break;
        case 88: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTurnResistanceDecrease(55), oPC, 10.); break;
        case 44: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectModifyAttacks(2), oPC, 10.); break;
        case 10: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackIncrease(20), oPC, 10.); break;
        case 11: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAttackDecrease(20), oPC, 10.); break;
        case 13: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageIncrease(5, DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING), oPC, 10.); break;
        case 14: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageDecrease(5, DAMAGE_TYPE_BLUDGEONING | DAMAGE_TYPE_PIERCING | DAMAGE_TYPE_SLASHING), oPC, 10.); break;
        case 16: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD, 50), oPC, 10.); break;
        case 17: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageImmunityDecrease(DAMAGE_TYPE_SLASHING, 50), oPC, 10.); break;
        case 2: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageResistance(DAMAGE_TYPE_SLASHING, 5, 55), oPC, 10.); break;
        case 12: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageReduction(5, DAMAGE_POWER_PLUS_FIVE, 55) , oPC, 10.); break;
        case 22: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectImmunity(IMMUNITY_TYPE_FEAR), oPC, 10.); break;
        case 36: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityIncrease(0, 20), oPC, 10.); break;
        case 37: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAbilityDecrease(0, 20), oPC, 10.); break;
        case 48: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACIncrease(20), oPC, 10.); break;
        case 49: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectACDecrease(20), oPC, 10.); break;
        case 55: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillIncrease(SKILL_DISCIPLINE, 50), oPC, 10.); break;
        case 56: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSkillDecrease(SKILL_DISCIPLINE, 50), oPC, 10.); break;
        case 26: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_WILL, 20), oPC, 10.); break;
        case 27: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowDecrease(SAVING_THROW_WILL, 20), oPC, 10.); break;
        case 18: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectEntangle(), oPC, 10.); break;
        case 20: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectKnockdown(), oPC, 10.); break;
        case 62: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPolymorph(5, TRUE), oPC, 10.); break;
        case 90: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectPetrify(), oPC, 10.); break;
        case 30: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(400, FALSE, 3.0, Vector(1., 0., 2.), Vector(1., 0., 2.)), oPC, 10.); break;
        case 31: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectAreaOfEffect(AOE_MOB_FIRE), oPC, 10.); break;
        case 61: ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectDamageShield(5, DAMAGE_BONUS_2d6, DAMAGE_TYPE_FIRE), oPC, 10.); break;
    }

    // effects printout
    DelayCommand(3.0, PrintEffects(oPC));

    // we tremporarily added logging to ApplyStoredEffects() to print results
    //   and removed the ApplyStoredEffects() call from player_ready.nss
    // DelayCommand(1.0, SaveEffects(oPC)); // save & clear effects from player
    // DelayCommand(3.0, ApplyStoredEffects(oPC, GetPlayerJson(oPC, PLAYER_EFFECTS)));
}