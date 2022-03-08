#include "nwnx_events"
#include "inc_conopp"

void main() {
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM_OBJECT_ID"));
    int nSlot = StringToInt(NWNX_Events_GetEventData("SLOT"));

    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_SMALLSHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_SMALL) && nSlot == INVENTORY_SLOT_LEFTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_LARGESHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_LARGE) && nSlot == INVENTORY_SLOT_LEFTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_TOWERSHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_TOWER) && nSlot == INVENTORY_SLOT_LEFTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_LIGHTCROSSBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_CROSSBOW) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_DAGGER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_DAGGER) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_LIGHTHAMMER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_HAMMER) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_HANDAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_HANDAXE) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_SHORTSPEAR:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SPEAR) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_THROWINGAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_THROWING_AXE) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_SHORTBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTBOW) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_RAPIER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_RAPIER) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_LIGHTFLAIL:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_FLAIL) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_LONGSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_GREATSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_GREATSWORD) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_LONGBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGBOW) && (nSlot == INVENTORY_SLOT_RIGHTHAND || nSlot == INVENTORY_SLOT_LEFTHAND))
                NWNX_Events_SetEventResult("3");
            break;
        case BASE_ITEM_DIREMACE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_DIRE_MACE) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_DOUBLEAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_TWO_SIDED_AXE) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_TWOBLADEDSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_TWO_BLADED_SWORD) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
        case BASE_ITEM_SCYTHE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SCYTHE) && nSlot == INVENTORY_SLOT_RIGHTHAND)
                NWNX_Events_SetEventResult("2");
            break;
    }
}