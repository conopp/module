#include "inc_general"
#include "inc_sqlite"
#include "nwnx_events"

void SetupDatabase();
void SetModTimescale(int nMinsPerHour, int nDayBegin, int nDayEnd);

void main()
{
    SetupDatabase();

    // settings
    SetModTimescale(10, 8, 20);
    SetModuleXPScale(0);

    // persistence
    NWNX_Events_SubscribeEvent("NWNX_ON_CALENDAR_HOUR", "mod_nexthour");
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "pl_connect");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "pl_gui");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE", "pl_disconnect");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_AFTER", "pl_left");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH, "pl_death");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED, "pl_revived");

    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_NUI_EVENT, "pl_nui");

    // commands
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_CHAT, "pl_chat");

    // hp override
    // SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_REST, "pl_rest");

    // feat bonuses
    // SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM, "ev_equipitem");
    // SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM, "ev_unequipitem");

    // don't need, or override to prevent default logic like horse skins
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_ACQUIRE_ITEM, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_ACTIVATE_ITEM, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_CLIENT_ENTER, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_DYING, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_EQUIP_ITEM, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_REST, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_UNEQUIP_ITEM, "");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_LOSE_ITEM, "");
}

void SetupDatabase() {
    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "CREATE TABLE IF NOT EXISTS " + TABLE_MOD + " (" +
        COL_NAME      + " BLOB NOT NULL UNIQUE," +
        COL_TIME      + " BLOB" +
    ")");
    SqlStep(sqlQuery);

    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "CREATE TABLE IF NOT EXISTS " + TABLE_STORAGE + " (" +
        COL_UUID      + " BLOB NOT NULL UNIQUE," +
        COL_NAME      + " BLOB NOT NULL," +
        COL_ICON      + " BLOB NOT NULL," +
        COL_BASEITEM  + " BLOB NOT NULL," +
        COL_DATA      + " BLOB NOT NULL," +
        COL_CDKEY     + " BLOB NOT NULL," +
        COL_CREATION  + " BLOB NOT NULL" +
    ")");
    SqlStep(sqlQuery);

    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "CREATE TABLE IF NOT EXISTS " + TABLE_MARKET + " (" +
        COL_UUID      + " BLOB NOT NULL UNIQUE," +
        COL_NAME      + " BLOB NOT NULL," +
        COL_ICON      + " BLOB NOT NULL," +
        COL_BASEITEM  + " BLOB NOT NULL," +
        COL_DATA      + " BLOB NOT NULL," +
        COL_CDKEY     + " BLOB NOT NULL," +
        COL_CREATION  + " BLOB NOT NULL" +
    ")");
    SqlStep(sqlQuery);
}

void SetModTimescale(int nMinsPerHour, int nDayBegin, int nDayEnd) {
    // get saved mod time from db
    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "SELECT " + COL_NAME + "," + COL_TIME + " FROM " + TABLE_MOD);
    SqlStep(sqlQuery);
    json joTime = SqlGetJson(sqlQuery, 1);

    if (joTime == jNull) {
        // start mod at the beginning of the year if there's no persistently saved time yet
        // set time before calendar so the day doesn't increase due to time wrapping around
        SetTime(nDayBegin-1, 0, 0, 0);
        SetCalendar(GetCalendarYear()+1, 1, 1);
    } else {
        int nMonth = JsonGetInt(JsonObjectGet(joTime, "month"));
        int nDay = JsonGetInt(JsonObjectGet(joTime, "day"));
        int nHour = JsonGetInt(JsonObjectGet(joTime, "hour"));
        int nMin = JsonGetInt(JsonObjectGet(joTime, "minute"));

        SetTime(nHour, nMin, 0, 0);
        SetCalendar(GetCalendarYear()+1, nMonth, nDay);
    }

    // timescale settings
    NWNX_Util_SetMinutesPerHour(nMinsPerHour);
    // day begin is after dawn, day end is after dusk
    NWNX_Util_SetDawnHour(nDayBegin-1);
    NWNX_Util_SetDuskHour(nDayEnd-1);
}