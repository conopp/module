// ************************
// *       Includes       *
// ************************

#include "nwnx_effect"

// ************************
// *      Variables       *
// ************************

int i = 0; // iterative for-loop indexer

// constants for SetPlayerJson() sqlite columns
const string PLAYER_LOCATION  = "location";
const string PLAYER_HITPOINTS = "hitpoints";
const string PLAYER_EFFECTS   = "effects";

// ************************
// *      Prototypes      *
// ************************

// converts a vector into json
json JsonVector(vector vVector);

// converts a json object into a vector; up to dev to ensure correct structure
vector JsonGetVector(json joVector);

// converts a location into json
json JsonLocation(location lLocation);

// converts a json object into a location; up to dev to ensure correct structure
location JsonGetLocation(json joLocation);

// converts an NWNX_EffectUnpacked struct into json
// looks like: {"key1":$value1, "key2":$value2, ...}; see NWNX_EffectUnpacked struct
json JsonEffect(NWNX_EffectUnpacked eEffect);

// converts a json object into an NWNX_EffectUnpacked struct; up to dev to ensure correct structure
NWNX_EffectUnpacked JsonGetEffect(json joEffect);

// gets all effects from an object (player, item, etc)
json GetCurrentEffects(object oObject);

// applies all effects stored into a json array; works well when paired with GetCurrentEffects()
void ApplyStoredEffects(object oObject, json jaEffects);

// save player's location, hitpoints, or effects to the database; see PLAYER_* constants
// * returns SqlGetError() of sqlite query
string SetPlayerJson(object oPC, string sCol, json jVal);

// returns a player's location, hitpoints, or effects; see PLAYER_* constants
json GetPlayerJson(object oPC, string sCol);

// *************************
// *       Functions       *
// *************************

json JsonVector(vector vVector)
{
    json joVector = JsonObject();
    joVector = JsonObjectSet(joVector, "x", JsonFloat(vVector.x));
    joVector = JsonObjectSet(joVector, "y", JsonFloat(vVector.y));

    return joVector;
}

vector JsonGetVector(json joVector)
{
    float x = JsonGetFloat(JsonObjectGet(joVector, "x"));
    float y = JsonGetFloat(JsonObjectGet(joVector, "y"));

    return Vector(x, y);
}

json JsonLocation(location lLocation)
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

location JsonGetLocation(json joLocation)
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

json JsonEffect(NWNX_EffectUnpacked eEffect)
{
    joEffect = JsonObject();
    joEffect = JsonObjectSet(joEffect, "sID", JsonString(eEffect.sID));
    joEffect = JsonObjectSet(joEffect, "nType", JsonInt(eEffect.nType));
    joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(eEffect.nSubType));
    joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(eEffect.fDuration));
    joEffect = JsonObjectSet(joEffect, "oCreator", ObjectToJson(eEffect.oCreator));
    joEffect = JsonObjectSet(joEffect, "nSpellId", JsonInt(eEffect.nSpellId));
    joEffect = JsonObjectSet(joEffect, "bExpose", JsonInt(eEffect.bExpose));
    joEffect = JsonObjectSet(joEffect, "bShowIcon", JsonInt(eEffect.bShowIcon));
    joEffect = JsonObjectSet(joEffect, "nCasterLevel", JsonInt(eEffect.nCasterLevel));
    joEffect = JsonObjectSet(joEffect, "eLinkLeft", JsonEffect(eEffect.eLinkLeft));
    joEffect = JsonObjectSet(joEffect, "bLinkLeftValid", JsonInt(eEffect.bLinkLeftValid));
    joEffect = JsonObjectSet(joEffect, "eLinkRight", JsonEffect(eEffect.eLinkRight));
    joEffect = JsonObjectSet(joEffect, "bLinkRightValid", JsonInt(eEffect.bLinkRightValid));
    joEffect = JsonObjectSet(joEffect, "nNumIntegers", JsonInt(eEffect.nNumIntegers));
    joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
    joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(eEffect.nParam1));
    joEffect = JsonObjectSet(joEffect, "nParam2", JsonInt(eEffect.nParam2));
    joEffect = JsonObjectSet(joEffect, "nParam3", JsonInt(eEffect.nParam3));
    joEffect = JsonObjectSet(joEffect, "nParam4", JsonInt(eEffect.nParam4));
    joEffect = JsonObjectSet(joEffect, "nParam5", JsonInt(eEffect.nParam5));
    joEffect = JsonObjectSet(joEffect, "nParam6", JsonInt(eEffect.nParam6));
    joEffect = JsonObjectSet(joEffect, "nParam7", JsonInt(eEffect.nParam7));
    joEffect = JsonObjectSet(joEffect, "fParam0", JsonFloat(eEffect.fParam0));
    joEffect = JsonObjectSet(joEffect, "fParam1", JsonFloat(eEffect.fParam1));
    joEffect = JsonObjectSet(joEffect, "fParam2", JsonFloat(eEffect.fParam2));
    joEffect = JsonObjectSet(joEffect, "fParam3", JsonFloat(eEffect.fParam3));
    joEffect = JsonObjectSet(joEffect, "sParam0", JsonString(eEffect.sParam0));
    joEffect = JsonObjectSet(joEffect, "sParam1", JsonString(eEffect.sParam1));
    joEffect = JsonObjectSet(joEffect, "sParam2", JsonString(eEffect.sParam2));
    joEffect = JsonObjectSet(joEffect, "sParam3", JsonString(eEffect.sParam3));
    joEffect = JsonObjectSet(joEffect, "sParam4", JsonString(eEffect.sParam4));
    joEffect = JsonObjectSet(joEffect, "sParam5", JsonString(eEffect.sParam5));
    joEffect = JsonObjectSet(joEffect, "oParam0", ObjectToJson(eEffect.oParam0));
    joEffect = JsonObjectSet(joEffect, "oParam1", ObjectToJson(eEffect.oParam1));
    joEffect = JsonObjectSet(joEffect, "oParam2", ObjectToJson(eEffect.oParam2));
    joEffect = JsonObjectSet(joEffect, "oParam3", ObjectToJson(eEffect.oParam3));
    joEffect = JsonObjectSet(joEffect, "vParam0", JsonVector(eEffect.vParam0));
    joEffect = JsonObjectSet(joEffect, "vParam1", JsonVector(eEffect.vParam1));
    joEffect = JsonObjectSet(joEffect, "sTag", JsonString(eEffect.sTag));
    joEffect = JsonObjectSet(joEffect, "sItemProp", JsonString(eEffect.sItemProp));

    return joEffect;
}

NWNX_EffectUnpacked JsonGetEffect(json joEffect)
{
    NWNX_EffectUnpacked eEffect;
    eEffect.sID = JsonGetString(JsonObjectGet(joEffect, "sID"));
    eEffect.nType = JsonGetString(JsonObjectGet(joEffect, "nType"));
    eEffect.nSubType = JsonGetString(JsonObjectGet(joEffect, "nSubType"));
    eEffect.fDuration = JsonGetString(JsonObjectGet(joEffect, "fDuration"));
    eEffect.oCreator = JsonGetString(JsonObjectGet(joEffect, "oCreator"));
    eEffect.nSpellId = JsonGetString(JsonObjectGet(joEffect, "nSpellId"));
    eEffect.bExpose = JsonGetString(JsonObjectGet(joEffect, "bExpose"));
    eEffect.bShowIcon = JsonGetString(JsonObjectGet(joEffect, "bShowIcon"));
    eEffect.nCasterLevel = JsonGetString(JsonObjectGet(joEffect, "nCasterLevel"));
    eEffect.eLinkLeft = JsonGetString(JsonObjectGet(joEffect, "eLinkLeft"));
    eEffect.bLinkLeftValid = JsonGetString(JsonObjectGet(joEffect, "bLinkLeftValid"));
    eEffect.eLinkRight = JsonGetString(JsonObjectGet(joEffect, "eLinkRight"));
    eEffect.bLinkRightValid = JsonGetString(JsonObjectGet(joEffect, "bLinkRightValid"));
    eEffect.nNumIntegers = JsonGetString(JsonObjectGet(joEffect, "nNumIntegers"));
    eEffect.bLinkRightValid = JsonGetString(JsonObjectGet(joEffect, "bLinkRightValid"));
    eEffect.nParam0 = JsonGetString(JsonObjectGet(joEffect, "nParam0"));
    eEffect.nParam1 = JsonGetString(JsonObjectGet(joEffect, "nParam1"));
    eEffect.nParam2 = JsonGetString(JsonObjectGet(joEffect, "nParam2"));
    eEffect.nParam3 = JsonGetString(JsonObjectGet(joEffect, "nParam3"));
    eEffect.nParam4 = JsonGetString(JsonObjectGet(joEffect, "nParam4"));
    eEffect.nParam5 = JsonGetString(JsonObjectGet(joEffect, "nParam5"));
    eEffect.nParam6 = JsonGetString(JsonObjectGet(joEffect, "nParam6"));
    eEffect.nParam7 = JsonGetString(JsonObjectGet(joEffect, "nParam7"));
    eEffect.fParam0 = JsonGetString(JsonObjectGet(joEffect, "fParam0"));
    eEffect.fParam1 = JsonGetString(JsonObjectGet(joEffect, "fParam1"));
    eEffect.fParam2 = JsonGetString(JsonObjectGet(joEffect, "fParam2"));
    eEffect.fParam3 = JsonGetString(JsonObjectGet(joEffect, "fParam3"));
    eEffect.sParam0 = JsonGetString(JsonObjectGet(joEffect, "sParam0"));
    eEffect.sParam1 = JsonGetString(JsonObjectGet(joEffect, "sParam1"));
    eEffect.sParam2 = JsonGetString(JsonObjectGet(joEffect, "sParam2"));
    eEffect.sParam3 = JsonGetString(JsonObjectGet(joEffect, "sParam3"));
    eEffect.sParam4 = JsonGetString(JsonObjectGet(joEffect, "sParam4"));
    eEffect.sParam5 = JsonGetString(JsonObjectGet(joEffect, "sParam5"));
    eEffect.oParam0 = JsonGetString(JsonObjectGet(joEffect, "oParam0"));
    eEffect.oParam1 = JsonGetString(JsonObjectGet(joEffect, "oParam1"));
    eEffect.oParam2 = JsonGetString(JsonObjectGet(joEffect, "oParam2"));
    eEffect.oParam3 = JsonGetString(JsonObjectGet(joEffect, "oParam3"));
    eEffect.vParam0 = JsonGetString(JsonObjectGet(joEffect, "vParam0"));
    eEffect.vParam1 = JsonGetString(JsonObjectGet(joEffect, "vParam1"));
    eEffect.sTag = JsonGetString(JsonObjectGet(joEffect, "sTag"));
    eEffect.sItemProp = JsonGetString(JsonObjectGet(joEffect, "sItemProp"));

    return eEffect;
}

json GetCurrentEffects(object oObject)
{
    json jaEffects = JsonArray();
    for (i = 1; i <= NWNX_Effect_GetTrueEffectCount(oPC), i++) {
        NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);
        jaEffects = JsonArrayInsert(jaEffects, JsonEffect(eEffect));
    }

    return jaEffects;
}

void ApplyStoredEffects(object oObject, json jaEffects)
{
    while (JsonGetLength(jaEffects) != 0) {
        json joEffect = JsonArrayGet(jaEffects, 0);
        NWNX_Effect_Apply(JsonGetEffect(joEffect), oObject);
        jaEffects = JsonArrayDel(jaEffects, 0);
    }
}

string SetPlayerJson(object oPC, string sCol, json jVal)
{
    sqlquery sqlUpdate = SqlPrepareQueryCampaign("conopp", "INSERT INTO persistence" +
        "(uuid, @sCol) VALUES (@uuid, @jVal)" +
        "ON CONFLICT DO UPDATE SET (@sCol = @jVal)");
    SqlBindString(sqlUpdate, "@uuid", GetObjectUUID(oPC));
    SqlBindString(sqlUpdate, "@sCol", sCol);
    SqlBindJson(sqlUpdate, "@jVal", jVal);
    SqlStep(sqlUpdate);

    return SqlGetError(sqlUpdate);
}

json GetPlayerJson(object oPC, string sCol)
{
    sqlquery sqlSelect = SqlPrepareQueryCampaign("conopp", "SELECT uuid, @nCol FROM persistence");
    SqlBindString(sqlSelect, "@sCol", sCol);
    SqlStep(sqlSelect);

    if (SqlGetError(sqlSelect) != "") {
        return JsonNull();
    }

    return SqlGetJson(sqlSelect, 1);
}