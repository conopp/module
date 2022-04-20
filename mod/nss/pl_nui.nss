#include "inc_general"
#include "inc_nui"

void main()
{
    object oPC = NuiGetEventPlayer();

    int nToken = NuiGetEventWindow();
    string sWindowID = NuiGetWindowId(oPC, nToken);

    string sEvent = NuiGetEventType(); // watch, open, close, click, mouseup, mousedown
    string sElement = NuiGetEventElement(); // id of element
    int nIndex = NuiGetEventArrayIndex(); // specific element index, if sElement is an array
    json jPayload = NuiGetEventPayload(); // data like mouse position, elements in range, etc


    NuiHandleEvent(oPC, nToken, sWindowID, sEvent, sElement, nIndex, jPayload);
}