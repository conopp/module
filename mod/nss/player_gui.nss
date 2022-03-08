#include "inc_conopp"

void main()
{
    object oPC = GetLastGuiEventPlayer();

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED: {
            // differentiate between a client's first area-load after connecting, or successive joins for regular transitions
            if (!GetLocalInt(oPC, "bAlreadyConnected")) {
                // area transition due to player connecting to game
                SetLocalInt(oPC, "bAlreadyConnected", TRUE);
                ExecuteScript("player_ready", oPC);
            } else {
                // ordinary area transition; save player's progress
                SetPlayerJson(OBJECT_SELF, PLAYER_LOCATION, JsonLocation(GetLocation(OBJECT_SELF)));
                SetPlayerJson(OBJECT_SELF, PLAYER_HITPOINTS, JsonInt(GetCurrentHitPoints(OBJECT_SELF)));
                SetPlayerJson(OBJECT_SELF, PLAYER_EFFECTS, GetCurrentEffects(OBJECT_SELF));
            }
            break;
        }
    }
}