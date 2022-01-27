#include "nwnx_object"
#include "nwnx_player"
#include "inc_conopp"

void main()
{
    json joLocation = GetPlayerJson(OBJECT_SELF, PLAYER_LOCATION);

    // not a new player
    if (joLocation != JsonNull()) {
        NWNX_Player_SetSpawnLocation(OBJECT_SELF, JsonGetLocation(joLocation));
    }
}