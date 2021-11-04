#include "nwnx_events"
#include "inc_general"

void main()
{
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));
    int nSlot = StringToInt(NWNX_Events_GetEventData("SLOT"));

    // nFlatfooted can be any non-negative integer; it represents how many stacked flatfooted effects currently exist on the creature
    if (GetLocalInt(OBJECT_SELF, "bFlatfooted") && nSlot == INVENTORY_SLOT_BOOTS) {
        // creature isn't wearing their old boots anymore, remove ac loss from the item propeties of old boots
        int nSeconds = GetTaggedEffectDurationRemaining(OBJECT_SELF, "flatfooted_dex");
        RemoveAllTaggedEffects(OBJECT_SELF, "flatfooted_ac");
        FlatfootCreature(OBJECT_SELF, IntToFloat(nSeconds));
    }
}
