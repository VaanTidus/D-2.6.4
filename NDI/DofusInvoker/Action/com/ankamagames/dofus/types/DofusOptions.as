﻿package com.ankamagames.dofus.types
{
    import com.ankamagames.dofus.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.jerakine.managers.*;

    dynamic public class DofusOptions extends OptionManager
    {

        public function DofusOptions()
        {
            super("dofus");
            add("optimize", false);
            add("cacheMapEnabled", true);
            add("optimizeMultiAccount", true);
            add("showEveryMonsters", false);
            add("turnPicture", true);
            add("mapCoordinates", true);
            add("showEntityInfos", true);
            add("showMovementRange", false);
            add("showLineOfSight", true);
            add("remindTurn", true);
            add("showGlowOverTarget", true);
            add("confirmItemDrop", true);
            add("switchUiSkin", "dofus1");
            add("allowBannerShortcuts", true);
            add("dofusQuality", 1);
            add("askForQualitySelection", true);
            add("showNotifications", true);
            add("showUsedPaPm", false);
            add("largeTooltipDelay", 600);
            add("displayTooltips", true);
            add("allowSpellEffects", true);
            add("allowHitAnim", true);
            add("legalAgreementEula", "fr#0");
            add("legalAgreementTou", "fr#0");
            add("legalAgreementModsTou", "fr#0");
            add("allowLog", BuildInfos.BUILD_TYPE != BuildTypeEnum.RELEASE);
            add("flashQuality", 2);
            add("cellSelectionOnly", false);
            add("orderFighters", false);
            add("showAlignmentWings", false);
            add("showTacticMode", false);
            add("showMovementDistance", false);
            add("hideDeadFighters", true);
            add("hideSummonedFighters", false);
            add("mapFilters", 0);
            add("showLogPvDetails", true);
            return;
        }// end function

    }
}
