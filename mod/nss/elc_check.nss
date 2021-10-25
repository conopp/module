#include "nwnx_elc"
#include "nwnx_object"

void main()
{
    int nType = NWNX_ELC_GetValidationFailureType();
    int nSubType = NWNX_ELC_GetValidationFailureSubType();
    int nLevel = NWNX_ELC_GetValidationFailureLevel();
    int nSkillID = NWNX_ELC_GetValidationFailureSkillID();
    int nFeatID = NWNX_ELC_GetValidationFailureFeatID();
    int nSpellID = NWNX_ELC_GetValidationFailureSpellID();

    WriteTimestampedLogEntry("nType: "+IntToString(nType));
    WriteTimestampedLogEntry("nSubType: "+IntToString(nSubType));
    WriteTimestampedLogEntry("nSkillID: "+IntToString(nSkillID));
    WriteTimestampedLogEntry("nFeatID: "+IntToString(nFeatID));
    WriteTimestampedLogEntry("nSpellID: "+IntToString(nSpellID));

    if (NWNX_ELC_GetValidationFailureType() == NWNX_ELC_VALIDATION_FAILURE_TYPE_ITEM) {
        object oItem = NWNX_ELC_GetValidationFailureItem();
        if (oItem == GetItemInSlot(INVENTORY_SLOT_CARMOUR)) {
            NWNX_ELC_SkipValidationFailure();
        }
        // if is a non-hide item, flag player & item and destroy it & recreate it in player's inventory w/ warning
    }

    // elc check should only be effective on first character's login; do we need to check after levelup too?
    if (NWNX_Object_PeekUUID(OBJECT_SELF) != "") {
        NWNX_ELC_SkipValidationFailure();
    }
}