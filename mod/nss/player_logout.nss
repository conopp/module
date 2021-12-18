#include "nwnx_object"
#include "inc_conopp"

void main()
{
    // player was in character selection but canceled out
    if (OBJECT_SELF == OBJECT_INVALID) return;

    // save player's progress
    SavePlayerPersistence(OBJECT_SELF);
}