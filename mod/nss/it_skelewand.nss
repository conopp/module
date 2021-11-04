#include "nwnx_creature"

const int MOD_STR = 2;
const int MOD_DEX = 0;
const int MOD_CON = 2;
const int MOD_WIS = 0;
const int MOD_INT = 0;
const int MOD_CHA = 0;

void SetStats(object oTarget) {
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_STRENGTH, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_STRENGTH) + MOD_STR);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_DEXTERITY, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_DEXTERITY) + MOD_DEX);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_CONSTITUTION, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_CONSTITUTION) + MOD_CON);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_WISDOM, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_WISDOM) + MOD_WIS);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_INTELLIGENCE, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_INTELLIGENCE) + MOD_INT);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_CHARISMA, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_CHARISMA) + MOD_CHA);
}

void UndoStats(object oTarget) {
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_STRENGTH, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_STRENGTH) - MOD_STR);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_DEXTERITY, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_DEXTERITY) - MOD_DEX);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_CONSTITUTION, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_CONSTITUTION) - MOD_CON);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_WISDOM, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_WISDOM) - MOD_WIS);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_INTELLIGENCE, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_INTELLIGENCE) - MOD_INT);
    NWNX_Creature_SetRawAbilityScore(oTarget, ABILITY_CHARISMA, NWNX_Creature_GetRawAbilityScore(oTarget, ABILITY_CHARISMA) - MOD_CHA);
}

void main()
{
    // object oDM = GetItemActivator();
    // object oTarget = GetItemActivatedTarget();
    object oTarget = GetLastUsedBy();
    if (!GetIsPC(oTarget) || GetIsDM(oTarget)) return;

    // unshift the shifted so we can modify their appearance correctly
    effect eEffect = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEffect)) {
        if (GetEffectType(eEffect) == EFFECT_TYPE_POLYMORPH) {
            RemoveEffect(oTarget, eEffect);
        }
        eEffect = GetNextEffect(oTarget);
    }

    int nApprType = GetAppearanceType(oTarget);

    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oTarget);
    if (!GetIsObjectValid(oSkin)) return;

    // save original appearance for cycling back to it later
    if (nApprType == APPEARANCE_TYPE_DWARF
     || nApprType == APPEARANCE_TYPE_ELF
     || nApprType == APPEARANCE_TYPE_GNOME
     || nApprType == APPEARANCE_TYPE_HALFLING
     || nApprType == APPEARANCE_TYPE_HALF_ELF
     || nApprType == APPEARANCE_TYPE_HALF_ORC
     || nApprType == APPEARANCE_TYPE_HUMAN) {
        // save creature's original appearance
        SetLocalInt(oSkin, "skelewand_appr", nApprType);
        SetStats(oTarget);
    }

    // default statement is ran if creature is originally polymorphed; skelewand_appr and everything works fine regardless of polymorph
    switch (nApprType) {
        case APPEARANCE_TYPE_SKELETON_COMMON: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_WARRIOR);
        case APPEARANCE_TYPE_SKELETON_WARRIOR: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_WARRIOR_1);
        case APPEARANCE_TYPE_SKELETON_WARRIOR_1: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_WARRIOR_2);
        case APPEARANCE_TYPE_SKELETON_WARRIOR_2: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_MAGE);
        case APPEARANCE_TYPE_SKELETON_MAGE: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_PRIEST);
        case APPEARANCE_TYPE_SKELETON_PRIEST: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_CHIEFTAIN);
        case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
            SetCreatureAppearanceType(oTarget, GetLocalInt(oSkin, "skelewand_appr"));
            UndoStats(oTarget);
        default: SetCreatureAppearanceType(oTarget, APPEARANCE_TYPE_SKELETON_COMMON);
    }
    // 0, APPEARANCE_TYPE_DWARF
    // 1, APPEARANCE_TYPE_ELF
    // 2, APPEARANCE_TYPE_GNOME
    // 3, APPEARANCE_TYPE_HALFLING
    // 4, APPEARANCE_TYPE_HALF_ELF
    // 5, APPEARANCE_TYPE_HALF_ORC
    // 6, APPEARANCE_TYPE_HUMAN

    // 62, APPEARANCE_TYPE_SKELETON_PRIEST
    // 63, APPEARANCE_TYPE_SKELETON_COMMON
    // 70, APPEARANCE_TYPE_SKELETON_WARRIOR_1
    // 71, APPEARANCE_TYPE_SKELETON_WARRIOR_2
    // 148, APPEARANCE_TYPE_SKELETON_MAGE
    // 150, APPEARANCE_TYPE_SKELETON_WARRIOR
    // 182, APPEARANCE_TYPE_SKELETON_CHIEFTAIN
}