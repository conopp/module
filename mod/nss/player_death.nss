#include "inc_conopp"

void main()
{
    object oPC = GetLastPlayerDied();

    // save player's location and hp when they die
    SetPlayerJson(oPC, PLAYER_LOCATION, JsonLocation(GetLocation(oPC)));
    SetPlayerJson(oPC, PLAYER_HITPOINTS, JsonInt(GetCurrentHitPoints(oPC)));

    SetHPOverrideLevel(oPC);

    // display death panel
    DelayCommand(3.0, PopUpGUIPanel(oPC, GUI_PANEL_PLAYER_DEATH));
}