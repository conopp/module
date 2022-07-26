include "inc_constants"
include "nwnx_damage"

// if the overhead feedback doesn't automatically show up after changing iAttackResult to 3 (* critical hit *)
//   NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_FLOATY_TEXT_STRREF, TRUE); // 93
//   FloatingTextStrRefOnCreature(5224, OBJECT_SELF, FALSE);
//   NWNX_Feedback_SetFeedbackMessageHidden(NWNX_FEEDBACK_FLOATY_TEXT_STRREF, FALSE); // 93
//   or... NWNX_Player_FloatingTextStringOnCreature()

// todo: check when damage is being dealt that all the phys (& non-phys) types are adding up properly (ex: bludge & pierce dmg in same hit)

void main()
{
    struct NWNX_Damage_AttackEventData strAtk = NWNX_Damage_GetAttackEventData();
    
    // skip for any form of attack misses
    if (strAtk.iAttackResult == 2 || strAtk.iAttackResult == 4 || strAtk.iAttackResult == 8 || strAtk.iAttackResult == 9)
        return;

    int nBaseWeapon = GetBaseItemType(GetLastWeaponUsed(OBJECT_SELF));
    int nDmgType = StringToInt(Get2DAString("baseitems", "WeaponType", nBaseWeapon));
    int nCritChance = StringToInt(Get2DAString("baseitems", "CritChance", nBaseWeapon));
    float fCritMulti = StringToFloat(Get2DAString("baseitems", "CritHitMult", nBaseWeapon));

    // convert the weapon's base damage to a damage type for immunity & resistance & vulnerability calculations later
    case (nDmgType) {
        case 1:
            strAtk.iPierce = strAtk.iBase;
            break;
        case 2:
            strAtk.iBludgeoning = strAtk.iBase;
            break;
        case 3:
            strAtk.iSlash = strAtk.iBase;
            break;
        default:
            WriteTimestampedLogEntry("WARNING: baseitem.2da row '" + IntToString(nBaseWeapon) + "' column 'WeaponType' value is out of acceptable bounds of 1 to 3; recieved '" + IntToString(nDmgType) + "'");
    }
    strAtk.iBase = 0;

    // convert attack to crit if successful roll, and it should give appropriate overhead feedback text for criticals
    // attacks internally never crit; we calculate and create creates with this script manually for more control
    if (d100() <= nCritChance)
        strAtk.iAttackResult = 3;

    // make sure any damage bonuses from gear get added to the attack's damage
    for (i = 0; i <= NUM_INVENTORY_SLOTS; i++) {
        // we only want arrows, bolts, or bullets included in itemproperty calculations if using an appropriate weapon
        switch (nBaseWeapon) {
            case BASE_ITEM_LIGHTCROSSBOW:
                if (i == INVENTORY_SLOT_ARROWS || i = INVENTORY_SLOT_BULLETS)
                    continue;
                break;
            case BASE_ITEM_SHORTBOW:
                if (i == INVENTORY_SLOT_BOLTS || i = INVENTORY_SLOT_BULLETS)
                    continue;
                break;
            case BASE_ITEM_LONGBOW:
                if (i == INVENTORY_SLOT_BOLTS || i = INVENTORY_SLOT_BULLETS)
                    continue;
                break;
            default:
                if (i == INVENTORY_SLOT_BOLTS || i = INVENTORY_SLOT_BOLTS || i = INVENTORY_SLOT_BULLETS)
                    continue;
        }

        object oItem = GetItemInSlot(i);

        itemproperty ipProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ipProp)) {
            int nPropType = GetItemPropertyType(ipProp);
            // these below may be invalid if nPropType isn't what we expect, but it's okay because we account for it through ifs below
            int nLawChaos = GetAlignmentLawChaos(strAtk.oTarget);
            int nGoodEvil = GetAlignmentGoodEvil(strAtk.oTarget);
            int nRace = GetRacialType(strAtk.oTarget);

            // purely a safety check to ensure we account for additional races added to the damage itemproperties list within the attack script, because we can't use a switch here
            // this will be the last racialtype entry from itempropdef.2da
            if (nPropType > ITEM_PROPERTY_DAMAGE_VS_DRAGONS)
                WriteTimestampedLogEntry("WARNING: itempropdef.2da row '" + IntToString(nPropType) + "' isn't being accounted for within the attack script, current logic allows up to row '" + IntToString(ITEM_PROPERTY_DAMAGE_VS_DRAGONS) + "'; add checks in the script for this new entry");

            if (nPropType == ITEM_PROPERTY_DAMAGE_VS_ALL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_NEUTRAL && (nLawChaos == ALIGNMENT_NEUTRAL || nGoodEvil == ALIGNMENT_NEUTRAL) ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_LAWFUL && nLawChaos == ALIGNMENT_LAWFUL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_CHAOTIC && nLawChaos = ALIGNMENT_CHAOTIC ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_GOOD && nGoodEvil = ALIGNMENT_GOOD ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_EVIL && nGoodEvil = ALIGNMENT_EVIL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_LAWFUL_GOOD && nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_GOOD ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_LAWFUL_NEUTRAL && nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_NEUTRAL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_LAWFUL_EVIL && nLawChaos == ALIGNMENT_LAWFUL && nGoodEvil == ALIGNMENT_EVIL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_NEUTRAL_GOOD && nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_GOOD ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_TRUE_NEUTRAL && nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_NEUTRAL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_NEUTRAL_EVIL && nLawChaos == ALIGNMENT_NEUTRAL && nGoodEvil == ALIGNMENT_EVIL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_CHAOTIC_GOOD && nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_GOOD ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_CHAOTIC_NEUTRAL && nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_NEUTRAL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_CHAOTIC_EVIL && nLawChaos == ALIGNMENT_CHAOTIC && nGoodEvil == ALIGNMENT_EVIL ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_HUMANS && nRace = RACIAL_TYPE_HUMAN ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_ELVES && nRace = RACIAL_TYPE_ELF ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_DWARVES && nRace = RACIAL_TYPE_DWARF ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_VERMIN && nRace = RACIAL_TYPE_VERMIN ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_UNDEAD && nRace = RACIAL_TYPE_UNDEAD ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_BEASTS && nRace = RACIAL_TYPE_BEAST ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_CONSTRUCTS && nRace = RACIAL_TYPE_CONSTRUCT ||
                nPropType == ITEM_PROPERTY_DAMAGE_VS_DRAGONS && nRace = RACIAL_TYPE_DRAGON )
            {
                int nDmgRow = GetItemPropertySubType(ipProp);
                int nNumDice = StringToInt(Get2DAString("iprp_dmgvalues", "NumDice", nDmgRow));
                int nDieToRoll = StringToInt(Get2DAString("iprp_dmgvalues", "DieToRoll", nDmgRow));

                // calculate damage roll of the itemproperty
                int nDmg;
                for (j = 0; j <= nNumDice; j++) {
                    if (strAtk.iAttackResult = 3) {
                        // if the crit would end up rolling for the same die as a non-crit, add +1 to die (1d2->1d3, 2d2->2d3, etc)
                        int nNewDieToRoll = nDieToRoll * fCritMulti;
                        if (nNewDieToRoll == nDieToRoll)
                            nNewDieToRoll++;
                        nDmg += nNumDice * Random(nNewDieToRoll+1);
                    } else
                        nDmg += nNumDice * Random(nDieToRoll+1);
                }

                // assign the damage to the appropriate damage type as determined by the itemproperty
                // todo: check if "default" damage values are -1 or 0; if -1, we'll need to reword some of our logic to account for it
                int nDmgType = GetItemPropertyCostTableValue(ipProp);
                switch (nDmgType) {
                    case 0: // bludging
                        strAtk.iBludgeoning += nDmg;
                        break;
                    case 1: // piercing
                        strAtk.iPierce += nDmg;
                        break;
                    case 2: // slashing
                        strAtk.iSlash += nDmg;
                        break;
                    case 3: // fire
                        strAtk.iFire += nDmg;
                        break;
                    case 4: // cold
                        strAtk.iCold += nDmg;
                        break;
                    case 5: // elec
                        strAtk.iElectrical += nDmg;
                        break;
                    case 6: // acid
                        strAtk.iAcid += nDmg;
                        break;
                    case 7: // positive
                        strAtk.iPositive += nDmg;
                        break;
                    case 8: // negative
                        strAtk.iNegative += nDmg;
                        break;
                    case 9: // divine
                        strAtk.iDivine += nDmg;
                        break;
                    case 10: // occult
                        strAtk.iMagical += nDmg;
                        break;
                }
            }

            ipProp = GetNextItemProperty(oItem);
        }
    }
}