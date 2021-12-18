// ************************
// *       Includes       *
// ************************

#include "nwnx_effect"

// ************************
// *      Variables       *
// ************************

int i = 0; // iterative for-loop indexer

// ************************
// *      Prototypes      *
// ************************

// converts a location into json
// @lLocation = location to convert
// * return json object representing location
json JsonLocation(location lLocation);

// converts a json object into a location; up to dev to ensure correct structure
// @joLocation = location represented as json
// * return Location(object oArea, vector vPosition, float fOrientation)
location JsonGetLocation(json joLocation);

// converts an NWNX_EffectUnpacked struct into json
// @eEffect = effect to convert
// * return json object as {"key1":$value1, "key2":$value2, ...}; see NWNX_EffectUnpacked struct
json JsonEffect(NWNX_EffectUnpacked eEffect);

// converts a json object into an NWNX_EffectUnpacked struct; up to dev to ensure correct structure
NWNX_EffectUnpacked JsonGetEffect(json joEffect);

// save player's location, hitpoints, and effects to their .bic database
// @oPC = player object
// * return true/false if function fully executed
int SavePlayerPersistence(object oPC=OBJECT_SELF);

// *************************
// *       Functions       *
// *************************

JsonLocation(location lLocation)
{
    json joLocation = JsonObject();
    // set area
    joLocation = JsonObjectSet(joLocation, "area", JsonString(GetTag(GetAreaFromLocation(lLocation))));
    // set position
    json joPosition = JsonObject();
    vector vPosition = GetPositionFromLocation(lLocation);
    joPosition = JsonObjectSet(joPosition, "x", JsonFloat(vPosition.x));
    joPosition = JsonObjectSet(joPosition, "y", JsonFloat(vPosition.y));
    joLocation = JsonObjectSet(joLocation, "position", joPosition);
    // set facing
    joLocation = JsonObjectSet(joLocation, "facing", JsonFloat(GetFacingFromLocation(lLocation)));

    return joLocation;
}

JsonGetLocation(json joLocation)
{
    // get area
    object oArea = GetObjectByTag(JsonGetString(JsonObjectGet(joLocation, "area")));
    // get position
    json joPosition = JsonObjectGet(joLocation, "position");
    float x = JsonGetFloat(JsonObjectGet(joPosition, "x"));
    float y = JsonGetFloat(JsonObjectGet(joPosition, "y"));
    vector vPosition = Vector(x, y, z);
    // get facing
    float fFacing = JsonGetFloat(JsonObjectGet(joLocation, "facing"));

    return Location(oArea, vPosition, fFacing);
}

JsonEffect(NWNX_EffectUnpacked eEffect) {
    joEffect = JsonObject();
    joEffect = JsonObjectSet(joEffect, "sID", JsonString(eEffect.sID));
    jaEffects = JsonArrayInsert(jaEffects, "nType", JsonInt(eEffect.nType));
    jaEffects = JsonArrayInsert(jaEffects, "nSubType", JsonInt(eEffect.nSubType));
    jaEffects = JsonArrayInsert(jaEffects, "fDuration", JsonFloat(eEffect.fDuration));
    jaEffects = JsonArrayInsert(jaEffects, "oCreator", ObjectToJson(eEffect.oCreator));
    jaEffects = JsonArrayInsert(jaEffects, "nSpellId", JsonInt(eEffect.nSpellId));
    jaEffects = JsonArrayInsert(jaEffects, "bExpose", JsonInt(eEffect.bExpose));
    jaEffects = JsonArrayInsert(jaEffects, "bShowIcon", JsonInt(eEffect.bShowIcon));
    jaEffects = JsonArrayInsert(jaEffects, "nCasterLevel", JsonInt(eEffect.nCasterLevel));
    jaEffects = JsonArrayInsert(jaEffects, "eLinkLeft", JsonEffect(eEffect.eLinkLeft));
    jaEffects = JsonArrayInsert(jaEffects, "bLinkLeftValid", JsonInt(eEffect.bLinkLeftValid));
    jaEffects = JsonArrayInsert(jaEffects, "eLinkRight", JsonEffect(eEffect.eLinkRight));
    jaEffects = JsonArrayInsert(jaEffects, "nNumIntegers", JsonInt(eEffect.nNumIntegers));
    jaEffects = JsonArrayInsert(jaEffects, "nParam0", JsonInt(eEffect.nParam0));
    jaEffects = JsonArrayInsert(jaEffects, "nParam1", JsonInt(eEffect.nParam1));
    jaEffects = JsonArrayInsert(jaEffects, "nParam2", JsonInt(eEffect.nParam2));
    jaEffects = JsonArrayInsert(jaEffects, "nParam3", JsonInt(eEffect.nParam3));
    jaEffects = JsonArrayInsert(jaEffects, "nParam4", JsonInt(eEffect.nParam4));
    jaEffects = JsonArrayInsert(jaEffects, "nParam5", JsonInt(eEffect.nParam5));
    jaEffects = JsonArrayInsert(jaEffects, "nParam6", JsonInt(eEffect.nParam6));
    jaEffects = JsonArrayInsert(jaEffects, "nParam7", JsonInt(eEffect.nParam7));
    jaEffects = JsonArrayInsert(jaEffects, "fParam0", JsonFloat(eEffect.fParam0));
    jaEffects = JsonArrayInsert(jaEffects, "fParam1", JsonFloat(eEffect.fParam1));
    jaEffects = JsonArrayInsert(jaEffects, "fParam2", JsonFloat(eEffect.fParam2));
    jaEffects = JsonArrayInsert(jaEffects, "fParam3", JsonFloat(eEffect.fParam3));
    jaEffects = JsonArrayInsert(jaEffects, "sParam0", JsonString(eEffect.sParam0));
    jaEffects = JsonArrayInsert(jaEffects, "sParam1", JsonString(eEffect.sParam1));
    jaEffects = JsonArrayInsert(jaEffects, "sParam2", JsonString(eEffect.sParam2));
    jaEffects = JsonArrayInsert(jaEffects, "sParam3", JsonString(eEffect.sParam3));
    jaEffects = JsonArrayInsert(jaEffects, "sParam4", JsonString(eEffect.sParam4));
    jaEffects = JsonArrayInsert(jaEffects, "sParam5", JsonString(eEffect.sParam5));
    jaEffects = JsonArrayInsert(jaEffects, "oParam0", ObjectToJson(eEffect.oParam0));
    jaEffects = JsonArrayInsert(jaEffects, "oParam1", ObjectToJson(eEffect.oParam1));
    jaEffects = JsonArrayInsert(jaEffects, "oParam2", ObjectToJson(eEffect.oParam2));
    jaEffects = JsonArrayInsert(jaEffects, "oParam3", ObjectToJson(eEffect.oParam3));
    jaEffects = JsonArrayInsert(jaEffects, "vParam0", JsonVector(eEffect.vParam0));
    jaEffects = JsonArrayInsert(jaEffects, "vParam1", JsonVector(eEffect.vParam1));
    jaEffects = JsonArrayInsert(jaEffects, "sTag", JsonString(eEffect.sTag));
    jaEffects = JsonArrayInsert(jaEffects, "sItemProp", JsonString(eEffect.sItemProp));
}

JsonGetEffect(json joEffect) {

}

SavePlayerPersistence(object oPC, string sCol, json jVal)
{
    // create table to be able to store persistent data in player's .bic database
    sqlquery sqlCreate = SqlPrepareQueryObject(oPC, "CREATE TABLE IF NOT EXISTS persistence (" +
        "location  TEXT    UNIQUE NOT NULL," +
        "hitpoints INTEGER UNIQUE NOT NULL," +
        "effects   TEXT    UNIQUE NOT NULL" +
    ")");
    SqlStep(sqlCreate);

    // check errors
    if (SqlGetError(sqlCreate) != "") {
        WriteTimestampedLogEntry("player_logout.nss:63 -> " + SqlGetError(sqlCreate));
        return;
    }

    // loop effects with NWNX; as long as effect isn't from an itemprop, add to array
    json jaEffects = JsonArray();
    for (i = 0; i <= NWNX_Effect_GetTrueEffectCount(oPC), i++) {
        NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        joEffect = JsonEffect(eEffect);
        jaEffects = JsonArrayInsert(jaEffects, jaEffect);
    }

    sqlquery sqlInsert = SqlPrepareQueryObject(oPC, "REPLACE INTO persistence" +
        "(location, hitpoints, effects)" +
        "VALUES (@location, @hitpoints, @effects)"
    );
    SqlBindJson(sqlInsert, "@location", JsonLocation(GetLocation(oPC)));
    SqlBindInt(sqlInsert, "@hitpoints", GetCurrentHitPoints(oPC));
    SqlBindJson(sqlInsert, "@effects", jaEffects);
    SqlStep(sqlInsert);

    // check errors
    if (SqlGetError(sqlInsert) != "") {
        WriteTimestampedLogEntry("player_logout.nss:75 -> " + SqlGetError(sqlInsert));
        return;
    }
}



// write position to .bic
SetPlayerJson(OBJECT_SELF, "position", jVal);

// write hitpoints to .bic
SetPlayerJson(OBJECT_SELF, "hitpoints", jVal);

// write effects to .bic
SetPlayerJson(OBJECT_SELF, "effects", jVal);

effect eEffect = GetFirstEffect(OBJECT_SELF);
while (GetIsEffectValid(eEffect)) {
    // todo
    eEffect = GetNextEffect(OBJECT_SELF);
}

json jLoc = JsonObject();
int nHealth = GetCurrentHitPoints(OBJECT_SELF);
json jEffects = JsonObject();

sqlquery sqlCreate = SqlPrepareQueryObject(OBJECT_SELF, "CREATE TABLE IF NOT EXISTS [persistence]" +
    "(location TEXT UNIQUE NOT NULL, health INT UNIQUE NOT NULL, effects TEXT UNIQUE NOT NULL)");
SqlStep(sqlCreate);

sqlquery sqlInsert = SqlPrepareQueryObject(OBJECT_SELF, "REPLACE INTO [persistence]" +
    "location, health, effects" +
    "VALUES (@location, @health, @effects)");
SqlBindJson(sqlInsert, "@location", jLoc);
SqlBindInt(sqlInsert, "@health", nHealth);
SqlBindJson(sqlInsert, "@effects", jEffects);
SqlStep(sqlInsert);