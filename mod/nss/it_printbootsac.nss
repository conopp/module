#include "nw_inc_gff"
#include "inc_general"

void main()
{
    object oPC = GetLastUsedBy();

    FlatfootCreature(oPC, 5.0);

    // object oItem = GetItemInSlot(INVENTORY_SLOT_BOOTS, oPC);
    // if (!GetIsObjectValid(oItem)) return;

    // itemproperty ipProp = GetFirstItemProperty(oItem);
    // while (GetIsItemPropertyValid(ipProp)) {
    //     int nType = GetItemPropertyType(ipProp);
    //     int nSubtype = GetItemPropertySubType(ipProp);
    //     int nValue = GetItemPropertyCostTableValue(ipProp);

    //     if (nType == ITEM_PROPERTY_AC_BONUS) {
    //         SendMessageToPC(oPC, "AC Type: vs. All");
    //         SendMessageToPC(oPC, "AC Plus: " + IntToString(nValue));
    //     } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_ALIGNMENT_GROUP) {
    //         string sSubtype = "";
    //         if (nSubtype == 1) sSubtype = "Neutral";
    //         else if (nSubtype == 2) sSubtype = "Lawful";
    //         else if (nSubtype == 3) sSubtype = "Chaotic";
    //         else if (nSubtype == 4) sSubtype = "Good";
    //         else if (nSubtype == 5) sSubtype = "Evil";
    //         SendMessageToPC(oPC, "AC Type: vs. Alignment Group");
    //         SendMessageToPC(oPC, "AC SubT: vs. " + sSubtype);
    //         SendMessageToPC(oPC, "AC Plus: " + IntToString(nValue));
    //     } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_DAMAGE_TYPE) {
    //         string sSubtype = "";
    //         if (nSubtype == 0) sSubtype = "Bludgeoning";
    //         else if (nSubtype == 1) sSubtype = "Piercing";
    //         else if (nSubtype == 2) sSubtype = "Slashing";
    //         SendMessageToPC(oPC, "AC Type: vs. Damage");
    //         SendMessageToPC(oPC, "AC SubT: vs. " + sSubtype);
    //         SendMessageToPC(oPC, "AC Plus: " + IntToString(nValue));
    //     } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_RACIAL_GROUP) {
    //         SendMessageToPC(oPC, "AC Type: vs. Damage");
    //         SendMessageToPC(oPC, "AC SubT: vs. RowId: " + IntToString(nSubtype));
    //         SendMessageToPC(oPC, "AC Plus: " + IntToString(nValue));
    //     } else if (nType == ITEM_PROPERTY_AC_BONUS_VS_SPECIFIC_ALIGNMENT) {
    //         string sSubtype = "";
    //         if (nSubtype == 0) sSubtype = "Lawful Good";
    //         else if (nSubtype == 1) sSubtype = "Lawful Neutral";
    //         else if (nSubtype == 2) sSubtype = "Lawful Evil";
    //         else if (nSubtype == 3) sSubtype = "Neutral Good";
    //         else if (nSubtype == 4) sSubtype = "True Neutral";
    //         else if (nSubtype == 5) sSubtype = "Neutral Evil";
    //         else if (nSubtype == 6) sSubtype = "Chaotic Good";
    //         else if (nSubtype == 7) sSubtype = "Chaotic Neutral";
    //         else if (nSubtype == 8) sSubtype = "Chaotic Evil";
    //         SendMessageToPC(oPC, "AC Type: vs. Specific Alignment");
    //         SendMessageToPC(oPC, "AC SubT: vs. " + sSubtype);
    //         SendMessageToPC(oPC, "AC Plus: " + IntToString(nValue));
    //     }

    //    ipProp = GetNextItemProperty(oItem);
    //}
}