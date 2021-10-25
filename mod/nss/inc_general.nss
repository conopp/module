// ************************
// *       Includes       *
// ************************


// placeholder


// ************************
// *       Structs        *
// ************************


// for getting the AC value of gear; takes highest value for each category in case item has multiple on accident
// to get the data required to set these values, see GetItemProperty* functions
// if GetItemPropertyType != ITEM_PROPERTY_AC_*, this struct should not be returned
struct strArmorClassModifiers
{
    int nArmorClassType; // IP_CONST_ACMODIFIERTYPE_*

    // if GetItemPropertyType() == ITEM_PROPERTY_AC_BONUS
    // defined in iprp_melee.2da; set by ItemPropertyACBonus
    // values: 1-20
    int nGeneralBonus;

    // if GetItemPropertyType() == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP
    // defined in iprp_aligngrp.2da
    // constants:
    //   1 -> IP_CONST_ALIGNMENTGROUP_NEUTRAL
    //   2 -> IP_CONST_ALIGNMENTGROUP_LAWFUL
    //   3 -> IP_CONST_ALIGNMENTGROUP_CHAOTIC
    //   4 -> IP_CONST_ALIGNMENTGROUP_GOOD
    //   5 -> IP_CONST_ALIGNMENTGROUP_EVIL
    int nAlignmentGroup;
    // defined in iprp_melee.2da; set by ItemPropertyACBonusVsAlign
    // values: 1-20
    int nAlignmentGroupBonu;

    // if GetItemPropertyType() == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE
    // defined in iprp_combatdam.2da
    // constants:
    //   1 -> IP_CONST_DAMAGETYPE_BLUDGEONING
    //   2 -> IP_CONST_DAMAGETYPE_PIERCING
    //   3 -> IP_CONST_DAMAGETYPE_SLASHING
    int nDamageType;
    // defined in iprp_melee.2da; set by ItemPropertyACBonusVsDmgType
    // values: 1-20
    int nDamageTypeBonus;

    // if GetItemPropertyType() == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE
    // defined in racialtypes.2da
    // values: see 2da
    int nRacialGroup;
    // defined in iprp_melee.2da; set by ItemPropertyACBonusVsRace
    // values: 1-20
    int nRacialGroupBonus;

    // if GetItemPropertyType() == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT
    // defined in iprp_alignment.2da
    // constants:
    //   1 -> IP_CONST_ALIGNMENTGROUP_NEUTRAL
    //   2 -> IP_CONST_ALIGNMENTGROUP_LAWFUL
    //   3 -> IP_CONST_ALIGNMENTGROUP_CHAOTIC
    //   4 -> IP_CONST_ALIGNMENTGROUP_GOOD
    //   5 -> IP_CONST_ALIGNMENTGROUP_EVIL
    int nSpecificAlignment;
    // defined in iprp_melee.2da; set by ItemPropertyACBonusVsSAlign
    // values: 1-20
    int nSpecificAlignmentBonus;
};


// ************************
// *      Variables       *
// ************************


int i = 0; // iterative for-loop indexer

const int FEAT_BEASTHANDLING = 840; // spells.2da

const int ITEMPROPERTY_TYPE_ACBONUS = 1; // itemprops.2da

const int ITEMPROPERTY_COSTTABLE_MELEE = 2; // iprp_costtable.2da


// ************************
// *      Prototypes      *
// ************************


// Sets a variable on a creature's skin item
void SetSkinInt(object oCreature, string sVariable, int nValue);

// Sets a variable on a creature's skin item
void SetSkinFloat(object oCreature, string sVariable,float fValue);

// Sets a variable on a creature's skin item
void SetSkinString(object oCreature, string sVariable,string sValue);

// Sets a variable on a creature's skin item
// Creates skin item on creature if it doesn't yet exist
// jValue type is already assumed to have been declared or set
void SetSkinJson(object oCreature, string sVariable, json jValue);

// TODO - NWN_OnEquip -> If creature is currently has nFlatfooted >= 1 & baseitem = boots, remove the dodge ac loss effect from them and re-apply it with new boots dodge ac (will still work fine even if creature didn't have boots already equipped when they became flatfooted)
// Flatfoots a creature for a duration
// Sets Dexterity to 3
// Removes all dodge AC from gear from creature
// Option to tag the effect for referencing later (this should be the name of the thing causing flatfootedness)
// Option to disable movement
void FlatfootCreature(object oCreature, float fSeconds, int bStopMovement);

// Cycles through a creature's effects and removes the first effect on a creature with tag sTag
void RemoveTaggedEffect(object oCreature, string sTag);

// Identical to RemoveTaggedEffect, except that it doesn't stop after the first match
void RemoveAllTaggedEffects(object oCreature, string sTag);

// *************************

// Gets a variable from a creature's skin item
int GetSkinInt(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
float GetSkinFloat(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
string GetSkinString(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
json GetSkinJson(object oCreature, string sVariable);

// Returns total Dodge AC from the currently equipped boots
json GetWornGearAC(int nInventorySlot, object oCreature=OBJECT_SELF);

// Returns the duration remaining of an effect with sTag on a creature
// If multiple effects of the same tag exists, it returns the longest time
int GetTaggedEffectDurationRemaining(object oCreature, string sTag);

// *************************

// Deletes a variable from a creature's skin item
void DeleteSkinInt(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinFloat(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinString(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinJson(object oCreature, string sVariable);

// *************************

// Gets a suitable <cXXX> token to use at the start of a block of colored text. Must be terminated by </c>
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255);

// Returns an INVENTORY_SLOT_* constant if a creature has the specified item equipped in any possible slot, or -1 on failure
int HasItemEquipped(object oItem, object oCreature=OBJECT_SELF);

// *************************
// *       Functions       *
// *************************


void GiveCreatureSkin(object oCreature) {
    object oSkin = CreateItemOnObject("iit_cr_item_001", oCreature);
    SetDroppableFlag(oSkin, FALSE);
    AssignCommand(oCreature, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
}

void SetSkinInt(object oCreature, string sVariable, int nValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
        DelayCommand(0.1, SetSkinInt(oCreature, sVariable, nValue));
    }

    SetLocalInt(oSkin, sVariable, nValue);
}

void SetSkinFloat(object oCreature, string sVariable, float fValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalFloat(oSkin, sVariable, fValue));
}

void SetSkinString(object oCreature, string sVariable, string sValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalString(oSkin, sVariable, sValue));
}

void SetSkinJson(object oCreature, string sVariable, json jValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalJson(oSkin, sVariable, jValue));
}

// TODO - INSTEAD OF EffectCustsceneImmobilize, REPLACE IT WITH THE ROCK-METHOD (SEE COMMENTED-OUT GUI_LockPlayerInput FUNCTION AT BOTTOM)
// TODO - IN equip_after.nss & HERE, APPLY DODGE PENALTIES TO ANY SUBTYPES TOO (VS. RACE/ALIGNMENT)
void FlatfootCreature(object oCreature, float fSeconds, int bStopMovement) {
    // dexterity loss can stack for however many instances of flatfooted a creature has, but dodge ac loss should only be applied once, and always be lost for exactly as long as a creature is flatfooted, refreshing the loss duration if necessary; this ensures that
    if (fSeconds > IntToFloat(GetTaggedEffectDurationRemaining(oCreature, "bootsdodgeacloss"))) {
        RemoveAllTaggedEffects(oCreature, "bootsdodgeacloss");

        // loop through the boot's item properties and apply ac penalties to player for all the ac types listed on the the boots
        json jArmorClass = GetWornGearAC(INVENTORY_SLOT_BOOTS, oCreature);
        if (jArmorClass != JsonNull()) {
            for(i = ITEM_PROPERTY_AC_BONUS; i++; i <= ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) {
                int nArmorClass = JsonGetInt(JsonObjectGet(jArmorClass, IntToString(i)));
                if (nArmorClass != 0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectACDecrease(nArmorClass), "bootsdodgeacloss"), OBJECT_SELF, fSeconds);
            }
        }
    }

    effect eDexterityDecrease = EffectAbilityDecrease(ABILITY_DEXTERITY, 99);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDexterityDecrease, oCreature, fSeconds);

    /* if (bStopMovement) stick-em-inside-a-rock */

    // keep track of the amount of flatfooted effects on the creature, so we know if we should watch the creature's boots item for equip changes to update the dodge ac loss
    SetLocalInt(oCreature, "nFlatfooted", GetLocalInt(oCreature, "nFlatfooted") + 1);
    DelayCommand(fSeconds, SetLocalInt(oCreature, "nFlatfooted", GetLocalInt(oCreature, "nFlatfooted") - 1));

    // apply & remove an additional dex loss & ac loss, so player doesn't have the respective negative icons next to their portrait; temporary in case of server crash, we don't want the effects permanently on them
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectLinkEffects(EffectAbilityDecrease(ABILITY_DEXTERITY, 1), EffectACDecrease(1)), "eTemp"), oCreature, 0.1);
    RemoveAllTaggedEffects(oCreature, "eTemp");
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

int GetSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalInt(oSkin, sVariable);
}

float GetSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalFloat(oSkin, sVariable);
}

string GetSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalString(oSkin, sVariable);
}

json GetSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalJson(oSkin, sVariable);
}

json GetWornGearAC(int nInventorySlot, object oCreature=OBJECT_SELF) {
    json jArmorClass = JsonObject();

    object oItem = GetItemInSlot(nInventorySlot, oCreature);
    if (!GetIsObjectValid(oItem)) return JsonNull();

    itemproperty ipItemProp = GetFirstItemProperty(oItem);
    while (GetIsItemPropertyValid(ipItemProp)) {
        // skip itemproperty if it's not AC
        int nType = GetItemPropertyType(ipItemProp);
        if (nType != ITEM_PROPERTY_AC_BONUS || nType != ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP || nType != ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE || nType != ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP || nType != ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) continue;

        // in case multiple itemproperty ac types exist, save the highest
        int nCompare = JsonGetInt(JsonObjectGet(jArmorClass, IntToString(nType)));
        int nBonus = GetItemPropertyCostTableValue(ipItemProp);
        if (nCompare < nBonus) JsonObjectSet(jArmorClass, IntToString(nType), JsonInt(nBonus));
    }

    return jArmorClass;
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

// *************************
void DeleteSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalInt(oSkin, sVariable);
    }
}

void DeleteSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalFloat(oSkin, sVariable);
    }
}

void DeleteSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalString(oSkin, sVariable);
    }
}

void DeleteSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalJson(oSkin, sVariable);
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

// add https://github.com/Daztek/EventSystem/blob/master/Components/Services/es_srv_gui.nss#L168
// void GUI_LockPlayerInput(object oPlayer)
// {
//     GUI_UnlockPlayerInput(oPlayer);

//     location locPlayer = GetLocation(oPlayer);
//     object oLock = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_boulder", locPlayer, FALSE, GUI_SCRIPT_NAME + "_InputLock");

//     SetPlotFlag(oLock, TRUE);
//     NWNX_Object_SetPosition(oPlayer, GetPositionFromLocation(locPlayer));
//     ApplyEffectToObject(DURATION_TYPE_PERMANENT, ExtraordinaryEffect(EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY)), oLock);

//     SetLocalObject(oPlayer, GUI_SCRIPT_NAME + "_InputLock", oLock);
// }