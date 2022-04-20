#include "inc_general"
#include "nwnx_chat"
#include "nwnx_util"

void main()
{
    object oPC = GetPCChatSpeaker();
    string sMsg = GetPCChatMessage();

    // if (GetStringLeft(sMsg, 0) == "/") {
    //     // removes slash from beginning of string
    //     sMsg = GetStringRight(sMsg, GetStringLength(sMsg)-1);

    //     if (sMsg == "storage")
    //         SendMessageToPC(oPC, "running module script : pl_chat")
    //         // OpenStorage(GetPCPublicCDKey(oPC));

    //     SetPCChatMessage();
    // }


}