#include "inc_general"
#include "inc_nui"
#include "inc_skin"
#include "nwnx_admin"
#include "nwnx_util"
#include "nwnx_effect"

const int NWNX_EFFECT_TYPE_AISTATEINTERNAL = 23;
const int NWNX_EFFECT_TYPE_VISION = 69;
const int NWNX_EFFECT_TYPE_ARCANESPELLFAILURE = 25;
const int NWNX_EFFECT_TYPE_SPELLFAILURE = 92;
const int NWNX_EFFECT_TYPE_RUNSCRIPT = 96;

// can't move, but can still be bumped around
const int AISTATE_NOLEGS = -3;
// can't attack or cast somatic spells
const int AISTATE_NOHANDS = -5;
// can't be heard by listeners or cast spells with verbal components
const int AISTATE_NOMOUTH = -9;
// can't listen to find opponents or see invisible creatures in melee range
const int AISTATE_NOEARS = -17;
// like SetCommandable(), but can alter action queue
const int AISTATE_NOCONTROL = -31;

// no augmented vision
const int VISION_TYPE_NORMAL = 0;
const int VISION_TYPE_LOWLIGHTVISION = 1;
const int VISION_TYPE_DARKVISION = 2;
const int VISION_TYPE_ULTRAVISION = 3;
// default vision humans get
const int VISION_TYPE_BLIND = 4;

// -----

int EffectGroupAlreadySaved(int nID, json jaAlreadySavedIds);

void SkinEffects(object oPC);
void SaveEffects(object oPC);
void LoadEffects(object oPC);
void ShowEffects(object oPC);

struct NWNX_EffectUnpacked NWNX_JsonToEffect(json joEffect);
json NWNX_EffectToJson(struct NWNX_EffectUnpacked strEffect);
struct NWNX_EffectUnpacked BlankEffect(int nType=0);

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMessage = GetStringLowerCase(GetPCChatMessage());

    if (GetStringLeft(sMessage, 1) != "/")
        return;

    sMessage = GetStringRight(sMessage, GetStringLength(sMessage)-1);

    if (sMessage == "inventory")
        NuiOpenInventory(oPC);

    if (sMessage == "storage")
        NuiOpenStorage(oPC);

    if (sMessage == "market")
        NuiOpenMarket(oPC);

    if (sMessage == "runtest") {
        RunTest(oPC);
    }

    if (sMessage == "tickrate")
        SendMessageToPC(oPC, "TPS: " + IntToString(NWNX_Util_GetServerTicksPerSecond()));

    if (sMessage == "skineffects")
        SkinEffects(oPC);
    if (sMessage == "showeffects")
        ShowEffects(oPC);
    if (sMessage == "saveeffects")
        SaveEffects(oPC);
    if (sMessage == "loadeffects")
        LoadEffects(oPC);
    if (sMessage == "giveeffects") {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectAbilityDecrease(ABILITY_STRENGTH, 2), "strdebuff"), oPC, 10.0);
        // ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectAbilityDecrease(ABILITY_DEXTERITY, 2), "dexdebuff"), oPC, 10.0);
        // ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectAbilityDecrease(ABILITY_CONSTITUTION, 2), "condebuff"), oPC, 10.0);
    }

    SetPCChatMessage();
}

void SkinEffects(object oPC) {
    SendMessageToPC(oPC, "===== SKINEFFS =====");
    SendMessageToPC(oPC, JsonDump(GetSkinJson(oPC, PL_EFFECTS), 4));
}

int EffectGroupAlreadySaved(int nID, json jaAlreadySavedIds) {
    for (k = 0; k < JsonGetLength(jaAlreadySavedIds); k++) {
        if (nID == JsonGetInt(JsonArrayGet(jaAlreadySavedIds, k)))
            return TRUE;
    }

    return FALSE;
}

int ShouldSaveEffectTag(string sTag, json jaTaggedEffects, object oPC) {
    json jaEffect = JsonArray();
    jaEffect = JsonArrayInsert(jaEffect, JsonString(sTag));
    return (JsonSetOp(jaTaggedEffects, JSON_SET_SUBSET, jaEffect) == JsonBool(TRUE));
}

int HasSavedEffectGroupAlready(int nId, json jaSavedEffectGroups, object oPC) {
    json jaEffect = JsonArray();
    jaEffect = JsonArrayInsert(jaEffect, JsonInt(nId));
    return (JsonSetOp(jaSavedEffectGroups, JSON_SET_SUBSET, jaEffect) == JsonBool(TRUE));
}

// only tag the unhardcoded-added effects themselves and not the effects that are hardcoded added-when-applied
//   otherwise we'll get multiplos of EffectIcon() etc added, or other similar duplicates when applying the base effect(s) later
void SaveEffects(object oPC) {
    // tags of effects that we should be saving
    json jaTaggedEffects = JsonArray();
    jaTaggedEffects = JsonArrayInsert(jaTaggedEffects, JsonString("strdebuff"));
    jaTaggedEffects = JsonArrayInsert(jaTaggedEffects, JsonString("dexdebuff"));
    jaTaggedEffects = JsonArrayInsert(jaTaggedEffects, JsonString("condebuff"));

    // list of effect id's representing the group of effects we've already saved thus far
    json jaSavedEffectGroups = JsonArray();

    // list of all effect groups saved
    json jaEffects = JsonArray();

    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked strEffect = NWNX_Effect_GetTrueEffect(oPC, i);

        // make sure we should be saving effect, otherwise skip it
        if (!ShouldSaveEffectTag(strEffect.sTag, jaTaggedEffects, oPC) || HasSavedEffectGroupAlready(StringToInt(strEffect.sID), jaSavedEffectGroups, oPC))
            continue;

        // effect is new; store all effects into a group
        json jaEffectGroup = JsonArray();
        for (j = 0; j < NWNX_Effect_GetTrueEffectCount(oPC); j++) {
            struct NWNX_EffectUnpacked strEffect2 = NWNX_Effect_GetTrueEffect(oPC, j);

            // only save tagged effects; we should only be tagging effects that aren't hardcoded applied, then the non-tagged effects are auto-applied when we apply the base effect during LoadEffects()
            if (strEffect2.sID == strEffect.sID && strEffect2.sTag == strEffect.sTag)
                jaEffectGroup = JsonArrayInsert(jaEffectGroup, NWNX_EffectToJson(strEffect2));

                SendMessageToPC(oPC, JsonDump(NWNX_EffectToJson(strEffect2), 4));
        }

        // save the effect group into jaEffects
        jaSavedEffectGroups = JsonArrayInsert(jaSavedEffectGroups, JsonInt(StringToInt(strEffect.sID)));
        jaEffects = JsonArrayInsert(jaEffects, jaEffectGroup);
    }

    SendMessageToPC(oPC, "===== SAVED =====");
    SendMessageToPC(oPC, JsonDump(jaEffects, 4));

    SetSkinJson(oPC, PL_EFFECTS, jaEffects);
}

void LoadEffects(object oPC) {
    // struct NWNX_EffectUnpacked strEffect = BlankEffect(67);
    // strEffect.nSubType = 9;
    // strEffect.nParam0 = 60;
    // strEffect.nParam1 = 2;
    // strEffect.fDuration = 3.0;
    // // int nCurrentCalendarDay = (GetCalendarYear() * 12 * 28) + ((GetCalendarMonth()-1) * 28) + (GetCalendarDay()-1);
    // // int nCurrentTimeOfDay = (GetTimeHour() * FloatToInt(HoursToSeconds(1)) * 1000) + (GetTimeMinute() * 60 * 1000) + (GetTimeSecond() * 1000) + GetTimeMillisecond();
    // // strEffect.nExpiryCalendarDay = nCurrentCalendarDay;
    // // strEffect.nExpiryTimeOfDay + FloatToInt(strEffect.fDuration)*1000;
    // NWNX_Effect_Apply(NWNX_Effect_PackEffect(strEffect), oPC);

    json jaEffects = GetSkinJson(oPC, PL_EFFECTS);

    SendMessageToPC(oPC, "===== GIVEN =====");
    SendMessageToPC(oPC, "===== GIVEN =====");
    SendMessageToPC(oPC, JsonDump(jaEffects, 4));

    for (i = 0; i < JsonGetLength(jaEffects); i++) {
        json jaEffectGroup = JsonArrayGet(jaEffects, i);

        effect eGroup;
        float fDuration;

        for (j = 0; j < JsonGetLength(jaEffectGroup); j++) {
            struct NWNX_EffectUnpacked strEffect = NWNX_JsonToEffect(JsonArrayGet(jaEffectGroup, j));
            eGroup = EffectLinkEffects(NWNX_Effect_PackEffect(strEffect), eGroup);
            fDuration = strEffect.fDuration;
        }

        ApplyEffectToObject((FloatToInt(fDuration) ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT), eGroup, oPC, fDuration);
    }
}

// todo: add/remove more parameters as necessary to apply the effect properly
struct NWNX_EffectUnpacked NWNX_JsonToEffect(json joEffect) {
    struct NWNX_EffectUnpacked strEffect = BlankEffect();
    strEffect.nType = JsonGetInt(JsonObjectGet(joEffect, "nType"));
    strEffect.nSubType = JsonGetInt(JsonObjectGet(joEffect, "nSubType"));
    strEffect.fDuration = JsonGetFloat(JsonObjectGet(joEffect, "fDuration"));
    strEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
    strEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
    strEffect.nParam2 = JsonGetInt(JsonObjectGet(joEffect, "nParam2"));
    strEffect.nParam3 = JsonGetInt(JsonObjectGet(joEffect, "nParam3"));
    strEffect.nParam4 = JsonGetInt(JsonObjectGet(joEffect, "nParam4"));
    strEffect.sTag = JsonGetString(JsonObjectGet(joEffect, "sTag"));
    return strEffect;
}

// todo: add/remove more parameters as necessary to reconstruct the effect properly
json NWNX_EffectToJson(struct NWNX_EffectUnpacked strEffect) {
    json joEffect = JsonObject();
    joEffect = JsonObjectSet(joEffect, "nType", JsonInt(strEffect.nType));
    joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(strEffect.nSubType));
    joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(strEffect.fDuration));
    joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
    joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(strEffect.nParam1));
    joEffect = JsonObjectSet(joEffect, "nParam2", JsonInt(strEffect.nParam2));
    joEffect = JsonObjectSet(joEffect, "nParam3", JsonInt(strEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "nParam4", JsonInt(strEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "sTag", JsonString(strEffect.sTag));

    // override fDuration if it's a temporary effect; shouldn't need to check strEffect.nSubType because only temporary effects' duration will be non-0 and relevant
    if (strEffect.fDuration > 0.0) {
        // calculate fDuration by substracting current time from strEffect.nExpiryCalendarDay & strEffect.nExpiryTimeOfDay
        int nCurrentCalendarDay = (GetCalendarYear() * 12 * 28) + ((GetCalendarMonth()-1) * 28) + (GetCalendarDay()-1);
        int nCurrentTimeOfDay = (GetTimeHour() * FloatToInt(HoursToSeconds(1)) * 1000) + (GetTimeMinute() * 60 * 1000) + (GetTimeSecond() * 1000) + GetTimeMillisecond();
        int nCalendarDayRemaining = strEffect.nExpiryCalendarDay - nCurrentCalendarDay;
        int nTimeOfDayRemaining = strEffect.nExpiryTimeOfDay - nCurrentTimeOfDay;

        // convert calendar & time remaining variables time into seconds
        int nDuration = (nCalendarDayRemaining * FloatToInt(HoursToSeconds(1))) + (nTimeOfDayRemaining / 1000) + 1;

        joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(IntToFloat(nDuration)));
    }

    return joEffect;
}

struct NWNX_EffectUnpacked BlankEffect(int nType=0) {
    struct NWNX_EffectUnpacked strEffect;
    strEffect.nType = nType;
    // nSubType 4 is reserved for internal engine effects like racial vision
    strEffect.nSubType = 4;
    // used to generate nExpiryCalendarDay & nExpiryTimeOfDay upon effect application, then serves only as historical record
    strEffect.fDuration = 0.0;
    // days passed since the first year (1372): Current = (GetCalendarYear() * 12 months * 28 days) + ((GetCalendarMonth()-1) * 28) + (GetCalendarDay()-1)
    strEffect.nExpiryCalendarDay = 0;
    // milliseconds passed since day start: Current = (GetTimeHour() * FloatToInt(HoursToSeconds(1)) * 1000 milliseconds) + (GetTimeMinute() * 60 minutes * 1000 milliseconds) + (GetTimeSecond() * 1000 milliseconds) + GetTimeMillisecond()
    strEffect.nExpiryTimeOfDay = 0;
    strEffect.oCreator = OBJECT_INVALID;
    // spells with identical nSpellId don't normally stack; NWNX_NOSTACK_SEPARATE_INVALID_OID_EFFECTS allows them to
    strEffect.nSpellId = -1;
    // gives base nwscript access to the effect when looping effects
    strEffect.bExpose = 1;
    strEffect.bShowIcon = 1;
    strEffect.nCasterLevel = -1;
    // all 4 link params below are only valid before the effect is applied, then they become invalid
    strEffect.eLinkLeft = eNull;
    strEffect.bLinkLeftValid = 0;
    strEffect.eLinkRight = eNull;
    strEffect.bLinkRightValid = 0;
    strEffect.nNumIntegers = 8;
    strEffect.nParam0 = 0;
    strEffect.nParam1 = 0;
    strEffect.nParam2 = 0;
    strEffect.nParam3 = 0;
    strEffect.nParam4 = 0;
    strEffect.nParam5 = 0;
    strEffect.nParam6 = 0;
    strEffect.nParam7 = 0;
    strEffect.fParam0 = 0.0;
    strEffect.fParam1 = 0.0;
    strEffect.fParam2 = 0.0;
    strEffect.fParam3 = 0.0;
    strEffect.sParam0 = "";
    strEffect.sParam1 = "";
    strEffect.sParam2 = "";
    strEffect.sParam3 = "";
    strEffect.sParam4 = "";
    strEffect.sParam5 = "";
    strEffect.oParam0 = OBJECT_INVALID;
    strEffect.oParam1 = OBJECT_INVALID;
    strEffect.oParam2 = OBJECT_INVALID;
    strEffect.oParam3 = OBJECT_INVALID;
    strEffect.fVector0_x = 0.0;
    strEffect.fVector0_y = 0.0;
    strEffect.fVector0_z = 0.0;
    strEffect.fVector1_x = 0.0;
    strEffect.fVector1_y = 0.0;
    strEffect.fVector1_z = 0.0;
    strEffect.sTag = "";
    strEffect.sItemProp = "0";
    return strEffect;
}

void ShowEffects(object oPC) {
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked strEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        if (strEffect.nType == 68 || strEffect.nType == 67)
            continue;
        SendMessageToPC(oPC, "===============");
        SendMessageToPC(oPC, "nType: " + IntToString(strEffect.nType));
        SendMessageToPC(oPC, "nSubType: " + IntToString(strEffect.nSubType));
        SendMessageToPC(oPC, "fDuration: " + FloatToString(strEffect.fDuration));
        SendMessageToPC(oPC, "oCreator: " + ObjectToString(strEffect.oCreator));
        SendMessageToPC(oPC, "nSpellId: " + IntToString(strEffect.nSpellId));
        SendMessageToPC(oPC, "nCasterLevel: " + IntToString(strEffect.nCasterLevel));
        SendMessageToPC(oPC, "nParam0: " + IntToString(strEffect.nParam0));
        SendMessageToPC(oPC, "nParam1: " + IntToString(strEffect.nParam1));
        SendMessageToPC(oPC, "nParam2: " + IntToString(strEffect.nParam2));
        SendMessageToPC(oPC, "nParam3: " + IntToString(strEffect.nParam3));
        SendMessageToPC(oPC, "sItemProp: " + strEffect.sItemProp);
        SendMessageToPC(oPC, "===============");
    }
}