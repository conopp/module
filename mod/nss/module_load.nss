#include "nwnx_events"

void main()
{
    // Set Event Scripts
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "player_gui");

    // Subscribed Events
    NWNX_Events_SubscribeEvent("NWNX_ON_USE_SKILL_BEFORE", "skill_using");

    // Radial Menu Overrides
    SetTlkOverride(269,  "Beast-Handling");
    SetTlkOverride(67567, "Assign Beast-Handling");
    SetTlkOverride(278, "Unlock");
    SetTlkOverride(68656, "Assign Unlock");
}