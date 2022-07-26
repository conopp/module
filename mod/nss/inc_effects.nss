// ************************
// *       Includes       *
// ************************

#include "inc_general"
#include "nwnx_effect"

// ************************
// *      Variables       *
// ************************

const int DEBUG_EFFECTS = TRUE;

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

// ************************
// *      Prototypes      *
// ************************

void SetEffects(object oObj, json jaEffects);
json GetEffects(object oObj);
json JsonEffect(effect eEffect);
effect JsonGetEffect(json joEffect);
struct NWNX_EffectUnpacked BlankEffect(int nType=0);

effect GetTaggedEffect(object oObj, string sTag);
int DelTagEffect(object oObj, string sTag);

// *************************
// *       Functions       *
// *************************

void SetEffects(object oObj, json jaEffects) {
    for (i = 0; i < JsonGetLength(jaEffects); i++) {
        json jaEffectGroup = JsonArrayGet(jaEffects, i);

        // duration gets set to 0 if we combine a valid effect with an invalid one, such as eGroup, so we need to get duration before linking the two effects
        effect eGroup;
        int nDuration;
        for (j = 0; j < JsonGetLength(jaEffectGroup); j++) {
            effect eEffect = JsonGetEffect(JsonArrayGet(jaEffectGroup, j));
            nDuration = GetEffectDuration(eEffect);

            eGroup = EffectLinkEffects(eEffect, eGroup);
        }

        ApplyEffectToObject((nDuration ? DURATION_TYPE_TEMPORARY : DURATION_TYPE_PERMANENT), eGroup, oObj, IntToFloat(nDuration));
    }
}

// only saves tagged effects; we should only be tagging effects that aren't hardcoded applied, then the non-tagged effects are auto-applied when we apply the base effect during SetEffects()
json GetEffects(object oObj) {
    return JsonNull();
    // // tags of effects that we should be saving
    // json jaTaggedEffects = JsonArray();
    // jaTaggedEffects = JsonArrayInsert(jaTaggedEffects, JsonString("barbarian_rage"));
    // jaTaggedEffects = JsonArrayInsert(jaTaggedEffects, JsonString("strdebuff"));

    // json jaSavedEffectGroups = JsonArray();
    // json jaEffects = JsonArray();

    // for (i = 0; i <= NWNX_Effect_GetTrueEffectCount(oObj); i++) {
    //     struct NWNX_EffectUnpacked strEffect = NWNX_Effect_GetTrueEffect(oObj, i);

    //     // check if effect has a tag we should be saving
    //     int bHasImportantTag;
    //     for (j = 0; j < JsonGetLength(jaTaggedEffects); j++) {
    //         if (strEffect.sTag == JsonGetString(JsonArrayGet(jaTaggedEffects, j)))
    //             bHasImportantTag = TRUE;
    //     }

    //     // check if effect already is saved into an effect group
    //     int nEffectAlreadySavedInGroup;
    //     for (j = 0; j < JsonGetLength(jaSavedEffectGroups); j++) {
    //         if (strEffect.sID == JsonGetString(JsonArrayGet(jaSavedEffectGroups, j)))
    //             nEffectAlreadySavedInGroup = TRUE;
    //     }

    //     if (!bHasImportantTag || nEffectAlreadySavedInGroup)
    //         continue;

    //     // effect is new; store all effects into a group
    //     json jaEffectGroup = JsonArray();
    //     for (j = 0; j < NWNX_Effect_GetTrueEffectCount(oObj); j++) {
    //         struct NWNX_EffectUnpacked strEffect2 = NWNX_Effect_GetTrueEffect(oObj, j);

    //         if (strEffect2.sID == strEffect.sID && strEffect2.sTag == strEffect.sTag)
    //             jaEffectGroup = JsonArrayInsert(jaEffectGroup, JsonEffect(NWNX_Effect_PackEffect(strEffect2)));
    //     }

    //     // save the effect group into jaEffects
    //     jaSavedEffectGroups = JsonArrayInsert(jaSavedEffectGroups, JsonInt(StringToInt(strEffect.sID)));
    //     jaEffects = JsonArrayInsert(jaEffects, jaEffectGroup);
    // }

    // return jaEffects;
}

json JsonEffect(effect eEffect) {
    struct NWNX_EffectUnpacked strEffect = NWNX_Effect_UnpackEffect(eEffect);

    json joEffect = JsonObject();
    joEffect = JsonObjectSet(joEffect, "nType", JsonInt(strEffect.nType));
    joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(strEffect.nSubType));
    joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
    joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(strEffect.nParam1));
    joEffect = JsonObjectSet(joEffect, "nParam2", JsonInt(strEffect.nParam2));
    joEffect = JsonObjectSet(joEffect, "nParam3", JsonInt(strEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "nParam4", JsonInt(strEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "sTag", JsonString(strEffect.sTag));

    // fixes a bug where duration remaining returns 0 if effect isn't currently applied to an object; in these cases, total duration is same as remaining duration
    int nDurationRemaining = GetEffectDurationRemaining(eEffect);
    if (!nDurationRemaining)
        nDurationRemaining = GetEffectDuration(eEffect);

    joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(IntToFloat(nDurationRemaining)));

    return joEffect;
}

effect JsonGetEffect(json joEffect) {
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

    return NWNX_Effect_PackEffect(strEffect);
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

int DelTaggedEffect(object oObj, string sTag) {
    effect eEffect = GetFirstEffect(oObj);
    while (GetIsEffectValid(eEffect)) {
        if (GetEffectTag(eEffect) == sTag) {
            RemoveEffect(oObj, eEffect);
            return TRUE;
        }
        eEffect = GetNextEffect(oObj);
    }

    return FALSE;
}