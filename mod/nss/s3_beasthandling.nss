#include "inc_general"

void ExecuteSkillCheck(object oBeast)
{
    // if you stand in range of beast-handling action/spell, click far away, queue the action, then when you reach movement destination, you'll execute the action from safe distance; this is a fix for that
    if (GetDistanceToObject(oBeast) >= 5.0) {
        SendMessageToPC(OBJECT_SELF, "You're too far from the beast to attempt to handle it.");
        return;
    }

    // default handling dc will be lower than the check used to gain the creature as an associate; use highest value
    string sFeed = GetLocalString(oBeast, "bh_feed");
    int nDC = 0;
    if (GetMaster(oBeast) != OBJECT_INVALID) {
        nDC = GetSkinInt(oBeast, "bh_dc");
    } else {
        nDC = GetLocalInt(oBeast, "bh_dc");
    }

    // if beast has no handling variables set, we either forgot to set one for the resref, or the beast is deemed to powerful to serve as an associate
    if (nDC == 0 || sFeed == "") {
        SendMessageToPC(OBJECT_SELF, "This beast is either too ferocious or intelligent to properly handle.");
        return;
    }

    // take the feed item from the player for attempting to handle the beast
    object oFeed = GetItemPossessedBy(OBJECT_SELF, sFeed);
    if (oFeed == OBJECT_INVALID || HasItemEquipped(oFeed) != -1) {
        SendMessageToPC(OBJECT_SELF, "You don't possess the feed item this beast requires.");
        return;
    }
    DestroyObject(oFeed);

    // construct rolls & feedback
    int nSkillValue = GetSkillRank(SKILL_ANIMAL_EMPATHY);
    int nRoll = d20();
    int bSuccess = (nSkillValue + nRoll >= nDC) ? TRUE : FALSE;

    // execute feedback -> ex: "Skill Check : Beast-Handling -> Buffalo (15 + 13 = 28 vs 30) -> Failure"
    SendMessageToPC(OBJECT_SELF, ((bSuccess) ? GetColorCode(32, 254, 32) : GetColorCode(204, 32, 32)) + "Skill Check : Beast-Handling -> " + GetName(oBeast) + " (" + IntToString(nSkillValue) + " + " + IntToString(nRoll) + " = " + IntToString(nSkillValue + nRoll) + " vs " + IntToString(nDC) + ")</c>");

    if (bSuccess) {
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectDominated(), oBeast);

        // give a mind-affecting animation to the handler and beast to show the two are now connected
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), OBJECT_SELF);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DOMINATE_S), oBeast);

        // others trying to handle an already-handled beast will have to beat the roll the current master originally made in order to become the new master
        SetSkinInt(oBeast, "bh_dc", nSkillValue + nRoll);
    }
}

void main()
{
    object oBeast = GetSpellTargetObject();

    // inform the player they can't try to beast-handle their own beast
    if (GetMaster(oBeast) == OBJECT_SELF) {
        SendMessageToPC(OBJECT_SELF, "You already have control over this beast.");
        return;
    }

    // flatfoot the player while trying to handle a beast for duration of CastTime in spells.2da
    FlatfootCreature(OBJECT_SELF, StringToFloat(Get2DAString("spells", "CastTime", FEAT_BEASTHANDLING)) / 1000, TRUE);

    // have beast-handling check run at the end of "casting" wait time; we use cast instead of conj, because cast forces character to remain still wheras conj doesn't
    DelayCommand(StringToFloat(Get2DAString("spells", "CastTime", FEAT_BEASTHANDLING)) / 1000, ExecuteSkillCheck(oBeast));
}

/*
// object oHenchman = GetAssociate(ASSOCIATE_TYPE_HENCHMAN);
// if (oHenchman != OBJECT_INVALID) {
//     // return beast to default state before handling
//     ActionDoCommand(RemoveHenchman(OBJECT_SELF, oHenchman));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, GetSkinString(oBeast, "eOnHeartbeat"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_NOTICE, GetSkinString(oBeast, "eOnNotice"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, GetSkinString(oBeast, "eOnSpellCastAt"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, GetSkinString(oBeast, "eOnMeleeAttacked"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DAMAGED, GetSkinString(oBeast, "eOnDamaged"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DISTURBED, GetSkinString(oBeast, "eOnDisturbed"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, GetSkinString(oBeast, "eOnEndCombatRound"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, GetSkinString(oBeast, "eOnDialogue"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, GetSkinString(oBeast, "eOnSpawnIn"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_RESTED, GetSkinString(oBeast, "eOnRested"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DEATH, GetSkinString(oBeast, "eOnDeath"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, GetSkinString(oBeast, "eOnUserDefined"));
//     SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, GetSkinString(oBeast, "eOnBlockedByDoor"));
//     AssignCommand(oHenchman, ClearAllActions());
// }

// // save scripts to return to beast when it's no longer a henchman
// SetSkinString(oBeast, "eOnHeartbeat", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT));
// SetSkinString(oBeast, "eOnNotice", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_NOTICE));
// SetSkinString(oBeast, "eOnSpellCastAt", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT));
// SetSkinString(oBeast, "eOnMeleeAttacked", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED));
// SetSkinString(oBeast, "eOnDamaged", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DAMAGED));
// SetSkinString(oBeast, "eOnDisturbed", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DISTURBED));
// SetSkinString(oBeast, "eOnEndCombatRound", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND));
// SetSkinString(oBeast, "eOnDialogue", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DIALOGUE));
// SetSkinString(oBeast, "eOnSpawnIn", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN));
// SetSkinString(oBeast, "eOnRested", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_RESTED));
// SetSkinString(oBeast, "eOnDeath", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DEATH));
// SetSkinString(oBeast, "eOnUserDefined", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT));
// SetSkinString(oBeast, "eOnBlockedByDoor", GetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR));

// // assign the beast the new master with relevant scripts
// ActionDoCommand(AddHenchman(OBJECT_SELF, oBeast));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, Get2DAString("statescripts", "SCRIPTNAME", 10));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_NOTICE, Get2DAString("statescripts", "SCRIPTNAME", 11));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPELLCASTAT, Get2DAString("statescripts", "SCRIPTNAME", 12));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_MELEE_ATTACKED, Get2DAString("statescripts", "SCRIPTNAME", 13));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DAMAGED, Get2DAString("statescripts", "SCRIPTNAME", 14));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DISTURBED, Get2DAString("statescripts", "SCRIPTNAME", 15));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_END_COMBATROUND, Get2DAString("statescripts", "SCRIPTNAME", 16));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DIALOGUE, Get2DAString("statescripts", "SCRIPTNAME", 17));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_SPAWN_IN, Get2DAString("statescripts", "SCRIPTNAME", 18));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_RESTED, Get2DAString("statescripts", "SCRIPTNAME", 19));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_DEATH, Get2DAString("statescripts", "SCRIPTNAME", 20));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_USER_DEFINED_EVENT, Get2DAString("statescripts", "SCRIPTNAME", 21));
// SetEventScript(oBeast, EVENT_SCRIPT_CREATURE_ON_BLOCKED_BY_DOOR, Get2DAString("statescripts", "SCRIPTNAME", 22));
*/