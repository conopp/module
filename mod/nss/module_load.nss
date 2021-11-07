#include "nwnx_events"

void main()
{
    // Set Event Scripts
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_HEARTBEAT, "module_hb");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "player_gui");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER, "player_enter");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT, "player_exit");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH, "player_death");

    object oArea = GetFirstArea();
    while (GetIsObjectValid(oArea)) {
        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_ENTER, "area_enter");
        SetEventScript(oArea, EVENT_SCRIPT_AREA_ON_EXIT, "area_exit");

        object oObject = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oObject)) {
            if (GetResRef(oObject) == "trans01" || GetResRef(oObject) == "trans02") {
                SetEventScript(oObject, EVENT_SCRIPT_PLACEABLE_ON_USED, "trans_used");
            }

            oObject = GetNextObjectInArea(oArea);
        }

        oArea = GetNextArea();
    }

    // Subscribed Events
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "player_login");
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_EQUIP_AFTER", "equip_after");
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_UNEQUIP_AFTER", "unequip_after");

    // Radial Menu Overrides
    SetTlkOverride(278, "Unlock");
    SetTlkOverride(68656, "Assign Unlock");
}