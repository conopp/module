#include "inc_general"

void main()
{
    object oPC = GetFirstPC();
    while (GetIsObjectValid(oPC)) {
        // we won't try to save player's location if their current area is invalid due to loading an area
        if (GetIsObjectValid(GetArea(oPC)) && GetTag(GetArea(oPC)) != "lobby") {
            sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
                "UPDATE characters " +
                "SET location=@location, health=@health " +
                "WHERE uuid=@uuid "
            );
            SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oPC));
            SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oPC));
            SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
            SqlStep(sqlQuery);
        }

        oPC = GetNextPC();
    }
}