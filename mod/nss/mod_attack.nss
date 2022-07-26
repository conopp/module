#include "nwnx_damage"

// we expect baseitems.2da->CritThreat to be 0 for all weapons, so we don't have to account for superfluous crits in this script
// todo: account for resistances within the script; see todo.txt
// todo: account for arrows & bolts damage if GetLastWeaponUsed() is a crossbow / shortbow / longbow
void main()
{
    struct NWNX_Damage_AttackEventData data = NWNX_Damage_GetAttackEventData();

    if (data.iAttackResult == 2 || data.iAttackResult == 4 || data.iAttackResult == 8 || data.iAttackResult == 9)
        return;

    int nWeapon = GetBaseItemType(GetLastWeaponUsed(OBJECT_SELF));
    int nCritChance = StringToInt(Get2DAString("baseitems", "CritChance", nWeapon));
    int nCritMulti = StringToInt(Get2DAString("baseitems", "CritHitMult", nWeapon));

    // in the case the damage type was -1 or 0 originally, we want to preserve whether it's shown or not in the combat log
    if (data.iBludgeoning > 0)
        data.iBludgeoning *= nCritMulti;
    if (data.iPierce > 0)
        data.iPierce *= nCritMulti;
    if (data.iSlash > 0)
        data.iSlash *= nCritMulti;
    if (data.iMagical > 0)
        data.iMagical *= nCritMulti;
    if (data.iAcid > 0)
        data.iAcid *= nCritMulti;
    if (data.iCold > 0)
        data.iCold *= nCritMulti;
    if (data.iDivine > 0)
        data.iDivine *= nCritMulti;
    if (data.iElectrical > 0)
        data.iElectrical *= nCritMulti;
    if (data.iFire > 0)
        data.iFire *= nCritMulti;
    if (data.iNegative > 0)
        data.iNegative *= nCritMulti;
    if (data.iPositive > 0)
        data.iPositive *= nCritMulti;
    if (data.iSonic > 0)
        data.iSonic *= nCritMulti;
    if (data.iBase > 0)
        data.iBase *= nCritMulti;
}