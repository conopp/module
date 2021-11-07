#include "inc_general"
#include "nwnx_creature"

void SendAllAssociatesToPlayer(object oPC, object oArea);

// system assumes exactly 1 transition and 1 waypoint; any additional placed down will be ignored as if they don't exist
void main()
{
    object oPC = GetLastUsedBy();
    object oWaypoint = GetObjectByTag(GetTag(OBJECT_SELF));
    if (oWaypoint == OBJECT_SELF) {
        oWaypoint = GetObjectByTag(GetTag(OBJECT_SELF), 1);
    }

    // change the texture of all the transitions that lead to the area we're trying to go to
    object oArea = GetArea(oWaypoint);
    object oObject = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oObject)) {
        if (GetObjectType(oObject) == OBJECT_TYPE_WAYPOINT) {
            // trans and waypoint have same tag; make sure we change the texture of the correct object
            object oTrans = GetObjectByTag(GetTag(oObject));
            if (oTrans == OBJECT_SELF) oTrans = GetObjectByTag(GetTag(oObject), 1);
            ReplaceObjectTexture(oTrans, "trans_blu", "trans_grn");
        }
        oObject = GetNextObjectInArea(oArea);
    }

    AssignCommand(oPC, ClearAllActions());
    AssignCommand(oPC, JumpToLocation(GetLocation(oWaypoint)));

    // send all the associates to the player
    object oPartyMember = GetFirstFactionMember(oPC, FALSE);
    while (GetIsObjectValid(oPartyMember)) {
        if (GetMaster(oPartyMember) == oPC) {
            AssignCommand(oPartyMember, ClearAllActions());
            // if player left area, send associates temporarily to limbo and teleport them to player when he loads map; otherwise just teleport them to player
            if (GetArea(oPC) == oArea) AssignCommand(oPartyMember, JumpToLocation(GetLocation(oPC)));
            else AssignCommand(oPartyMember, NWNX_Creature_JumpToLimbo(oPartyMember));
        }
        oPartyMember = GetNextFactionMember(oPC, FALSE);
    }
}