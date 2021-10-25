#include "nwnx_events"
#include "inc_general"

void main()
{
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));
    int nSlot = StringToInt(NWNX_Events_GetEventData("SLOT"));

    // nFlatfooted can be any non-negative integer; it represents how many stacked flatfooted effects currently exist on the creature
    if (nSlot == INVENTORY_SLOT_BOOTS && GetLocalInt(OBJECT_SELF, "nFlatfooted")) {
        // creature isn't wearing their old boots anymore, remove ac loss from the item propeties of old boots
        int nSeconds = GetTaggedEffectDurationRemaining(OBJECT_SELF, "bootsdodgeacloss");
        RemoveAllTaggedEffects(OBJECT_SELF, "bootsdodgeacloss");

        // loop through the new boot's item properties and apply ac penalties to player for all the ac types listed on the newly equipped boots
        json jArmorClass = GetWornGearAC(INVENTORY_SLOT_BOOTS);
        if (jArmorClass != JsonNull()) {
            for(i = ITEM_PROPERTY_AC_BONUS; i++; i <= ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) {
                int nArmorClass = JsonGetInt(JsonObjectGet(jArmorClass, IntToString(i)));
                if (nArmorClass != 0) ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectACDecrease(nArmorClass), "bootsdodgeacloss"), OBJECT_SELF, IntToFloat(nSeconds));
            }
        }

        // remove the ac loss penalty icon from next to character's portrait
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, TagEffect(EffectACDecrease(1), "eTemp"), OBJECT_SELF, 0.1);
        RemoveAllTaggedEffects(OBJECT_SELF, "eTemp");
    }
}
