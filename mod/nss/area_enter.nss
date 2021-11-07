#include "inc_general"

void main()
{
    object oObject = GetEnteringObject();
    if (!GetIsPC(oObject)) return;

    sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "UPDATE characters " +
        "SET location=@location, health=@health " +
        "WHERE uuid=@uuid "
    );
    SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oObject));
    SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oObject));
    SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oObject));
    SqlStep(sqlQuery);
}