void main()
{
    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED: {
            if (!GetLocalInt(oPC, "bConnected")) {
                // area transition due to player connecting to game
                ExecuteScript("player_ready", GetLastGuiEventPlayer());
                SetLocalInt(oPC, "bConnected", TRUE);
            }
            break;
        }
    }
}