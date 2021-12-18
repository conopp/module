void main()
{
    object oPC = GetLastUsedBy();

    json jLoc = JsonObject();
    int nHealth = GetCurrentHitPoints(oPC);
    json jEffects = JsonObject();

    sqlquery sqlCreate = SqlPrepareQueryObject(oPC, "CREATE TABLE IF NOT EXISTS [persistence]" +
        "(location TEXT UNIQUE NOT NULL, health INT UNIQUE NOT NULL, effects TEXT UNIQUE NOT NULL)");
    SqlStep(sqlCreate);

    sqlquery sqlInsert = SqlPrepareQueryObject(oPC, "REPLACE INTO persistence" +
        "VALUES (@location, @health, @effects)");
    SqlBindJson(sqlInsert, "@location", jLoc);
    SqlBindInt(sqlInsert, "@health", nHealth);
    SqlBindJson(sqlInsert, "@effects", jEffects);
    SqlStep(sqlInsert);

    ExportSingleCharacter(oPC);

    // ~~~~~~~~~~~~~~~~~~~~

    sqlquery sqlSelect = SqlPrepareQueryObject(oPC, "SELECT * FROM persistence");
    SqlStep(sqlSelect);

    string sLoc = SqlGetString(sqlSelect, 0);
    int iHealth = SqlGetInt(sqlSelect, 1);
    string sEffects = SqlGetString(sqlSelect, 2);

    SendMessageToPC(oPC, "location: " + sLoc);
    SendMessageToPC(oPC, "health: " + IntToString(iHealth));
    SendMessageToPC(oPC, "effects: " + sEffects);
}
