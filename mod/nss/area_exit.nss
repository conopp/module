#include "nwnx_area"

const int CLEANUP_TIME = 300; // seconds

sqlquery sqlQuery;

// purifies an area as if it was never entered
void CleanupArea();

void main()
{
    string sObject = ObjectToString(GetExitingObject());
    // workaround for GetIsPC returning false if area exit event was fired due to player leaving server
    if (GetStringLength(sObject) != 8 || GetStringLeft(sObject, 4) != "7fff") return;

    // no players left in this area, schedule it for cleanup and serialize everything inside
    if (NWNX_Area_GetNumberOfPlayersInArea(OBJECT_SELF) == 0) {
        // TODO - LOOP TO SERIALIZE CREATURES HERE -> STORE INTO jaCreatures

        sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
            "REPLACE INTO _areacleanup " +
            "VALUES (@uuid, @creatures, strftime('%s','now')) "
        );
        SqlBindString(sqlQuery, "@uuid", GetObjectUUID(OBJECT_SELF));
        SqlBindString(sqlQuery, "@creatures", /* TODO - JSON ARRAY OF ALL THE CREATURES IN THE AREA -> jaCreatures */);
        SqlStep(sqlQuery);

        // TODO - SERIALIZE CREATURES IN _areacleanup TABLE & DeleteObject THEM ALL

        DelayCommand(IntToFloat(CLEANUP_TIME), CleanupArea());
    }
}

// if somebody joins area, this function is skipped; when the leave area, cleanup is scheduled again
void CleanupArea() {
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "SELECT uuid " +
        "FROM _areacleanup " +
        "WHERE strftime('%s','now') - scheduled >= @CLEANUP_TIME "
    );
    SqlBindInt(sqlQuery, "@CLEANUP_TIME", CLEANUP_TIME);

    // turn all transitions leading to this area back to blue (from green)
    while (SqlStep(sqlQuery)) {
        object oArea = GetObjectByUUID(SqlGetString(sqlQuery, 0));
        object oObject = GetFirstObjectInArea(oArea);
        while (GetIsObjectValid(oObject)) {
            if (GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT) {
                ReplaceObjectTexture(GetObjectByTag(GetTag(oObject)), "trans_blu");
            }
            oObject = GetNextObjectInArea(oArea);
        }
    }

    // remove expired areas from table
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "DELETE FROM _areacleanup " +
        "WHERE strftime('%s','now') - scheduled >= @CLEANUP_TIME "
    ); SqlStep(sqlQuery);
}