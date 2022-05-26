#include "inc_general"
#include "inc_sqlite"

void main()
{
    json joVal = JsonObject();
    joVal = JsonObjectSet(joVal, "month", JsonInt(GetCalendarMonth()));
    joVal = JsonObjectSet(joVal, "day", JsonInt(GetCalendarDay()));
    joVal = JsonObjectSet(joVal, "hour", JsonInt(GetTimeHour()));
    joVal = JsonObjectSet(joVal, "minute", JsonInt(GetTimeMinute()));

    // persist mod time so server restarts continue from the same in-game minute on startup
    sqlQuery = SqlPrepareQueryCampaign(MOD_NAME, "INSERT INTO " + TABLE_MOD + " " +
        "(" + COL_NAME + "," + COL_TIME + ") VALUES (@sModName,@joTime) " +
        "ON CONFLICT DO UPDATE SET " + COL_TIME + "=@joTime");
    SqlBindString(sqlQuery, "@sModName", MOD_NAME);
    SqlBindJson(sqlQuery, "@joTime", joVal);
    SqlStep(sqlQuery);
}