#include "nwnx_events"

void main()
{
    switch (StringToInt(NWNX_Events_GetEventData("SKILL_ID"))) {
        case SKILL_ANIMAL_EMPATHY:
            object oBeast = StringToObject(NWNX_Events_GetEventData("TARGET_OBJECT_ID"));
            NWNX_Events_SkipEvent();

            // can entangle player to get them to simulate ClearAllActions without canceling CastTime, but we'll just do a basic add-to-queue instead
            // effect eEntangle = EffectEntangle();
            // ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEntangle, OBJECT_SELF);
            // RemoveEffect(OBJECT_SELF, eEntangle);

            ActionCastSpellAtObject(840, oBeast, METAMAGIC_NONE, TRUE);
            break;
    }
}