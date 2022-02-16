// ************************
// *       Includes       *
// ************************

#include "nwnx_effect"

// ************************
// *      Variables       *
// ************************

// iteratives for-loop indexing
int i = 0;
int j = 0;

// constants for SetPlayerJson() sqlite columns
const string PLAYER_LOCATION  = "location";
const string PLAYER_HITPOINTS = "hitpoints";
const string PLAYER_EFFECTS   = "effects";
const string PLAYER_CONNECTED = "connected";

// consts for nwnx effect types
const int NWNX_EFFECT_TYPE_AISTATEINTERNAL = 23;
const int NWNX_EFFECT_TYPE_VISION = 69;
const int NWNX_EFFECT_TYPE_ARCANESPELLFAILURE = 25;
const int NWNX_EFFECT_TYPE_SPELLFAILURE = 92;

// constants for EffectAIState() nAIState
const int AISTATE_NO_LEGS = -3; // cannot move (can still be bumped around by friendlies)
const int AISTATE_NO_HANDS = -5; // cant physically attack (melee/ranged) or cast somatic spells
const int AISTATE_NO_MOUTH = -9; // cannot be heard from listen or cast spells with verbal components
const int AISTATE_NO_EARS = -17; // cannot listen to find enemies, and possibly also not see invis enemies in max melee range
const int AISTATE_NO_CONTROL = -31; // shortcut for all of the above (same as SetCommandable(FALSE))

// constants for EffectVision() nVisionType
const int VISION_TYPE_NORMAL = 0;
const int VISION_TYPE_LOWLIGHTVISION = 1;
const int VISION_TYPE_DARKVISION = 2;
const int VISION_TYPE_ULTRAVISION = 3;
const int VISION_TYPE_BLIND = 4;

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

// constructor to generate an easy-to-use effect with no properties set; optionally set type & first param
struct NWNX_EffectUnpacked BlankEffect(int nType = 0, int nParam0 = 0);

// converts an NWNX_EffectUnpacked struct into json
// looks like: {"key1":$value1, "key2":$value2, ...}; see NWNX_EffectUnpacked struct
json JsonEffect(struct NWNX_EffectUnpacked eEffect);

// converts a json object into an effect; should *only* ever be ran on an effect converted into json with JsonEffect()
effect JsonGetEffect(json joEffect);

// gets all effects from an object (player, item, etc)
json GetCurrentEffects(object oObject);

// applies all effects stored into a json array; works well when paired with GetCurrentEffects()
void SetCurrentEffects(object oObject, json jaEffects);

// returns an effect that allows changing AIStateInternal of the creature
effect EffectAIState(int nAIState);

// returns an effect that can change the creature's specific vision type
effect EffectVision(int nVisionType);

// returns an effect that gives ASF to a creature
effect EffectArcaneSpellFailure(int nPercent, int nSchool);

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
    joVector = JsonObjectSet(joVector, "z", JsonFloat(vVector.z));

    return joVector;
}

vector JsonGetVector(json joVector)
{
    float x = JsonGetFloat(JsonObjectGet(joVector, "x"));
    float y = JsonGetFloat(JsonObjectGet(joVector, "y"));
    float z = JsonGetFloat(JsonObjectGet(joVector, "z"));

    return Vector(x, y, z);
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
    joPosition = JsonObjectSet(joPosition, "z", JsonFloat(vPosition.z));
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
    float z = JsonGetFloat(JsonObjectGet(joPosition, "z"));
    vector vPosition = Vector(x, y, z);
    // get facing
    float fFacing = JsonGetFloat(JsonObjectGet(joLocation, "facing"));

    return Location(oArea, vPosition, fFacing);
}

struct NWNX_EffectUnpacked BlankEffect(int nType = 0, int nParam0 = 0) {
    struct NWNX_EffectUnpacked eEffect;
    eEffect.nType = nType;
    eEffect.nSubType = 8;
    eEffect.fDuration = 0.0;
    eEffect.nExpiryCalendarDay = 0;
    eEffect.nExpiryTimeOfDay = 0;
    eEffect.oCreator = OBJECT_INVALID;
    eEffect.nSpellId = -1;
    eEffect.bExpose = 0;
    eEffect.bShowIcon = 0;
    eEffect.nCasterLevel = 0;
    eEffect.eLinkLeft = EffectACIncrease(0);
    eEffect.bLinkLeftValid = 0;
    eEffect.eLinkRight = EffectACIncrease(0);
    eEffect.bLinkRightValid = 0;
    eEffect.nNumIntegers = 8;
    eEffect.nParam0 = nParam0;
    eEffect.nParam1 = 0;
    eEffect.nParam2 = 0;
    eEffect.nParam3 = 0;
    eEffect.nParam4 = 0;
    eEffect.nParam5 = 0;
    eEffect.nParam6 = 0;
    eEffect.nParam7 = 0;
    eEffect.fParam0 = 0.0;
    eEffect.fParam1 = 0.0;
    eEffect.fParam2 = 0.0;
    eEffect.fParam3 = 0.0;
    eEffect.sParam0 = "";
    eEffect.sParam1 = "";
    eEffect.sParam2 = "";
    eEffect.sParam3 = "";
    eEffect.sParam4 = "";
    eEffect.sParam5 = "";
    eEffect.oParam0 = OBJECT_INVALID;
    eEffect.oParam1 = OBJECT_INVALID;
    eEffect.oParam2 = OBJECT_INVALID;
    eEffect.oParam3 = OBJECT_INVALID;
    eEffect.fVector0_x = 0.0;
    eEffect.fVector0_y = 0.0;
    eEffect.fVector0_z = 0.0;
    eEffect.fVector1_x = 0.0;
    eEffect.fVector1_y = 0.0;
    eEffect.fVector1_z = 0.0;
    eEffect.sTag = "";
    eEffect.sItemProp = "0";
    return eEffect;
}

json JsonEffect(struct NWNX_EffectUnpacked eEffect)
{
    switch (eEffect.nType) {
        case NWNX_EFFECT_TYPE_AISTATEINTERNAL: break;
        case NWNX_EFFECT_TYPE_VISION: break;
        case NWNX_EFFECT_TYPE_ARCANESPELLFAILURE: break;
        case NWNX_EFFECT_TYPE_SPELLFAILURE: break;
        default: return JsonNull();
    }

    json joEffect = JsonObject();

    joEffect = JsonObjectSet(joEffect, "nType", JsonInt(eEffect.nType));
    joEffect = JsonObjectSet(joEffect, "nSubType", JsonInt(eEffect.nSubType));
    joEffect = JsonObjectSet(joEffect, "fDuration", JsonFloat(IntToFloat(GetEffectDurationRemaining(NWNX_Effect_PackEffect(eEffect)))));
    joEffect = JsonObjectSet(joEffect, "sTag", JsonString(eEffect.sTag));

    switch (eEffect.nType) {
        case NWNX_EFFECT_TYPE_AISTATEINTERNAL: {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
            break;
        }
        case NWNX_EFFECT_TYPE_VISION: {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
            break;
        }
        case NWNX_EFFECT_TYPE_ARCANESPELLFAILURE: {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
            joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(eEffect.nParam1));
            break;
        }
        case NWNX_EFFECT_TYPE_SPELLFAILURE: {
            joEffect = JsonObjectSet(joEffect, "nParam0", JsonInt(eEffect.nParam0));
            joEffect = JsonObjectSet(joEffect, "nParam1", JsonInt(eEffect.nParam1));
            break;
        }
    }

    return joEffect;
}

effect JsonGetEffect(json joEffect)
{
    struct NWNX_EffectUnpacked eEffect = BlankEffect();

    eEffect.nType = JsonGetInt(JsonObjectGet(joEffect, "nType"));
    eEffect.nSubType = JsonGetInt(JsonObjectGet(joEffect, "nSubType"));
    eEffect.fDuration = JsonGetFloat(JsonObjectGet(joEffect, "fDuration"));
    eEffect.sTag = JsonGetString(JsonObjectGet(joEffect, "sTag"));

    switch (eEffect.nType) {
        case NWNX_EFFECT_TYPE_AISTATEINTERNAL: {
            eEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            break;
        }
        case NWNX_EFFECT_TYPE_VISION: {
            eEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            break;
        }
        case NWNX_EFFECT_TYPE_ARCANESPELLFAILURE: {
            eEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            eEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
            break;
        }
        case NWNX_EFFECT_TYPE_SPELLFAILURE: {
            eEffect.nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
            eEffect.nParam1 = JsonGetInt(JsonObjectGet(joEffect, "nParam1"));
            break;
        }
    }

    return NWNX_Effect_PackEffect(eEffect);
}

json GetCurrentEffects(object oObject)
{
    json jaEffects = JsonArray();
    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oObject); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oObject, i);
        json joEffect = JsonEffect(eEffect);
        if (joEffect != JsonNull()) jaEffects = JsonArrayInsert(jaEffects, joEffect);
    }

    return jaEffects;
}

void PrintEffects(object oPC) {
    SendMessageToPC(oPC, "XXXXX PRINT_EFFECTS XXXXX");

    for (i = 0; i < NWNX_Effect_GetTrueEffectCount(oPC); i++) {
        struct NWNX_EffectUnpacked eEffect = NWNX_Effect_GetTrueEffect(oPC, i);

        if (eEffect.nType != 68) {
            SendMessageToPC(oPC, "sID: " + eEffect.sID);
            SendMessageToPC(oPC, "nType: " + IntToString(eEffect.nType));
            SendMessageToPC(oPC, "nSubType: " + IntToString(eEffect.nSubType));

            SendMessageToPC(oPC, "fDuration: " + FloatToString(eEffect.fDuration, 4, 1));
            SendMessageToPC(oPC, "nExpiryCalendarDay: " + IntToString(eEffect.nExpiryCalendarDay));
            SendMessageToPC(oPC, "nExpiryTimeOfDay: " + IntToString(eEffect.nExpiryTimeOfDay));

            SendMessageToPC(oPC, "oCreator: " + ObjectToString(eEffect.oCreator));
            SendMessageToPC(oPC, "nSpellId: " + IntToString(eEffect.nSpellId));
            SendMessageToPC(oPC, "bExpose: " + IntToString(eEffect.bExpose));
            SendMessageToPC(oPC, "bShowIcon: " + IntToString(eEffect.bShowIcon));
            SendMessageToPC(oPC, "nCasterLevel: " + IntToString(eEffect.nCasterLevel));

            SendMessageToPC(oPC, "nNumIntegers: " + IntToString(eEffect.nNumIntegers));
            SendMessageToPC(oPC, "nParam0: " + IntToString(eEffect.nParam0));
            SendMessageToPC(oPC, "nParam1: " + IntToString(eEffect.nParam1));
            SendMessageToPC(oPC, "nParam2: " + IntToString(eEffect.nParam2));
            SendMessageToPC(oPC, "nParam3: " + IntToString(eEffect.nParam3));
            SendMessageToPC(oPC, "nParam4: " + IntToString(eEffect.nParam4));
            SendMessageToPC(oPC, "nParam5: " + IntToString(eEffect.nParam5));
            SendMessageToPC(oPC, "nParam6: " + IntToString(eEffect.nParam6));
            SendMessageToPC(oPC, "nParam7: " + IntToString(eEffect.nParam7));
            SendMessageToPC(oPC, "fParam0: " + FloatToString(eEffect.fParam0, 7, 2));
            SendMessageToPC(oPC, "fParam1: " + FloatToString(eEffect.fParam1, 7, 2));
            SendMessageToPC(oPC, "fParam2: " + FloatToString(eEffect.fParam2, 7, 2));
            SendMessageToPC(oPC, "fParam3: " + FloatToString(eEffect.fParam3, 7, 2));
            SendMessageToPC(oPC, "sParam0: " + eEffect.sParam0);
            SendMessageToPC(oPC, "sParam1: " + eEffect.sParam1);
            SendMessageToPC(oPC, "sParam2: " + eEffect.sParam2);
            SendMessageToPC(oPC, "sParam3: " + eEffect.sParam3);
            SendMessageToPC(oPC, "sParam4: " + eEffect.sParam4);
            SendMessageToPC(oPC, "oParam0: " + ObjectToString(eEffect.oParam0));
            SendMessageToPC(oPC, "oParam1: " + ObjectToString(eEffect.oParam1));
            SendMessageToPC(oPC, "oParam2: " + ObjectToString(eEffect.oParam2));
            SendMessageToPC(oPC, "oParam3: " + ObjectToString(eEffect.oParam3));
            SendMessageToPC(oPC, "vec0: (" + FloatToString(eEffect.fVector0_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector0_y, 7, 2) + ", " + FloatToString(eEffect.fVector0_z, 7, 2) + ")");
            SendMessageToPC(oPC, "vec1: (" + FloatToString(eEffect.fVector1_x, 7, 2) + ", " +
                FloatToString(eEffect.fVector1_y, 7, 2) + ", " + FloatToString(eEffect.fVector1_z, 7, 2) + ")");

            if (NWNX_Effect_GetTrueEffectCount(oPC)-1 != i) {
                SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
            }
        }
    }

    SendMessageToPC(oPC, "XXXXXXXXXXXXXXXXXXXXXXXXX");
}

void SetCurrentEffects(object oObject, json jaEffects)
{
    // we shouldn't have any effects that are null here because GetCurrentEffects() filters them out
    for (i = 0; i < JsonGetLength(jaEffects); i++) {
        json joEffect = JsonArrayGet(jaEffects, 0);
        effect eEffect = JsonGetEffect(joEffect);

        // special EffectVision application (it needs to blackout the player's screen)
        int nType = JsonGetInt(JsonObjectGet(joEffect, "nType"));
        int nParam0 = JsonGetInt(JsonObjectGet(joEffect, "nParam0"));
        if (nType == NWNX_EFFECT_TYPE_VISION && nParam0 == VISION_TYPE_BLIND) {
            eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BLACKOUT), eEffect);
        }

        float fDura = JsonGetFloat(JsonObjectGet(joEffect, "fDuration"));

        // EffectLinkEffects() doesn't work with effects applied with NWNX_Effect_Apply() because the linking bool
        //   properties are set FALSE, so we have to use ApplyEffectToObject()
        int nSubType = JsonGetInt(JsonObjectGet(joEffect, "nSubType"));
        if (nSubType - SUBTYPE_EXTRAORDINARY-1 == 0 || nSubType - SUBTYPE_SUPERNATURAL-1 == 0 || nSubType - SUBTYPE_MAGICAL-1 == 0) {
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oObject, fDura);
        } else {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oObject, fDura);
        }

        jaEffects = JsonArrayDel(jaEffects, 0);
    }

    PrintEffects(oObject);
}

effect EffectAIState(int nAIState) {
    struct NWNX_EffectUnpacked eEffect = BlankEffect();
        eEffect.nType = NWNX_EFFECT_TYPE_AISTATEINTERNAL;
        eEffect.nParam0 = nAIState;
        return NWNX_Effect_PackEffect(eEffect);
}

effect EffectVision(int nVisionType) {
    struct NWNX_EffectUnpacked eVision = BlankEffect();
    eVision.nType = NWNX_EFFECT_TYPE_VISION;
    eVision.nParam0 = nVisionType;

    effect eEffect = NWNX_Effect_PackEffect(eVision);

    // visually blackout creature's screen if necessary
    if (nVisionType == VISION_TYPE_BLIND) {
        eEffect = EffectLinkEffects(EffectVisualEffect(VFX_DUR_BLACKOUT), eEffect);
    }

    return eEffect;
}

effect EffectArcaneSpellFailure(int nPercent, int nSchool) {
    struct NWNX_EffectUnpacked eASF = BlankEffect();
    eASF.nType = NWNX_EFFECT_TYPE_ARCANESPELLFAILURE;
    eASF.nParam0 = nPercent;
    eASF.nParam1 = nSchool;
    return NWNX_Effect_PackEffect(eASF);
}

string SetPlayerJson(object oPC, string sCol, json jVal)
{
    sqlquery sqlUpdate = SqlPrepareQueryCampaign("conopp", "INSERT INTO persistence" +
        "(uuid, " + sCol + ") VALUES (@uuid, @jVal)" +
        "ON CONFLICT DO UPDATE SET " + sCol + " = @jVal");
    SqlBindString(sqlUpdate, "@uuid", GetObjectUUID(oPC));
    SqlBindJson(sqlUpdate, "@jVal", jVal);
    SqlStep(sqlUpdate);

    return SqlGetError(sqlUpdate);
}

json GetPlayerJson(object oPC, string sCol)
{
    sqlquery sqlSelect = SqlPrepareQueryCampaign("conopp", "SELECT uuid, " + sCol + " FROM persistence " +
        "WHERE uuid = @uuid");
    SqlBindString(sqlSelect, "@uuid", GetObjectUUID(oPC));
    SqlStep(sqlSelect);

    return SqlGetJson(sqlSelect, 1);
}