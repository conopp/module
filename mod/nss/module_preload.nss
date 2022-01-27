#include "nwnx_events"

void main()
{
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "player_login");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "player_gui");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE", "player_logout");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_AFTER", "player_left");

    // create table to be able to store persistent data in database
    sqlquery sqlCreate = SqlPrepareQueryCampaign("conopp", "CREATE TABLE IF NOT EXISTS persistence (" +
        "uuid     TEXT UNIQUE NOT NULL"
        "location  TEXT," +
        "hitpoints TEXT," +
        "effects   TEXT" +
    ")"); SqlStep(sqlCreate);
}