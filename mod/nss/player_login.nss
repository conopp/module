#include "inc_general"
#include "nwnx_player"

sqlquery sqlQuery;

void MakeDie(object oPC, location lLocation);

void main()
{
    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
        "SELECT location, health " +
        "FROM characters " +
        "WHERE uuid=@uuid "
    );
    SqlBindString(sqlQuery, "@uuid", GetObjectUUID(OBJECT_SELF));
    SqlStep(sqlQuery);
    location lLocation = GetLocationFromJson(SqlGetJson(sqlQuery, 0));
    int nHP = SqlGetInt(sqlQuery, 1);

    AssignCommand(OBJECT_SELF, JumpToLocation(lLocation));
    // cannot set hitpoints to kill a PC; must be done manually
    if (nHP > 0) SetCurrentHitPoints(OBJECT_SELF, nHP);
    else MakeDie(OBJECT_SELF, lLocation);

    NWNX_Player_SetSpawnLocation(OBJECT_SELF, lLocation);
}

// TODO - SEE IF WE CAN EffectFreeze THE PLAYER OnDeath, SO THEY'RE ALREADY LYING ON GROUND WHEN WE RE-KILL THEM HERE, INSTEAD OF FALLING DOWN TO DIE AGAIN (SEAMLESSNESS)
// need to make sure player gets to their saved location before we kill them
void MakeDie(object oPC, location lLocation) {
    if (GetLocation(oPC) != lLocation) DelayCommand(0.1, MakeDie(oPC, lLocation));
    else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oPC);
}