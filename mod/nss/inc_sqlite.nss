// ************************
// *       Includes       *
// ************************

#include "inc_general"

// ************************
// *      Variables       *
// ************************

const int DEBUG_SQLITE = TRUE;

sqlquery sqlQuery;
const string MOD_NAME = "conopp";

const string TABLE_MOD = "module";
const string COL_NAME = "name";
const string COL_TIME = "game_time";

const string TABLE_ACCOUNTS = "accounts";
const string COL_CDKEY = "cdkey";
const string COL_CREATION = "creation";
const string COL_CHARS = "characters";

const string TABLE_STORAGE = "storage";
const string COL_UUID = "uuid";
const string COL_ICON = "icon";
const string COL_BASEITEM = "baseitem";
const string COL_DATA = "data";

const string TABLE_MARKET = "market";

// ************************
// *      Prototypes      *
// ************************

void SqlSetupDatabase();

json SqlGetModTime();
void SqlSetModTime();

string SqlGetTimestamp();

// json SqlListStorageItems(object oPC);
// void SqlSaveStorageItem(object oPC, object oObj, json jaItems);
// int SqlGrabStorageItem(object oPC, string sUUID, json jaItems);
// void SqlUpdateStorageItems(object oPC, json jaItems);

// json SqlListMarketItems(object oPC);
// void SqlSaveMarketItem(object oPC, object oObj, json jaItems);
// int SqlGrabMarketItem(object oPC, string sUUID, json jaItems);
// void SqlUpdateMarketItems(object oPC, json jaItems);

// *************************
// *       Functions       *
// *************************

void SqlSetupDatabase() {
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

json SqlGetModTime() {
    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "SELECT " + COL_NAME + "," + COL_TIME + " FROM " + TABLE_MOD);
    SqlStep(sqlQuery);

    return SqlGetJson(sqlQuery, 1);
}

// persist mod time so server restarts continue from the same in-game minute on startup
void SqlSetModTime() {
    json joVal = JsonObject();
    joVal = JsonObjectSet(joVal, "month", JsonInt(GetCalendarMonth()));
    joVal = JsonObjectSet(joVal, "day", JsonInt(GetCalendarDay()));
    joVal = JsonObjectSet(joVal, "hour", JsonInt(GetTimeHour()));
    joVal = JsonObjectSet(joVal, "minute", JsonInt(GetTimeMinute()));

    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "INSERT INTO " + TABLE_MOD + " " +
        "(" + COL_NAME + "," + COL_TIME + ") VALUES (@sModName,@joTime) " +
        "ON CONFLICT DO UPDATE SET " + COL_TIME + "=@joTime");
    SqlBindString(sqlQuery, "@sModName", MOD_NAME);
    SqlBindJson(sqlQuery, "@joTime", joVal);
    SqlStep(sqlQuery);
}

string SqlGetTimestamp() {
    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "SELECT CURRENT_TIMESTAMP");
    SqlStep(sqlQuery);

    return SqlGetString(sqlQuery, 0);
}

// void SqlAddChar(object oPC) {
//     sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "SELECT " + COL_CDKEY + "," + COL_CHARS + " " +
//         "FROM " + TABLE_ACCOUNTS + " " +
//         "WHERE " + COL_CDKEY + "=@cdkey");
//     SqlStep(sqlQuery);
//     string sUUID = SqlGetString(sqlQuery, 0);
//     json jChars = SqlGetJson(sqlQuery, 1);

//     string sTimestamp = SqlGetTimestamp();

//     if (sUUID == "") {
//         // need to add the new player's account & char to database
//         jChars = JsonArray();
//             json jChar = JsonObject();
//             jChar = JsonObjectSet(jChar, "uuid", JsonString(GetObjectUUID(oPC)));
//             jChar = JsonObjectSet(jChar, "creation", JsonString(sTimestamp));
//         jChars = JsonArrayInsert(jChars, jChar);

//         sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "INSERT INTO " + TABLE_ACCOUNTS + " " +
//             "(" + COL_CDKEY + "," + COL_CREATION + "," + COL_CHARS + ") VALUES (@cdkey,@creation,@chars)");
//         SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
//         SqlBindString(sqlQuery, "@creation", sTimestamp);
//         SqlBindJson(sqlQuery, "@chars", jChars);
//         SqlStep(sqlQuery);
//     } else {
//         json jChar = JsonObject();
//             jChar = JsonObjectSet(jChars, "uuid", JsonString(GetObjectUUID(oPC)));
//             jChar = JsonObjectSet(jChar, "creation", JsonString(sTimestamp));
//         jChars = JsonArrayInsert(jChars, jChar);

//         // player already has an existing account; this isn't their first char
//         sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "INSERT INTO " + TABLE_ACCOUNTS + " " +
//             "(" + COL_CDKEY + "," + COL_CHARS + ") VALUES (@cdkey,@chars)");
//         SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
//         SqlBindJson(sqlQuery, "@chars", jChars);
//         SqlStep(sqlQuery);
//     }
// }

// json SqlListStorageItems(object oPC) {
//     // get the array of stored items
//     sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "SELECT " + COL_CDKEY + "," + COL_STORAGE + " " +
//         "FROM " + TABLE_ACCTS + " " +
//         "WHERE " + COL_CDKEY + "=@cdkey");
//     SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
//     SqlStep(sqlQuery);

//     return SqlGetJson(sqlQuery, 0);
// }

// void SqlSaveStorageItem(object oPC, object oObj, json jaItems) {
//     // use item's uuid to track it between in-game & sql exchanges
//     GetObjectUUID(oObj);

//     jaItems = JsonArrayInsert(jaItems, ObjectToJson(oObj, TRUE));
//     SqlUpdateStorageItems(oPC, JsonArrayInsert(jaItems, ObjectToJson(oObj, TRUE)));
// }

// int SqlGrabStorageItem(object oPC, string sUUID, json jaItems) {
//     for (i = 0; i < JsonGetLength(jaItems); i++) {
//         json joItem = JsonArrayGet(jaItems, i);
//         string sSavedUUID = JsonGetString(JsonObjectGet(JsonObjectGet(joItem, "UUID"), "value"));

//         if (sUUID == sSavedUUID) {
//             jaItems = JsonArrayDel(jaItems, i);
//             SqlUpdateStorageItems(oPC, jaItems);

//             // give item to player
//             object oItem = JsonToObject(joItem, LOCATION_INVALID, oPC, TRUE);
//             ActionGiveItem(oItem, oPC);

//             return TRUE;
//         }
//     }

//     return FALSE;
// }

// void SqlUpdateStorageItems(object oPC, json jaItems) {
//     // save array of items
//     sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "INSERT INTO " + TABLE_ACCTS + " " +
//         "(" + COL_CDKEY + "," + COL_TIME + ") VALUES (@cdkey,@joItem)" +
//         "ON CONFLICT DO UPDATE SET " + COL_TIME + "=@joItem");
//     SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
//     SqlBindJson(sqlQuery, "@joItem", jaItems);
//     SqlStep(sqlQuery);
// }

// json SqlListMarketItems(object oPC) {}
// void SqlSaveMarketItem(object oPC, object oObj) {}
// int SqlGrabMarketItem(object oPC, string sUUID, json jaItems) {}
// void SqlUpdateMarketItems(object oPC, json jaItems) {}