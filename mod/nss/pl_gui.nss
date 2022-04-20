#include "inc_skin"
#include "inc_effects"
#include "inc_nui"

void main()
{
    object oPC = GetLastGuiEventPlayer();

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
                // SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));
            }
            break;
        case GUIEVENT_DISABLED_PANEL_ATTEMPT_OPEN:
            if (GetLastGuiEventInteger() == GUI_PANEL_INVENTORY)
                NuiOpenInventory(oPC);
            break;
    }
}