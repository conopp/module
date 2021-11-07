#include "nwnx_admin"
#include "nwnx_feedback"

sqlquery sqlQuery;

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
    NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_FLOATY_TEXT_STRING, TRUE);
    // "spell cast by" message with it's concentration check -> blocked because we use ActionCastSpell cheating and it announces as a "spell"
    NWNX_Feedback_SetCombatLogMessageHidden(NWNX_FEEDBACK_COMBATLOG_CAST_SPELL, TRUE);

    // Set Startup Script
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_MODULE_LOAD, "module_load");

    // Setup Databases
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "CREATE TABLE IF NOT EXISTS characters " +
        "(uuid TEXT UNIQUE NOT NULL, cdkey TEXT NOT NULL, name TEXT NOT NULL, location BLOB, health INTEGER, creation INTEGER NOT NULL) "
    ); SqlStep(sqlQuery);

    // empty leftover areas from table if server closed while areas were still in scheduled for cleanup
    // uuid is okay here because the table doesn't persist across restarts, just like uuid
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "DROP TABLE IF EXISTS _areacleanup "
    ); SqlStep(sqlQuery);
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "CREATE TABLE _areacleanup " +
        "(uuid TEXT UNIQUE NOT NULL, creatures BLOB NOT NULL, scheduled INTEGER NOT NULL) "
    ); SqlStep(sqlQuery);
}