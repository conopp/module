#include "inc_skin"
#include "inc_effects"

void main()
{
    object oPC = GetLastPlayerDied();

    SetSkinLocation(oPC, PL_LOCATION, GetLocation(oPC));
    SetSkinInt(oPC, PL_HITPOINTS, -1);
    // SetSkinJson(oPC, PL_EFFECTS, GetEffects(oPC));

    DelayCommand(3.0, PopUpGUIPanel(oPC, GUI_PANEL_PLAYER_DEATH));
}