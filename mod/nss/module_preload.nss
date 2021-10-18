#include "nwnx_admin"
#include "nwnx_feedback"

void main()
{
    // Set Debug Options
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_COMBAT, TRUE);
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_SAVING_THROW, TRUE);
    // NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_MOVEMENT_SPEED, TRUE);
    NWNX_Administration_SetDebugValue(NWNX_ADMINISTRATION_DEBUG_HIT_DIE, TRUE);

    // Enable Specific Feedback Messages
    // animal empathy feedback -> overriden with custom string in s3_beasthandling
    NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_ASSOCIATE_DOMINATED, TRUE);
    NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_ASSOCIATE_DOMINATION_ENDED, TRUE);
    // "spell cast by" message with it's concentration check -> blocked because we use ActionCastSpell cheating and it announces as a "spell"
    NWNX_Feedback_SetCombatLogMessageHidden(NWNX_FEEDBACK_COMBATLOG_CAST_SPELL, TRUE);

    // Set Startup Script
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_MODULE_LOAD, "module_load");

    // Setup Databases

}