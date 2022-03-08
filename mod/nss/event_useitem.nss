#include "nwnx_events"
#include "inc_conopp"

void main() {
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM_OBJECT_ID"));

    switch (GetBaseItemType(oItem)) {
        case BASE_ITEM_SMALLSHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_SMALL))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LARGESHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_LARGE))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_TOWERSHIELD:
            if (GetHasFeat(FEAT_SHIELD_PROFICIENCY_TOWER))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LIGHTCROSSBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_CROSSBOW))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_DAGGER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_DAGGER))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LIGHTHAMMER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_HAMMER))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_HANDAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_HANDAXE))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_SHORTSPEAR:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SPEAR))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_THROWINGAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_THROWING_AXE))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_SHORTBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SHORTBOW))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_RAPIER:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_RAPIER))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LIGHTFLAIL:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_FLAIL))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LONGSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGSWORD))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_GREATSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_GREATSWORD))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_LONGBOW:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_LONGBOW))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_DIREMACE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_DIRE_MACE))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_DOUBLEAXE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_TWO_SIDED_AXE))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_TWOBLADEDSWORD:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_TWO_BLADED_SWORD))
                NWNX_Events_SetEventResult("1");
            break;
        case BASE_ITEM_SCYTHE:
            if (GetHasFeat(FEAT_WEAPON_PROFICIENCY_SCYTHE))
                NWNX_Events_SetEventResult("1");
            break;
    }
}