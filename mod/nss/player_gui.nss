void main()
{
    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED: {
            ExecuteScript("player_ready", GetLastGuiEventPlayer());
            break;
        }
    }
}