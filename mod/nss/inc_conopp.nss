// ************************
// *      Prototypes      *
// ************************


// Sets a variable on a creature's skin item
void SetSkinInt(object oCreature, string sVariable, int nValue);

// Sets a variable on a creature's skin item
void SetSkinFloat(object oCreature, string sVariable,float fValue);

// Sets a variable on a creature's skin item
void SetSkinString(object oCreature, string sVariable,string sValue);

// Sets a variable on a creature's skin item
// Creates skin item on creature if it doesn't yet exist
// jValue type is already assumed to have been declared or set
void SetSkinJson(object oCreature, string sVariable, json jValue);

// *************************

// Gets a variable from a creature's skin item
int GetSkinInt(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
float GetSkinFloat(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
string GetSkinString(object oCreature, string sVariable);

// Gets a variable from a creature's skin item
json GetSkinJson(object oCreature, string sVariable);

// *************************

// Deletes a variable from a creature's skin item
void DeleteSkinInt(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinFloat(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinString(object oCreature, string sVariable);

// Deletes a variable from a creature's skin item
void DeleteSkinJson(object oCreature, string sVariable);

// *************************

// Gets a suitable <cXXX> token to use at the start of a block of colored text. Must be terminated by </c>
// - nRed - Red amount (0-255)
// - nGreen - Green amount (0-255)
// - nBlue - Blue amount (0-255)
string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255);


// *************************
// *       Functions       *
// *************************


void GiveCreatureSkin(object oCreature) {
    object oSkin = CreateItemOnObject("iit_cr_item_001", oCreature);
    SetDroppableFlag(oSkin, FALSE);
    AssignCommand(oCreature, ActionEquipItem(oSkin, INVENTORY_SLOT_CARMOUR));
}

void SetSkinInt(object oCreature, string sVariable, int nValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
        DelayCommand(0.1, SetSkinInt(oCreature, sVariable, nValue));
    }

    SetLocalInt(oSkin, sVariable, nValue);
}

void SetSkinFloat(object oCreature, string sVariable, float fValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalFloat(oSkin, sVariable, fValue));
}

void SetSkinString(object oCreature, string sVariable, string sValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalString(oSkin, sVariable, sValue));
}

void SetSkinJson(object oCreature, string sVariable, json jValue) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    DelayCommand(0.1, SetLocalJson(oSkin, sVariable, jValue));
}

// *************************

int GetSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalInt(oSkin, sVariable);
}

float GetSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalFloat(oSkin, sVariable);
}

string GetSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalString(oSkin, sVariable);
}

json GetSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (!GetIsObjectValid(oSkin)) {
        GiveCreatureSkin(oCreature);
    }

    return GetLocalJson(oSkin, sVariable);
}

// *************************
void DeleteSkinInt(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalInt(oSkin, sVariable);
    }
}

void DeleteSkinFloat(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalFloat(oSkin, sVariable);
    }
}

void DeleteSkinString(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalString(oSkin, sVariable);
    }
}

void DeleteSkinJson(object oCreature, string sVariable) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCreature);
    if (GetIsObjectValid(oSkin)) {
        DeleteLocalJson(oSkin, sVariable);
    }
}

// *************************

const string COLOR_TOKEN = "\x01\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

string GetColorCode(int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">";
}