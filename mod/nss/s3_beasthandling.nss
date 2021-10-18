#include "inc_conopp"

void ExecuteSkillCheck(object oBeast, int nDC)
{
    // if beast has no handling variable set, we either forgot to set one for the resref, or the beast is deemed to powerful to serve as an associate
    if (nDC == 0) {
        SendMessageToPC(OBJECT_SELF, "This beast is either too ferocious or intelligent to properly handle.");
        return;
    }
    
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
        SetSkinInt(oBeast, "nBeastHandlingDC", nSkillValue + nRoll);
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

    // default handling dc will be lower than the check used to gain the creature as an associate; use highest value
    int nDC = 0;
    if (GetMaster(oBeast) != OBJECT_INVALID) {
        nDC = GetSkinInt(oBeast, "nBeastHandlingDC");
    } else {
        nDC = GetLocalInt(oBeast, "nBeastHandlingDC");
    }

    // have beast-handling check run at the end of "casting" wait time; we use cast instead of conj, because cast forces character to remain still wheras conj doesn't
    DelayCommand(StringToFloat(Get2DAString("spells", "CastTime", 840)) / 1000, ExecuteSkillCheck(oBeast, nDC));
}

// TODO:
//    - ObjectToJson the creature OnClientExit to spawn it in the exact same state OnClientEnter

/*
* Noteable TLK StrRefs
    7940: The target must be aware of you to use this ability.
        - Unknown; presumably too far from entity to use skill, but we run to it anyway; keep string?
    Unknown : Animal Empathy : *success* | Animal Empathy: *failure*
        - Executed by FloatingTextStringOnCreature()
    10484: <CUSTOM0> : <CUSTOM1> : *<CUSTOM2>* : (<CUSTOM3> <CUSTOM4> <CUSTOM5> = <CUSTOM6> vs. DC: <CUSTOM7>)
        - Master TLK string; SetTlkOverride() to "" may silence this string and unknown one above, only problem
        being that it may just enter an empty line rather than no line at all; needs testing
    63254: Dominated <CUSTOM0>.
        - Caused by a successful domaination; does a failed empathy check produce a different tlk string?
    61909: You are no longer dominating <CUSTOM0>.
        - Caused by resting to lose empathied companion
    8289: You may not use this skill for another <CUSTOM0> seconds(s).
        - Caused by trying to use empathy quicker than once every 3 seconds; could be useful, or block it

"Skill Check: Beast-Handling -> Deer (15 + 13 = 28 vs 30) -> Failure"

StrRef:10484 -> "<CUSTOM0> : <CUSTOM1> : *<CUSTOM2>* : (<CUSTOM3> <CUSTOM4> <CUSTOM5>
    = <CUSTOM6> vs. DC: <CUSTOM7>)"
    ~ "Take20 : Merom Rescher : Animal Empathy : *success* : "
StrRef:8289 -> "You may not use this skill for another <CUSTOM0> seconds(s)."
StrRef:61909 -> "You are no longer dominating <CUSTOM0>."
StrRef:63254 -> "Dominated <CUSTOM0>."
*/

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