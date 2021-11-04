#include "nwnx_creature"

void main()
{
    object oPC = GetLastUsedBy();
    object oWaypoint = GetObjectByTag(GetTag(OBJECT_SELF));

    // change the texture of all the transitions that lead to the area we're trying to go to
    object oArea = GetArea(oWaypoint);
    object oObject = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oObject)) {
        if (GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT) {
            ReplaceObjectTexture(GetObjectByTag(GetTag(oObject)), "trans_blu", "trans_grn");
        }
        oObject = GetNextObjectInArea(oArea);
    }

    AssignCommand(oPC, JumpToObject(oWaypoint)); // TODO - MAY NEED JumpToLocation IF WE'RE NOT FACING SAME DIRECTION AS THE WAYPOINT

    // send all the associates of the player to limbo, then in player_gui, teleport them to the player
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMember)) {
        if (GetMaster(oPartyMember) == oPC) {
            AssignCommand(oPartyMember, ClearAllActions());
            AssignCommand(oPartyMember, NWNX_Creature_JumpToLimbo(oPartyMember));
        }
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
}