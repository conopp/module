#include "nwnx_events"
#include "inc_general"

void main()
{
    object oItem = StringToObject(NWNX_Events_GetEventData("ITEM"));

    // remove any ac loss imposed from boots' ac being flatfooted; the feet are now naked
    if (GetBaseItemType(oItem) == BASE_ITEM_BOOTS) {
        RemoveAllTaggedEffects(OBJECT_SELF, "flatfooted_ac");
    }
}
