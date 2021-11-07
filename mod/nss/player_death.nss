#include "inc_general"

void main()
{
    object oPC = GetLastPlayerDying();

    sqlquery sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "UPDATE characters " +
        "SET location=@location, health=@health " +
        "WHERE uuid=@uuid "
    );
    SqlBindJson(sqlQuery, "@location", GetLocationAsJson(oPC));
    SqlBindInt(sqlQuery, "@health", GetCurrentHitPoints(oPC));
    SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
    SqlStep(sqlQuery);

    AssignCommand(oPC, ClearAllActions());
    DelayCommand(3.0, PopUpDeathGUIPanel(oPC, TRUE, TRUE, 0, ""));
}