#include "inc_conopp"

void main()
{
    // location is applied at an earlier event: NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE

    json jnHitPoints = GetPlayerJson(OBJECT_SELF, PLAYER_HITPOINTS);
    if (jnHitPoints != JsonNull())  SetCurrentHitPoints(OBJECT_SELF, JsonGetInt(jHitPoints));

    json jaEffects = GetPlayerJson(OBJECT_SELF, PLAYER_EFFECTS);
    if (jaEffects != JsonNull()) ApplyStoredEffects(OBJECT_SELF, jaEffects);
}