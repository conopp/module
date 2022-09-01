// ************************
// *       Includes       *
// ************************

#include "inc_general"
#include "nw_inc_nui"

// ************************
// *      Variables       *
// ************************

const int DEBUG_NUI = TRUE;

// ************************
// *      Prototypes      *
// ************************

void NuiHandleEvent(object oPC, int nToken, string sWindowID, string sEvent, string sElement, int nIndex, json jPayload);

void NuiOpenChargen(object oPC);
void NuiOpenInventory(object oPC);
void NuiOpenStorage(object oPC);
void NuiOpenMarket(object oPC);

json NuiRectCenter(object oPC, float fWidth, float fHeight);

// *************************
// *       Functions       *
// *************************

// placeholder for NuiOpenChargen
void RunTest(object oPC) {
    json jaRow1 = JsonArray();
    json jaRow2 = JsonArray();
    json jaRow3 = JsonArray();
    json jaRow4 = JsonArray();

    json jaCol1 = JsonArray();
    json jaCol2 = JsonArray();
    json jaCol3 = JsonArray();
    json jaCol4 = JsonArray();

    
}

void NuiHandleEvent(object oPC, int nToken, string sWindowID, string sEvent, string sElement, int nIndex, json jPayload) {
    if (sWindowID == "inventory") {

    } else if (sWindowID == "storage") {

    } else if (sWindowID == "market") {

    }
}

json EquipmentSlot(string sID, string sIcon, string sTooltip, float xSize=40.0, float ySize=40.0) {
    json jSlot = jNull;
    jSlot = NuiId(jSlot, sID);
    jSlot = NuiButtonImage(JsonString(sIcon));
    jSlot = NuiTooltip(jSlot, JsonString(sTooltip));
    jSlot = NuiWidth(jSlot, xSize);
    jSlot = NuiHeight(jSlot, ySize);
    return jSlot;
}

void NuiOpenInventory(object oPC) {
    // bags properties
    //   name
    //   slots
    //   weight_reduction

    json jWindow = jNull; json jEquipment = jNull;

    jWindow = JsonArray();

    jEquipment = JsonArray();
        json jOffensive = JsonArray();
            jOffensive = JsonArrayInsert(jOffensive, EquipmentSlot("slot_mainhand", "ir_use", "Mainhand"));
            jOffensive = JsonArrayInsert(jOffensive, EquipmentSlot("slot_offhand", "ir_use", "Offhand"));
            jOffensive = JsonArrayInsert(jOffensive, EquipmentSlot("slot_ammunition", "ir_use", "Ammunition", 30.0, 30.0));
        jEquipment = JsonArrayInsert(jEquipment, NuiRow(jOffensive));
        jEquipment = JsonArrayInsert(jEquipment, NuiSpacer());
        json jAppearance = JsonArray();
            jAppearance = JsonArrayInsert(jAppearance, EquipmentSlot("slot_helmet", "ir_use", "Helmet"));
            jAppearance = JsonArrayInsert(jAppearance, EquipmentSlot("slot_armor", "ir_use", "Armor"));
            jAppearance = JsonArrayInsert(jAppearance, EquipmentSlot("slot_cloak", "ir_use", "Cloak"));
        jEquipment = JsonArrayInsert(jEquipment, NuiRow(jAppearance));
    jWindow = JsonArrayInsert(jWindow, NuiRow(jEquipment));

    jEquipment = JsonArray();
        json jAccessories = JsonArray();
            jAccessories = JsonArrayInsert(jAccessories, EquipmentSlot("slot_amulet", "ir_use", "Amulet"));
            jAccessories = JsonArrayInsert(jAccessories, EquipmentSlot("slot_ring1", "ir_use", "Ring"));
            jAccessories = JsonArrayInsert(jAccessories, EquipmentSlot("slot_ring2", "ir_use", "Ring"));
        jEquipment = JsonArrayInsert(jEquipment, NuiRow(jAccessories));
        jEquipment = JsonArrayInsert(jEquipment, NuiSpacer());
        json jDefensive = JsonArray();
            jDefensive = JsonArrayInsert(jDefensive, EquipmentSlot("slot_gloves", "ir_use", "Gloves"));
            jDefensive = JsonArrayInsert(jDefensive, EquipmentSlot("slot_belt", "ir_use", "Belt"));
            jDefensive = JsonArrayInsert(jDefensive, EquipmentSlot("slot_boots", "ir_use", "Boots"));
        jEquipment = JsonArrayInsert(jEquipment, NuiRow(jDefensive));
    jWindow = JsonArrayInsert(jWindow, NuiRow(jEquipment));

    jWindow = NuiWindow(NuiCol(jWindow), JsonString("Inventory"), NuiBind("geometry"),
        JsonBool(FALSE), JsonBool(FALSE), JsonBool(TRUE), JsonBool(FALSE), JsonBool(TRUE));
    int nToken = NuiCreate(oPC, jWindow, "inventory");

    NuiSetBind(oPC, nToken, "geometry", NuiRectCenter(oPC, 300.0, 450.0));
}

void NuiOpenStorage(object oPC) {}

void NuiOpenMarket(object oPC) {}

json NuiRectCenter(object oPC, float fWindowWidth, float fWindowHeight) {
    float fScale = IntToFloat(GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_SCALE)) / 100.0;
    float fScreenWidth = IntToFloat(GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_WIDTH));
    float fScreenHeight = IntToFloat(GetPlayerDeviceProperty(oPC, PLAYER_DEVICE_PROPERTY_GUI_HEIGHT));
    float fPosX = (fScreenWidth / 2) - ((fWindowWidth / 2) * fScale);
    float fPosY = (fScreenHeight / 2) - ((fWindowHeight / 2) * fScale);

    return NuiRect(fPosX, fPosY, fWindowWidth, fWindowHeight);
}
