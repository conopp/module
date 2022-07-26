#include "inc_constants"
#include "nwnx_damage"

// check gear for immunities & resistances & vulnerabilities when getting hit; mitigate damage as necessary

void main()
{
    struct NWNX_Damage_DamageEventData strDmg = NWNX_Damage_GetDamageEventData();

    for (i = 0; i <= NUM_INVENTORY_SLOTS; i++) {
        object oItem = GetItemInSlot(i);

        itemproperty ipProp = GetFirstItemProperty(oItem);
        while (GetIsItemPropertyValid(ipProp)) {
            int nPropType = GetItemPropertyType(ipProp);
            // these below may be invalid if nPropType isn't what we expect, but it's okay because we account for it through ifs below
            int nSubtype = GetItemPropertySubType(ipProp);
            int nDmgType = GetItemPropertyCostTableValue(ipProp);



            // todo: insert compound if statements to check if nPropType is a specific type and damage exists for the dmgtype of the imm/res/vuln
            // todo: current logic implies we can't have both immunity & vulnerability; make it so both are allowed on same item (and that they stack)
            // todo: set immunity & vulnerability values in .2da's (& .tlk) to 100 each
            // new damage types aren't supported, so we shouldn't ever be adding any (if anything, we might remove some)
            switch (nPropType) {
                case ITEM_PROPERTY_DAMAGE_IMMUNITY: {
                    if (nDmgType == DAMAGE_TYPE_BLUDGEONING && strDmg.iBludgeoning > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_PIERCING && strDmg.iPierce > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_SLASHING && strDmg.iSlash > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_FIRE && strDmg.iFire > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_COLD && strDmg.iCold > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ELEC && strDmg.iElectrical > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ACID && strDmg.iAcid > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_POSITIVE && strDmg.iPositive > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_NEGATIVE && strDmg.iNegative > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_DIVINE && strDmg.iDivine > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_OCCULT && strDmg.iMagical > 0)
                        // todo
                }
                case ITEM_PROPERTY_DAMAGE_VULNERABILITY: {
                    if (nDmgType == DAMAGE_TYPE_BLUDGEONING && strDmg.iBludgeoning > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_PIERCING && strDmg.iPierce > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_SLASHING && strDmg.iSlash > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_FIRE && strDmg.iFire > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_COLD && strDmg.iCold > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ELEC && strDmg.iElectrical > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ACID && strDmg.iAcid > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_POSITIVE && strDmg.iPositive > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_NEGATIVE && strDmg.iNegative > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_DIVINE && strDmg.iDivine > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_OCCULT && strDmg.iMagical > 0)
                        // todo
                    break;
                }
                case ITEM_PROPERTY_DAMAGE_RESISTANCE: {
                    if (nDmgType == DAMAGE_TYPE_BLUDGEONING && strDmg.iBludgeoning > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_PIERCING && strDmg.iPierce > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_SLASHING && strDmg.iSlash > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_FIRE && strDmg.iFire > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_COLD && strDmg.iCold > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ELEC && strDmg.iElectrical > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_ACID && strDmg.iAcid > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_POSITIVE && strDmg.iPositive > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_NEGATIVE && strDmg.iNegative > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_DIVINE && strDmg.iDivine > 0)
                        // todo
                    else if (nDmgType == DAMAGE_TYPE_OCCULT && strDmg.iMagical > 0)
                        // todo
                    break;
                }
            }
        }
    }
}