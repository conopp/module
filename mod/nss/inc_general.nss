// ************************
// *       Includes       *
// ************************


#include "nwnx_object"
#include "nwnx_creature"
#include "nwnx_player"


// ************************
// *      Variables       *
// ************************


int i = 0; // iterative for-loop indexer

const int FEAT_IMMUNITY_FLATFOOT = 1435; // feat.2da

const int SPELL_BEASTHANDLING = 840; // spells.2da


// ************************
// *      Prototypes      *
// ************************


// Gives the creature a skin if they don't already have one
object GiveCreatureSkin(object oCreature);

// Sets a variable on a creature's skin item
void SetSkinInt(object oCreature, string sVariable, int nValue);

// Sets a variable on a creature's skin item
void SetSkinFloat(object oCreature, string sVariable, float fValue);

// Sets a variable on a creature's skin item
void SetSkinString(object oCreature, string sVariable, string sValue);

// Sets a variable on a creature's skin item
void SetSkinLocation(object oCreature, string sVariable, location lValue);

// Sets a variable on a creature's skin item
// Creates skin item on creature if it doesn't yet exist
// jValue type is already assumed to have been declared or set
void SetSkinJson(object oCreature, string sVariable, json jValue);

// *************************

// Gets a variable from a creature's skin item
int GetSkinInt(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
float GetSkinFloat(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
string GetSkinString(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
location GetSkinLocation(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
json GetSkinJson(object oCreature, string sVariable);

// Returns the duration remaining of an effect with sTag on a creature
// If multiple effects of the same tag exists, it returns the longest time
int GetTaggedEffectDurationRemaining(object oCreature, string sTag);

// Returns an object's location as json object; works identically to GetLocation() except for return type
// example of json structure that'd be built:
// {
//     area: "uuid-1234567890",
//     position: {
//         "x": 27.3,
//         "y": 16.8,
//         "z": 1.0
//     },
//     facing: 217.0
// }
json GetLocationAsJson(object oObject);

// Counter to GetLocationAsJson(); returns a proper nwscript location type from a GetLocationAsJson()
location GetLocationFromJson(json joLocation);

// *************************

// Deletes a variable from a creature's skin item
void DeleteSkinInt(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinFloat(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinString(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinLocation(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinJson(object oCreature, string sVariable);

// Cycles through a creature's effects and removes the first effect on a creature with tag sTag
void RemoveTaggedEffect(object oCreature, string sTag);

// Identical to RemoveTaggedEffect, except that it doesn't stop after the first match
void RemoveAllTaggedEffects(object oCreature, string sTag);

// *************************

// Gets a suitable <cXXX> token to use at the start of a block of colored text. Must be terminated by </c>
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255);

// Returns an INVENTORY_SLOT_* constant if a creature has the specified item equipped in any possible slot, or -1 on failure
int HasItemEquipped(object oItem, object oCreature=OBJECT_SELF);

// Flatfoots a creature for a duration (non-stacking -10dex & boots' dodge ac lost)
// Even with Monster Uncanny Dodge, creatures can still be flatfooted with EffectStunned, EffectParalysis, EffectEntangle, EffectSleep, EffectPetrified (and maybe others); the fix for this is to similate all these effects without actually using them (preventing a player from moving with the boulder option and setting them uncommandable)
void FlatfootCreature(object oCreature, float fSeconds);

// Forces the creature to lose any AC (including any vs. specified types) from a worn gear item for a duration
// nArmorClassType is the AC type to lose AC for
// nInventorySlot is the inventory slot to check AC of; this doesn't necessarily need to match nArmorClassType, but should in most cases
// sTag is the tag to apply to the AC penalty effect to reference later
void ApplyArmorClassLossFromGear(object oCreature, int nArmorClassType, int nInventorySlot, float fSeconds, int nEffectIcon=EFFECT_TYPE_INVALIDEFFECT, string sTag="");


// *************************
// *       Functions       *
// *************************


object GiveCreatureSkin(object oCreature) {
    // iit_cr_item_001 isn't creatable; all creatures must use x3_it_pchide
    object oSkin = CreateItemOnObject("x3_it_pchide", oCreature);
    NWNX_Creature_RunEquip(oCreature, oSkin, INVENTORY_SLOT_CARMOUR);
    SetItemCursedFlag(oSkin, TRUE);
    return oSkin;
}

void SetSkinInt(object oCreature, string sVariable, int nValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) oSkin = GiveCreatureSkin(oCreature);
    SetLocalInt(oSkin, sVariable, nValue);
}

void SetSkinFloat(object oCreature, string sVariable, float fValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) oSkin = GiveCreatureSkin(oCreature);
    SetLocalFloat(oSkin, sVariable, fValue);
}

void SetSkinString(object oCreature, string sVariable, string sValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) oSkin = GiveCreatureSkin(oCreature);
    SetLocalString(oSkin, sVariable, sValue);
}

void SetSkinLocation(object oCreature, string sVariable, location lValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) oSkin = GiveCreatureSkin(oCreature);
    SetLocalLocation(oSkin, sVariable, lValue);
}

void SetSkinJson(object oCreature, string sVariable, json jValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) oSkin = GiveCreatureSkin(oCreature);
    SetLocalJson(oSkin, sVariable, jValue);
}

// *************************

int GetSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) GiveCreatureSkin(oCreature);
    return GetLocalInt(oSkin, sVariable);
}

float GetSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) GiveCreatureSkin(oCreature);
    return GetLocalFloat(oSkin, sVariable);
}

string GetSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) GiveCreatureSkin(oCreature);
    return GetLocalString(oSkin, sVariable);
}

location GetSkinLocation(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) GiveCreatureSkin(oCreature);
    return GetLocalLocation(oSkin, sVariable);
}

json GetSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) GiveCreatureSkin(oCreature);
    return GetLocalJson(oSkin, sVariable);
}

int GetTaggedEffectDurationRemaining(object oCreature, string sTag) {
    int nSeconds = 0;
    effect eEffect = GetFirstEffect(oCreature);
    while (GetIsEffectValid(eEffect)) {
        if (GetEffectTag(eEffect) == sTag) {
            int nCompare = GetEffectDurationRemaining(eEffect);
            if (nSeconds < nCompare) nSeconds = nCompare;
        }
        eEffect = GetNextEffect(oCreature);
    }
    return nSeconds;
}

json GetLocationAsJson(object oObject) {
    json joLocation = JsonObject();
    // set area
    joLocation = JsonObjectSet(joLocation, "area", JsonString(GetTag(GetArea(oObject))));
    // set position
    json joPosition = JsonObject();
    vector vPosition = GetPosition(oObject);
    joPosition = JsonObjectSet(joPosition, "x", JsonFloat(vPosition.x));
    joPosition = JsonObjectSet(joPosition, "y", JsonFloat(vPosition.y));
    joPosition = JsonObjectSet(joPosition, "z", JsonFloat(vPosition.z));
    joLocation = JsonObjectSet(joLocation, "position", joPosition);
    // set facing
    joLocation = JsonObjectSet(joLocation, "facing", JsonFloat(GetFacing(oObject)));

    return joLocation;
}

location GetLocationFromJson(json joLocation) {
    // get area
    object oArea = GetObjectByTag(JsonGetString(JsonObjectGet(joLocation, "area")));
    // get position
    json joPosition = JsonObjectGet(joLocation, "position");
    float x = JsonGetFloat(JsonObjectGet(joPosition, "x"));
    float y = JsonGetFloat(JsonObjectGet(joPosition, "y"));
    float z = JsonGetFloat(JsonObjectGet(joPosition, "z"));
    vector vPosition = Vector(x, y, z);
    // get facing
    float fFacing = JsonGetFloat(JsonObjectGet(joLocation, "facing"));

    return Location(oArea, vPosition, fFacing);
}

// *************************
void DeleteSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) DeleteLocalInt(oSkin, sVariable);
}

void DeleteSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) DeleteLocalFloat(oSkin, sVariable);
}

void DeleteSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) DeleteLocalString(oSkin, sVariable);
}

void DeleteSkinLocation(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) DeleteLocalLocation(oSkin, sVariable);
}

void DeleteSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) DeleteLocalJson(oSkin, sVariable);
}

void RemoveTaggedEffect(object oCreature, string sTag) {
    effect eLoop = GetFirstEffect(oCreature);
    while (GetIsEffectValid(eLoop)) {
        if (GetEffectTag(eLoop) == sTag) {
            RemoveEffect(oCreature, eLoop);
            break;
        }
        eLoop = GetNextEffect(oCreature);
    }
}

void RemoveAllTaggedEffects(object oCreature, string sTag) {
    effect eLoop = GetFirstEffect(oCreature);
    while (GetIsEffectValid(eLoop)) {
        if (GetEffectTag(eLoop) == sTag) {
            RemoveEffect(oCreature, eLoop);
        }
        eLoop = GetNextEffect(oCreature);
    }
}

// *************************

const string COLOR_TOKEN = "\x01\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">";
}

int HasItemEquipped(object oItem, object oCreature=OBJECT_SELF) {
    if (GetItemInSlot(INVENTORY_SLOT_HEAD, oCreature) == oItem) return INVENTORY_SLOT_HEAD;
    else if (GetItemInSlot(INVENTORY_SLOT_CHEST, oCreature) == oItem) return INVENTORY_SLOT_CHEST;
    else if (GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature) == oItem) return INVENTORY_SLOT_BOOTS;
    else if (GetItemInSlot(INVENTORY_SLOT_ARMS, oCreature) == oItem) return INVENTORY_SLOT_ARMS;
    else if (GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oCreature) == oItem) return INVENTORY_SLOT_RIGHTHAND;
    else if (GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oCreature) == oItem) return INVENTORY_SLOT_LEFTHAND;
    else if (GetItemInSlot(INVENTORY_SLOT_CLOAK, oCreature) == oItem) return INVENTORY_SLOT_CLOAK;
    else if (GetItemInSlot(INVENTORY_SLOT_LEFTRING, oCreature) == oItem) return INVENTORY_SLOT_LEFTRING;
    else if (GetItemInSlot(INVENTORY_SLOT_RIGHTRING, oCreature) == oItem) return INVENTORY_SLOT_RIGHTRING;
    else if (GetItemInSlot(INVENTORY_SLOT_NECK, oCreature) == oItem) return INVENTORY_SLOT_NECK;
    else if (GetItemInSlot(INVENTORY_SLOT_BELT, oCreature) == oItem) return INVENTORY_SLOT_BELT;
    else if (GetItemInSlot(INVENTORY_SLOT_ARROWS, oCreature) == oItem) return INVENTORY_SLOT_ARROWS;
    else if (GetItemInSlot(INVENTORY_SLOT_BULLETS, oCreature) == oItem) return INVENTORY_SLOT_BULLETS;
    else if (GetItemInSlot(INVENTORY_SLOT_BOLTS, oCreature) == oItem) return INVENTORY_SLOT_BOLTS;
    else if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oCreature) == oItem) return INVENTORY_SLOT_CWEAPON_L;
    else if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oCreature) == oItem) return INVENTORY_SLOT_CWEAPON_R;
    else if (GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oCreature) == oItem) return INVENTORY_SLOT_CWEAPON_B;
    else if (GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature) == oItem) return INVENTORY_SLOT_CARMOUR;
    else return -1;
}

// eventually add option to lock player in place (potentially by spawning an object inside them?)
void FlatfootCreature(object oCreature, float fSeconds) {
    // if new flatfooted effect will expire before the existing one, don't add it at all; we only want 1 stack to ever exist at a time on the creature; "flatfooted_dex" is a more stable effect than "flatfooted_ac" which gets replaced more often (when boots are (un)equipped)
    if (fSeconds < IntToFloat(GetTaggedEffectDurationRemaining(oCreature, "flatfooted_dex")) || GetHasFeat(FEAT_IMMUNITY_FLATFOOT, oCreature)) return;

    // removing previous effects can sometimes take too long and run after we assigned the new effects; DelayCommand ensures our new effects apply afterwards
    RemoveAllTaggedEffects(oCreature, "flatfooted_ac");
    RemoveTaggedEffect(oCreature, "flatfooted_dex");
    DelayCommand(0.0, ApplyArmorClassLossFromGear(oCreature, AC_DODGE_BONUS, INVENTORY_SLOT_BOOTS, fSeconds, EFFECT_ICON_FATIGUE, "flatfooted_ac"));
    DelayCommand(0.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(EffectAbilityDecrease(ABILITY_DEXTERITY, 10)), EffectIcon(EFFECT_ICON_FATIGUE)), "flatfooted_dex"), oCreature, fSeconds));

    DeleteLocalInt(oCreature, "bFlatfooted");
    SetLocalInt(oCreature, "bFlatfooted", TRUE);
    DelayCommand(fSeconds, DeleteLocalInt(oCreature, "bFlatfooted"));
}

void ApplyArmorClassLossFromGear(object oCreature, int nArmorClassType, int nInventorySlot, float fSeconds, int nEffectIcon, string sTag) {
    object oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oCreature);
    if (!GetIsObjectValid(oItem)) return;

    itemproperty ipProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipProp)) {
        int nType = GetItemPropertyType(ipProp);
        int nSubtype = GetItemPropertySubType(ipProp);
        int nValue = GetItemPropertyCostTableValue(ipProp);

        SendMessageToPC(oCreature, "nType:" + IntToString(nType) + " | " + "nSubtype:" + IntToString(nSubtype) + " | " + "nValue:" + IntToString(nValue));

        if (nType == ITEM_PROPERTY_AC_BONUS) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(EffectACDecrease(nValue, nValue)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
        } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) {
            if (nSubtype == IP_CONST_ALIGNMENTGROUP_LAWFUL || nSubtype == IP_CONST_ALIGNMENTGROUP_CHAOTIC) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACDecrease(nValue), nSubtype, ALIGNMENT_ALL)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
            } else if (nSubtype == IP_CONST_ALIGNMENTGROUP_GOOD || nSubtype == IP_CONST_ALIGNMENTGROUP_EVIL) {
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACDecrease(nValue), ALIGNMENT_ALL, nSubtype)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
            } else if (nSubtype == IP_CONST_ALIGNMENTGROUP_NEUTRAL) {
                // we apply decrease to law-chaos & good-evil axis, then increase for true-neutral where they overlap, so the decrease is consistent and looks like a plus sign
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACDecrease(nValue), ALIGNMENT_ALL, nSubtype)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACDecrease(nValue), nSubtype, ALIGNMENT_ALL)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACIncrease(nValue), nSubtype, nSubtype)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
            }
        } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) {
            int nDamageType = (nValue == IP_CONST_DAMAGETYPE_BLUDGEONING) ? (DAMAGE_TYPE_BASE_WEAPON + DAMAGE_TYPE_BLUDGEONING) : (nValue == IP_CONST_DAMAGETYPE_PIERCING) ? (DAMAGE_TYPE_BASE_WEAPON + DAMAGE_TYPE_PIERCING) : (DAMAGE_TYPE_BASE_WEAPON + DAMAGE_TYPE_SLASHING);
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(EffectACDecrease(nValue, AC_DODGE_BONUS, nDamageType)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
        } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusRacialTypeEffect(EffectACDecrease(nValue), nSubtype)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
        } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) {
            int nLawChaos = 0;
            int nGoodEvil = 0;
            if (nSubtype == IP_CONST_ALIGNMENT_LG) {nLawChaos = 2; nGoodEvil = 4;}
            else if (nSubtype == IP_CONST_ALIGNMENT_LN) {nLawChaos = 2; nGoodEvil = 1;}
            else if (nSubtype == IP_CONST_ALIGNMENT_LE) {nLawChaos = 2; nGoodEvil = 5;}
            else if (nSubtype == IP_CONST_ALIGNMENT_NG) {nLawChaos = 1; nGoodEvil = 4;}
            else if (nSubtype == IP_CONST_ALIGNMENT_TN) {nLawChaos = 1; nGoodEvil = 1;}
            else if (nSubtype == IP_CONST_ALIGNMENT_NE) {nLawChaos = 1; nGoodEvil = 5;}
            else if (nSubtype == IP_CONST_ALIGNMENT_CG) {nLawChaos = 3; nGoodEvil = 4;}
            else if (nSubtype == IP_CONST_ALIGNMENT_CN) {nLawChaos = 3; nGoodEvil = 1;}
            else if (nSubtype == IP_CONST_ALIGNMENT_CE) {nLawChaos = 3; nGoodEvil = 5;}
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(HideEffectIcon(VersusAlignmentEffect(EffectACDecrease(nValue), nLawChaos, nGoodEvil)), EffectIcon(nEffectIcon)), sTag), oCreature, fSeconds);
        }

        ipProp = GetNextItemProperty(oItem);
    }
}