// ************************
// *       Includes       *
// ************************

#include "inc_sqlite"
#include "nw_inc_nui"
#include "nwnx_util"

// ************************
// *      Variables       *
// ************************

const int DEBUG_GENERAL = TRUE;

const string COLOR_TOKEN = "\x01\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F\x80\x81\x82\x83\x84\x85\x86\x87\x88\x89\x8A\x8B\x8C\x8D\x8E\x8F\x90\x91\x92\x93\x94\x95\x96\x97\x98\x99\x9A\x9B\x9C\x9D\x9E\x9F\xA0\xA1\xA2\xA3\xA4\xA5\xA6\xA7\xA8\xA9\xAA\xAB\xAC\xAD\xAE\xAF\xB0\xB1\xB2\xB3\xB4\xB5\xB6\xB7\xB8\xB9\xBA\xBB\xBC\xBD\xBE\xBF\xC0\xC1\xC2\xC3\xC4\xC5\xC6\xC7\xC8\xC9\xCA\xCB\xCC\xCD\xCE\xCF\xD0\xD1\xD2\xD3\xD4\xD5\xD6\xD7\xD8\xD9\xDA\xDB\xDC\xDD\xDE\xDF\xE0\xE1\xE2\xE3\xE4\xE5\xE6\xE7\xE8\xE9\xEA\xEB\xEC\xED\xEE\xEF\xF0\xF1\xF2\xF3\xF4\xF5\xF6\xF7\xF8\xF9\xFA\xFB\xFC\xFD\xFE\xFF";

location LOCATION_INVALID;

int i = 0;
int j = 0;
json jNull = JsonNull();

int nTimerElapsedSeconds = 0;

// ************************
// *      Prototypes      *
// ************************

int GetIsLocationValid(location lLoc);

json JsonVector(vector vVec);
vector JsonGetVector(json joVec);
json JsonLocation(location lLoc);
location JsonGetLocation(json joLoc);

string ColorString(string sString, int nRed=255, int nGreen=255, int nBlue=255);

// *************************
// *       Functions       *
// *************************

int GetIsLocationValid(location lLocation)
{
    object oArea = GetAreaFromLocation(lLocation);
    vector vPosition = GetPositionFromLocation(lLocation);

    if (oArea == OBJECT_INVALID || vPosition == Vector())
        return FALSE;

    return TRUE;
}

json JsonVector(vector vVec)
{
    json joVec = JsonObject();
    joVec = JsonObjectSet(joVec, "x", JsonFloat(vVec.x));
    joVec = JsonObjectSet(joVec, "y", JsonFloat(vVec.y));
    joVec = JsonObjectSet(joVec, "z", JsonFloat(vVec.z));

    return joVec;
}

vector JsonGetVector(json joVec)
{
    float x = JsonGetFloat(JsonObjectGet(joVec, "x"));
    float y = JsonGetFloat(JsonObjectGet(joVec, "y"));
    float z = JsonGetFloat(JsonObjectGet(joVec, "z"));

    return Vector(x, y, z);
}

json JsonLocation(location lLoc)
{
    json joLoc = JsonObject();
    // set area
    joLoc = JsonObjectSet(joLoc, "area", JsonString(GetTag(GetAreaFromLocation(lLoc))));
    // set position
    json joPosition = JsonObject();
    vector vPosition = GetPositionFromLocation(lLoc);
    joPosition = JsonObjectSet(joPosition, "x", JsonFloat(vPosition.x));
    joPosition = JsonObjectSet(joPosition, "y", JsonFloat(vPosition.y));
    joPosition = JsonObjectSet(joPosition, "z", JsonFloat(vPosition.z));
    joLoc = JsonObjectSet(joLoc, "position", joPosition);
    // set facing
    joLoc = JsonObjectSet(joLoc, "facing", JsonFloat(GetFacingFromLocation(lLoc)));

    return joLoc;
}

location JsonGetLocation(json joLoc)
{
    // get area
    object oArea = GetObjectByTag(JsonGetString(JsonObjectGet(joLoc, "area")));
    // get position
    json joPosition = JsonObjectGet(joLoc, "position");
    float x = JsonGetFloat(JsonObjectGet(joPosition, "x"));
    float y = JsonGetFloat(JsonObjectGet(joPosition, "y"));
    float z = JsonGetFloat(JsonObjectGet(joPosition, "z"));
    vector vPosition = Vector(x, y, z);
    // get facing
    float fFacing = JsonGetFloat(JsonObjectGet(joLoc, "facing"));

    return Location(oArea, vPosition, fFacing);
}

string ColorString(string sString, int nRed=255, int nGreen=255, int nBlue=255) {
    return "<c" + GetSubString(COLOR_TOKEN, nRed, 1) + GetSubString(COLOR_TOKEN, nGreen, 1) + GetSubString(COLOR_TOKEN, nBlue, 1) + ">" + sString + "</c>";
}