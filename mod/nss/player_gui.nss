#include "inc_general"
#include "nwnx_object"
#include "nwnx_area"

sqlquery sqlQuery;

void MakeDie(object oPC, location lLocation);

void main()
{
    object oPC = GetLastGuiEventPlayer();

    switch (GetLastGuiEventType()) {
        case GUIEVENT_AREA_LOADSCREEN_FINISHED: {
            if (NWNX_Object_PeekUUID(oPC) != "") { // apply to existing players
                // teleport his companions to him
                object oPartyMember = GetFirstFactionMember(oPC, FALSE);
                while (GetIsObjectValid(oPartyMember)) {
                    if (GetMaster(oPartyMember) == oPC) {
                        AssignCommand(oPartyMember, ClearAllActions());
                        AssignCommand(oPartyMember, JumpToLocation(GetLocation(oPC)));
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
                    // area is scheduled for deletion & first player to enter area -> respawn serliazed creatures
                    object oArea = GetObjectByUUID(SqlGetString(sqlQuery, 0));
                    if (oArea == GetArea(oPC) && NWNX_Area_GetNumberOfPlayersInArea(oArea) == 1) {
                        json jaCreatures = SqlGetJson(sqlQuery, 1);
                        for (i = 0; i < JsonGetLength(jaCreatures); i++) {
                            // this whole block for AddToArea can probably be wrapped for convenience so it takes a location instead of just area/position
                            object oCreature = NWNX_Object_Deserialize(JsonGetString(JsonObjectGet(JsonArrayGet(jaCreatures, i), "serialization")));

                            json joPosition = JsonObjectGet(JsonArrayGet(jaCreatures, i), "position");
                            float x = JsonGetFloat(JsonObjectGet(joPosition, "x"));
                            float y = JsonGetFloat(JsonObjectGet(joPosition, "y"));
                            float z = JsonGetFloat(JsonObjectGet(joPosition, "z"));
                            vector vPosition = Vector(x, y, z);

                            NWNX_Object_AddToArea(oCreature, oArea, vPosition); // TODO - TEST OUT (DE)SERIALIZATION AND PLACEMENT BEFORE ATTEMPTING IT AREA-WIDE & CROSS-TRANSTION

                            // nwnx can add the creature to area, but we need to force it to face correct direction after spawning in
                            AssignCommand(oCreature, SetFacing(JsonGetFloat(JsonObjectGet(JsonArrayGet(jaCreatures, i), "facing"))));
                        }

                        bSerialized = TRUE;
                    }
                }

                if (!bSerialized) {
                    // TODO - SPAWN ALL CREATURES WITH SPECIAL ENCOUNTER & RANDOMIZATION LOGIC
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
}

// // TODO - SEE IF WE CAN EffectFreeze THE PLAYER OnDeath, SO THEY'RE ALREADY LYING ON GROUND WHEN WE RE-KILL THEM HERE, INSTEAD OF FALLING DOWN TO DIE AGAIN (SEAMLESSNESS)
// // need to make sure player gets to their saved location before we kill them
// void MakeDie(object oPC, location lLocation) {
//     if (GetLocation(oPC) != lLocation) DelayCommand(0.1, MakeDie(oPC, lLocation));
//     else ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), oPC);
// }