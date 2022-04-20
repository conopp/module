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
struct NWNX_EffectUnpacked BlankEffect(int nType=0);

effect GetTaggedEffect(object oObj, string sTag);
int DelTagEffect(object oObj, string sTag);

// *************************
// *       Functions       *
// *************************

void SetEffects(object oObj, json jaEffects) {
    for (i = 0; i < JsonGetLength(jaEffects); i++) {
        json joEffect = JsonArrayGet(jaEffects, i);
        struct NWNX_EffectUnpacked strEffect = BlankEffect();

        // base properties
        strEffect.nType = JsonGetInt(JsonObjectGet(joEffect, "nType"));
        strEffect.nSubType = JsonGetInt(JsonObjectGet(joEffect, "nSubType"));
        strEffect.sTag = JsonGetString(JsonObjectGet(joEffect, "sTag"));
        float fDura = JsonGetFloat(JsonObjectGet(joEffect, "fDuration"));

        // variable properties
        if (strEffect.nType == NWNX_EFFECT_TYPE_AISTATEINTERNAL)
            strEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
        else if (strEffect.nType == NWNX_EFFECT_TYPE_VISION)
            strEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
        else if (strEffect.nType == NWNX_EFFECT_TYPE_ARCANESPELLFAILURE) {
            strEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            strEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
        } else if (strEffect.nType == NWNX_EFFECT_TYPE_SPELLFAILURE) {
            strEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            strEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
        }

        effect eEffect = NWNX_Effect_PackEffect(strEffect);

        // pair vfx to vision effect; couldn't save both because they'll be given different ids when applied
        if (strEffect.nType == NWNX_EFFECT_TYPE_VISION && strEffect.nSubType == VISION_TYPE_BLIND)
            eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BLACKOUT), eEffect);

        if (strEffect.nSubType % 2 == 0)
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oObj, fDura);
        else
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oObj, fDura);
    }
}

json GetEffects(object oObj) {
    json jaEffects = JsonArray();

    for (i = 0; NWNX_Effect_GetTrueEffectCount(oObj); i++) {
        struct NWNX_EffectUnpacked strEffect = NWNX_Effect_GetTrueEffect(oObj, i);

        // only these effects are supported
        if (strEffect.nType != NWNX_EFFECT_TYPE_AISTATEINTERNAL
         || strEffect.nType != NWNX_EFFECT_TYPE_VISION
         || strEffect.nType != NWNX_EFFECT_TYPE_ARCANESPELLFAILURE
         || strEffect.nType != NWNX_EFFECT_TYPE_SPELLFAILURE)
            continue;

        // nSubType is EffectDurationType + EffectSubType; only store temp or perm duration types
        // https://github.com/nwnxee/unified/blob/master/NWNXLib/API/Constants/Effect.hpp/#L215
        if (strEffect.nSubType - SUBTYPE_EXTRAORDINARY != 1 || strEffect.nSubType - SUBTYPE_EXTRAORDINARY != 2
         || strEffect.nSubType - SUBTYPE_SUPERNATURAL != 1 || strEffect.nSubType - SUBTYPE_SUPERNATURAL != 2
         || strEffect.nSubType - SUBTYPE_MAGICAL != 1 || strEffect.nSubType - SUBTYPE_MAGICAL != 2)
            continue;

        // base properties
        json joEffect = JsonObject();
        joEffect = JsonObjectSet(joEffect, "nType", JsonInt(strEffect.nType));
        joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(strEffect.nSubType));
        joEffect = JsonObjectSet(joEffect, "sTag", JsonString(strEffect.sTag));
        float fDura = IntToFloat(GetEffectDurationRemaining(NWNX_Effect_PackEffect(strEffect)));
        joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(fDura));

        // variable properties
        if (strEffect.nType == NWNX_EFFECT_TYPE_AISTATEINTERNAL)
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
        else if (strEffect.nType == NWNX_EFFECT_TYPE_VISION)
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
        else if (strEffect.nType == NWNX_EFFECT_TYPE_ARCANESPELLFAILURE) {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
            joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(strEffect.nParam1));
        } else if (strEffect.nType == NWNX_EFFECT_TYPE_SPELLFAILURE) {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(strEffect.nParam0));
            joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(strEffect.nParam1));
        }

        jaEffects = JsonArrayInsert(jaEffects, joEffect);
    }

    if (!JsonGetLength(jaEffects))
        return jNull;

    return jaEffects;
}

struct NWNX_EffectUnpacked BlankEffect(int nType=0) {
    struct NWNX_EffectUnpacked strEffect;
    strEffect.nType = nType;
    // nSubType 4 is reserved for internal engine effects like racial vision
    strEffect.nSubType = 4;
    strEffect.fDuration = 0.0;
    // nExpiry* is managed internally automatically, and we never need worry about it
    strEffect.nExpiryCalendarDay = 0;
    strEffect.nExpiryTimeOfDay = 0;
    strEffect.oCreator = OBJECT_INVALID;
    // spells with indentical nSpellId don't stack; NWNX_NOSTACK_SEPARATE_INVALID_OID_EFFECTS assigns ids for us
    strEffect.nSpellId = -1;
    // gives nwscript access to the effect when looping effects
    strEffect.bExpose = 1;
    strEffect.bShowIcon = 0;
    strEffect.nCasterLevel = 0;
    strEffect.eLinkLeft = EffectACIncrease(0);
    strEffect.bLinkLeftValid = 0;
    strEffect.eLinkRight = EffectACIncrease(0);
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