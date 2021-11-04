#include "inc_general"
#include "nwnx_object"

sqlquery sqlQuery;

void MakeDie(object oPC, location lLocation);

void main()
{
    object oPC = GetLastGuiEventPlayer();

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED:
            if (NWNX_Object_PeekUUID(oPC) != "") { // apply to existing players
                if (!GetLocalInt(oPC, "bWentThroughJoinLoop")) {
                    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
                        "SELECT location, health " +
                        "FROM characters " +
                        "WHERE uuid=@uuid "
                    );
                    SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
                    SqlStep(sqlQuery);
                    location lLocation = GetLocationFromJson(SqlGetJson(sqlQuery, 0));
                    int nHP = SqlGetInt(sqlQuery, 1);

                    AssignCommand(oPC, JumpToLocation(lLocation));
                    // cannot set hitpoints to kill a PC; must be done manually
                    if (nHP > 0) SetCurrentHitPoints(oPC, nHP);
                    else MakeDie(oPC, lLocation);

                    SetLocalInt(oPC, "bWentThroughJoinLoop", TRUE);
                } else { // player finished transitioning
                    // teleport his companions to him
                    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
                    while (GetIsObjectValid(oPartyMember)) {
                        if (GetMaster(oPartyMember) == oPC) {
                            AssignCommand(oPartyMember, ClearAllActions());
                            AssignCommand(oPartyMember, JumpToObject(oPC));
                        }
                        oPartyMember = GetNextFactionMember(oPC, FALSE);
                    }

                    // if area is scheduled for deletion, unserialize creatures to spawn; otherwise, spawn new creatures
                    int bSerialized = FALSE;
                    sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
                        "SELECT uuid,creatures " +
                        "FROM _areacleanup "
                    );
                    while (SqlStep(sqlQuery)) {
                        // area is scheduled for deletion; respawn the serliazed creatures
                        if (GetObjectByUUID(SqlGetString(sqlQuery, 0)) != GetArea(oPC)) continue;

                        // TODO -> json jaCreatures = SqlGetJson(sqlquery, 1); & CreateObject THEM ALL
                        bSerialized = TRUE;
                    }

                    if (!bSerialized) {
                        // TODO - SPAWN ALL CREATURES WITH SPECIAL ENCOUNTER & RANDOMIZATION LOGIC
                    }
                }
            } else { // apply to new players
                // replaces row in the case that the character's uuid has been deleted from .bic, but his row still exists in table
                sqlQuery = SqlPrepareQueryCampaign("conopp", "" +
                    "REPLACE INTO characters (uuid, cdkey, name, creation) " +
                    "VALUES (@uuid, @cdkey, @name, strftime('%s','now')) "
                );
                SqlBindString(sqlQuery, "@uuid", GetObjectUUID(oPC));
                SqlBindString(sqlQuery, "@cdkey", GetPCPublicCDKey(oPC));
                SqlBindString(sqlQuery, "@name", GetName(oPC));
                SqlStep(sqlQuery);
            }
    }
}

// TODO - SEE IF WE CAN EffectFreeze THE PLAYER OnDeath, SO THEY'RE ALREADY LYING ON GROUND WHEN WE RE-KILL THEM HERE, INSTEAD OF FALLING DOWN TO DIE AGAIN (SEAMLESSNESS)
// need to make sure player gets to their saved location before we kill them
void MakeDie(object oPC, location lLocation) {
    if (GetLocation(oPC) != lLocation) DelayCommand(0.1, MakeDie(oPC, lLocation));
    else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oPC);
}