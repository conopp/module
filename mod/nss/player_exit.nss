#include "inc_general"
#include "nwnx_object"

void main()
{
    object oPC = GetExitingObject();

    sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "UPDATE characters " +
        "SET location=@location, health=@health " +
        "WHERE uuid=@uuid "
    );
    SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oPC));
    SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oPC));
    SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
    SqlStep(sqlQuery);

    // in case character's row was deleted from table before he logged out (or any other unknown error), make a row for him now or re-create his row
    if (SqlGetError(sqlQuery) != "") {
        sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
            "REPLACE INTO characters " +
            "VALUES (@uuid, @cdkey, @name, @location, @health, strftime('%s','now')) "
        );
        SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
        SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
        SqlBindString(sqlQuery, "@name", GetName(oPC));
        SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oPC));
        SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oPC));
        SqlStep(sqlQuery);
    }
}