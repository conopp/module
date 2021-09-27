#include "nwnx_admin"

void main()
{
    // Set Debug Options
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_COMBAT, TRUE);
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_SAVING_THROW, TRUE);
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_MOVEMENT_SPEED, TRUE);
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_HIT_DIE, TRUE);

    // Set Startup Script
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_MODULE_LOAD, "module_load");
}