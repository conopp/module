#include "nwnx_admin"

void main()
{
    // delete TURD so player login and logout always behaves same way
    NWNX_Administration_DeleteTURD(GetPCPlayerName(OBJECT_SELF), GetName(OBJECT_SELF));
}