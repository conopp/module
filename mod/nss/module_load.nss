#include "nwnx_events"

void main()
{
    // Set Event Scripts
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_HEARTBEAT, "module_hb");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "player_gui");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER, "player_enter");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_CLIENT_EXIT, "player_exit");

    // Subscribed Events
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_EQUIP_AFTER", "equip_after");
    NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_UNEQUIP_AFTER", "unequip_after");

    // Radial Menu Overrides
    SetTlkOverride(278, "Unlock");
    SetTlkOverride(68656, "Assign Unlock");
}