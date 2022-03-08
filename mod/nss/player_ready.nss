#include "nwnx_object"
#include "inc_conopp"

void main()
{
    // location is applied at an earlier event: NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE

    // jnHitPoints null? fallback to full hp because it's a new player and we haven't saved their hp yet
    // nHitPoints null? player is dead and we need to restore their death state
    json jnHitPoints = GetPlayerJson(OBJECT_SELF, PLAYER_HITPOINTS);
    if (jnHitPoints != JsonNull()) {
        int nHitPoints = JsonGetInt(jnHitPoints);
        if (nHitPoints > 0) {
            SetCurrentHitPoints(OBJECT_SELF, nHitPoints);
            SetHPOverrideLevel(OBJECT_SELF);

            // falls back to no effects on player
            json jaEffects = GetPlayerJson(OBJECT_SELF, PLAYER_EFFECTS);
            if (jaEffects != JsonNull()) SetCurrentEffects(OBJECT_SELF, jaEffects);
        } else {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(FALSE, FALSE), OBJECT_SELF);
        }
    }

    // hp override
    SetEventScript(OBJECT_SELF, EVENT_SCRIPT_CREATURE_ON_DAMAGED, "player_damaged");
}