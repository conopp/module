#include "nwnx_object"
#include "nwnx_player"
#include "inc_conopp"

void main()
{
    // if it's a first time player, they'll return 3 db errors "no data to fetch"; they can be ignored as the code to double-check if they exist before we try to search them would be too exhaustive

    // falls back to module spawnpoint
    json jnLocation = GetPlayerJson(OBJECT_SELF, PLAYER_LOCATION);
    if (jnLocation != JsonNull()) NWNX_Player_SetSpawnLocation(OBJECT_SELF, JsonGetLocation(jnLocation));
}