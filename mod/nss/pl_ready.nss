#include "inc_effects"
#include "inc_skin"
#include "inc_sqlite"
#include "nwnx_object"
#include "nwnx_creature"

json StarterBag() {
    json jBags = JsonArray();
        json jBag = JsonObject();
        jBag = JsonObjectSet(jBag, "name", JsonString("Starter Bag"));
        jBag = JsonObjectSet(jBag, "slots", JsonInt(3));
        jBag = JsonObjectSet(jBag, "weight_reduction", JsonInt(0));
    jBags = JsonArrayInsert(jBags, jBag);

    return jBags;
}

void main()
{
    object oPC = OBJECT_SELF;

    // persistence; player scripts aren't written to .bic, so have to be set every login
    SetEventScript(oPC, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "pl_heartbeat");

    // convert inventory to nui control
    SetGuiPanelDisabled(oPC, GUI_PANEL_INVENTORY, TRUE);

    int nHP = GetSkinInt(oPC, PL_HITPOINTS);

    // don't try to get persistent hp & effects for newly created characters
    // this value should only ever return 0 if it doesn't exist; even on death it's set to -1
    if (!nHP) {
        // start new players out with a starter inventory bag
        SetSkinJson(oPC, PL_BAGS, StarterBag());
        return;
    }

    // neither of these matter if the player will die, so can set them safely regardless
    SetCurrentHitPoints(oPC, nHP);
    // SetEffects(oPC, GetSkinJson(oPC, PL_EFFECTS));

    if (nHP < 0)
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDeath(), oPC);
}