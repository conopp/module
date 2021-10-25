#include "nw_inc_gff"
#include "inc_general"

void main()
{
    object oPC = GetLastUsedBy();
    WriteTimestampedLogEntry(JsonDump(GetWornGearAC(INVENTORY_SLOT_BOOTS), 4));
}