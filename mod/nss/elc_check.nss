#include "nwnx_elc"

void main()
{
    int nType = NWNX_ELC_GetValidationFailureType();
    int nSubType = NWNX_ELC_GetValidationFailureSubType();
    object oItem = NWNX_ELC_GetValidationFailureItem();
    int nLevel = NWNX_ELC_GetValidationFailureLevel();
    int nSkillID = NWNX_ELC_GetValidationFailureSkillID();
    int nFeatID = NWNX_ELC_GetValidationFailureFeatID();
    int nSpellID = NWNX_ELC_GetValidationFailureSpellID();

    WriteTimestampedLogEntry("nType: "+IntToString(nType));
    WriteTimestampedLogEntry("nSubType: "+IntToString(nSubType));
    WriteTimestampedLogEntry("nSkillID: "+IntToString(nSkillID));
    WriteTimestampedLogEntry("nFeatID: "+IntToString(nFeatID));
    WriteTimestampedLogEntry("nSpellID: "+IntToString(nSpellID));

    switch (NWNX_ELC_GetValidationFailureType()) {
        case NWNX_ELC_VALIDATION_FAILURE_TYPE_ITEM:
            if (oItem == GetItemInSlot(INVENTORY_SLOT_CARMOUR)) {
                NWNX_ELC_SkipValidationFailure();
            }
    }
}