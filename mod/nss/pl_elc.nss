#include "nwnx_elc"

void main()
{
    int nType = NWNX_ELC_GetValidationFailureType();
    int nSubtype = NWNX_ELC_GetValidationFailureSubType();

    object oItem = NWNX_ELC_GetValidationFailureItem();
    int nLevel = NWNX_ELC_GetValidationFailureLevel();
    int nSkill = NWNX_ELC_GetValidationFailureSkillID();
    int nFeat = NWNX_ELC_GetValidationFailureFeatID();
    int nSpell = NWNX_ELC_GetValidationFailureSpellID();

    NWNX_ELC_SkipValidationFailure();
}