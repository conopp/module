// ************************
// *       Includes       *
// ************************

#include "inc_general"
#include "inc_sqlite"
#include "nwnx_creature"

// ************************
// *      Variables       *
// ************************

const int DEBUG_SKIN = TRUE;

const string PL_LOCATION = MOD_NAME + "_location"; // location
const string PL_HITPOINTS = MOD_NAME + "_hitpoints"; // int
const string PL_EFFECTS = MOD_NAME + "_effects"; // json array
const string PL_SPELLUSES = MOD_NAME + "_spelluses"; // json array
const string PL_BAGS = MOD_NAME + "_bags"; // json array
const string PL_COMPANION = MOD_NAME + "_companion"; // unknown

// ************************
// *      Prototypes      *
// ************************

object GiveCreatureSkin(object oCre);

void SetSkinInt(object oCre, string sVar, int nVal);
void SetSkinFloat(object oCre, string sVar, float fVal);
void SetSkinString(object oCre, string sVar, string sVal);
void SetSkinLocation(object oCre, string sVar, location lVal);
void SetSkinJson(object oCre, string sVar, json jVal);

int GetSkinInt(object oCre, string sVar);
float GetSkinFloat(object oCre, string sVar);
string GetSkinString(object oCre, string sVar);
location GetSkinLocation(object oCre, string sVar);
json GetSkinJson(object oCre, string sVar);

void DelSkinInt(object oCre, string sVar);
void DelSkinFloat(object oCre, string sVar);
void DelSkinString(object oCre, string sVar);
void DelSkinLocation(object oCre, string sVar);
void DelSkinJson(object oCre, string sVar);

// *************************
// *       Functions       *
// *************************

object GiveCreatureSkin(object oCre) {
    object oSkin = CreateItemOnObject("x3_it_pchide", oCre);
    NWNX_Creature_RunEquip(oCre, oSkin, INVENTORY_SLOT_CARMOUR);
    return oSkin;
}

void SetSkinInt(object oCre, string sVar, int nVal) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    SetLocalInt(oSkin, sVar, nVal);
}

void SetSkinFloat(object oCre, string sVar, float fVal) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    SetLocalFloat(oSkin, sVar, fVal);
}

void SetSkinString(object oCre, string sVar, string sVal) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    SetLocalString(oSkin, sVar, sVal);
}

void SetSkinLocation(object oCre, string sVar, location lVal) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    SetLocalLocation(oSkin, sVar, lVal);
}

void SetSkinJson(object oCre, string sVar, json jVal) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    SetLocalJson(oSkin, sVar, jVal);
}

int GetSkinInt(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    return GetLocalInt(oSkin, sVar);
}

float GetSkinFloat(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    return GetLocalFloat(oSkin, sVar);
}

string GetSkinString(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    return GetLocalString(oSkin, sVar);
}

location GetSkinLocation(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    return GetLocalLocation(oSkin, sVar);
}

json GetSkinJson(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (!GetIsObjectValid(oSkin))
        oSkin = GiveCreatureSkin(oCre);
    return GetLocalJson(oSkin, sVar);
}

void DelSkinInt(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (GetIsObjectValid(oSkin))
        DeleteLocalInt(oSkin, sVar);
}

void DelSkinFloat(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (GetIsObjectValid(oSkin))
        DeleteLocalFloat(oSkin, sVar);
}

void DelSkinString(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (GetIsObjectValid(oSkin))
        DeleteLocalString(oSkin, sVar);
}

void DelSkinLocation(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (GetIsObjectValid(oSkin))
        DeleteLocalLocation(oSkin, sVar);
}

void DelSkinJson(object oCre, string sVar) {
    object oSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oCre);
    if (GetIsObjectValid(oSkin))
        DeleteLocalJson(oSkin, sVar);
}