#include "inc_general"

void main()
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
        sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
            "UPDATE characters " +
            "SET location=@location, health=@health " +
            "WHERE uuid=@uuid "
        );
        SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oPC));
        SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oPC));
        SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
        SqlStep(sqlQuery);

        oPC = GetNextPC();
    }
}