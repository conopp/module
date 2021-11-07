void main()
{
    object oArea = GetArea(OBJECT_SELF);
    object oObject = GetFirstObjectInArea(oArea);
    while (GetIsObjectValid(oObject)) {
        if (GetObjectType(oObject) == OBJECT_TYPE_PLACEABLE && GetResRef(oObject) == "trans01") {
            if (GetLocalInt(oObject, "bChangedColor")) {
                ReplaceObjectTexture(oObject, "trans_blu", "");
                SetLocalInt(oObject, "bChangedColor", FALSE);
                SendMessageToPC(GetFirstPC(), "->default");
            } else {
                ReplaceObjectTexture(oObject, "trans_blu", "trans_grn");
                SetLocalInt(oObject, "bChangedColor", TRUE);
                SendMessageToPC(GetFirstPC(), "blu->grn");
            }
        }
        oObject = GetNextObjectInArea(oArea);
    }
}