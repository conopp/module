#include "inc_general"
#include "nwnx_area"
#include "nwnx_object"

const int CLEANUP_TIME = 300; // seconds

sqlquery sqlQuery;

// purifies an area as if it was never entered
void CleanupArea();

void main()
{
    string sObject = ObjectToString(GetExitingObject());
    if (GetStringLength(sObject) != 8 || GetStringLeft(sObject, 4) != "7fff") return; // now-invalid player object requires GetIsPC workaround for OnAreaExit

    // no players left in this area, serialize creatures within and schedule area for deletion
    if (NWNX_Area_GetNumberOfPlayersInArea(OBJECT_SELF) == 0) {
        json jaCreatures = JsonArray();
        object oObject = GetFirstObjectInArea(OBJECT_SELF);
        while (GetIsObjectValid(oObject)) {
            if (GetObjectType(oObject) == OBJECT_TYPE_CREATURE) {
                json joCreature = JsonObject();
                json joPosition = JsonObject();

                // save object as serialized string
                joCreature = JsonObjectSet(joCreature, "serialization", JsonString(NWNX_Object_Serialize(oObject)));
                // save position as json
                vector vPosition = GetPosition(oObject);
                joPosition = JsonObjectSet(joPosition, "x", JsonFloat(vPosition.x));
                joPosition = JsonObjectSet(joPosition, "y", JsonFloat(vPosition.y));
                joPosition = JsonObjectSet(joPosition, "z", JsonFloat(vPosition.z));
                joCreature = JsonObjectSet(joCreature, "position", joPosition);
                // save facing as json
                joCreature = JsonObjectSet(joCreature, "facing", JsonFloat(GetFacing(oObject)));

                // save creature's json object to the array of all-creatures
                jaCreatures = JsonArrayInsert(jaCreatures, joCreature);
                DestroyObject(oObject);
            }
            oObject = GetNextObjectInArea(OBJECT_SELF);
        }

        sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
            "REPLACE INTO _areacleanup " +
            "VALUES (@uuid, @creatures, strftime('%s','now')) "
        );
        SqlBindString(sqlQuery, "@uuid", GetObjectUUID(OBJECT_SELF));
        SqlBindJson(sqlQuery, "@creatures", jaCreatures);
        SqlStep(sqlQuery);

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
                // trans and waypoint have same tag; make sure we change the texture of the correct object
                object oTrans = GetObjectByTag(GetTag(oObject));
                if (oTrans == OBJECT_SELF) oTrans = GetObjectByTag(GetTag(oObject), 1);
                ReplaceObjectTexture(oTrans, "trans_blu");
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