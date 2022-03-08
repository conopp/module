#include "nwnx_events"
#include "nwnx_feat"

void main()
{
    // persistence
    NWNX_Events_SubscribeEvent("NWNX_ON_ELC_VALIDATE_CHARACTER_BEFORE", "player_spawn");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_GUIEVENT, "player_gui");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_BEFORE", "player_logout");
    NWNX_Events_SubscribeEvent("NWNX_ON_CLIENT_DISCONNECT_AFTER", "player_left");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_DEATH, "player_death");

    // hitpoints override
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_PLAYER_REST, "player_rest");
    SetEventScript(GetModule(), EVENT_SCRIPT_MODULE_ON_RESPAWN_BUTTON_PRESSED, "player_revived");

    // item usage proficiencies
    //NWNX_Events_SubscribeEvent("NWNX_ON_VALIDATE_USE_ITEM_BEFORE", "event_useitem");
    //NWNX_Events_SubscribeEvent("NWNX_ON_ITEM_EQUIP_BEFORE", "event_equipitem");

    // create table to be able to store persistent data in database
    sqlquery sqlCreate = SqlPrepareQueryCampaign("conopp", "CREATE TABLE IF NOT EXISTS persistence (" +
        "uuid      TEXT UNIQUE NOT NULL," +
        "location  TEXT," +
        "hitpoints TEXT," +
        "effects   TEXT" +
    ")"); SqlStep(sqlCreate);

    // feats setup
    // All proficiencies -> Change hilite in inventory to red OnAcquire and/or OnInventoryOpen
    // id 1120 - Shield Proficiency: Small
    // id 1121 - Shield Proficiency: Large
    // id 1123 - Weapon Proficiency: Unarmed
        // auto-give to all races
    // id 1124 - Weapon Proficiency: Unarmed
    // id 1124 - Weapon Proficiency: Crossbow
    // id 1124 - Weapon Proficiency: Dagger
    // id 1124 - Weapon Proficiency: Hammer
    // id 1124 - Weapon Proficiency: Handaxe
    // id 1124 - Weapon Proficiency: Spear
    // id 1124 - Weapon Proficiency: Throwing Axe
    // id 1124 - Weapon Proficiency: Shortbow
    // id 1124 - Weapon Proficiency: Rapier
    // id 1124 - Weapon Proficiency: Flail
    // id 1124 - Weapon Proficiency: Longsword
    // id 1124 - Weapon Proficiency: Greatsword
    // id 1124 - Weapon Proficiency: Longbow
    // id 1124 - Weapon Proficiency: Dire Mace
    // id 1124 - Weapon Proficiency: Two-sided Axe
    // id 1124 - Weapon Proficiency: Two-bladed Sword
    // All weapon focuses & bonuses -> Apply OnEquip; Remove OnUnequip
}