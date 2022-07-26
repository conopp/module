#include "inc_skin"
#include "inc_effects"
#include "inc_nui"

void main()
{
    object oPC = GetLastGuiEventPlayer();

    // todo: see NWNX_ON_SERVER_SEND_AREA_AFTER to make this event easier (& PLAYER_NEW_TO_MODULE)
    //       ie: move the GUIEVENT_AREA_LOADSCREEN_FINISHED code block to a new event/file instead of here

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED:
            // player connecting to server
            if (!GetLocalInt(oPC, "bConnected")) {
                SetLocalInt(oPC, "bConnected", TRUE);
                ExecuteScript("pl_ready", oPC);
            // player transitioned to new area
            } else {
                SetSkinLocation(oPC, PL_LOCATION, GetLocation(oPC));
                SetSkinInt(oPC, PL_HITPOINTS, GetCurrentHitPoints(oPC));
                SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));
            }
            break;
        case GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN:
            if (GetLastGuiEventInteger() == GUI_PANEL_INVENTORY)
                NuiOpenInventory(oPC);
            break;
    }
}