﻿package com.ankamagames.dofus.logic.game.common.misc.inventoryView
{
    import com.ankamagames.dofus.internalDatacenter.items.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.common.misc.*;
    import com.ankamagames.dofus.misc.lists.*;

    public class BankConsumablesView extends StorageGenericView
    {

        public function BankConsumablesView(param1:HookLock)
        {
            super(param1);
            return;
        }// end function

        override public function get name() : String
        {
            return "bankConsumables";
        }// end function

        override public function isListening(param1:ItemWrapper) : Boolean
        {
            return super.isListening(param1) && param1.category == StorageOptionManager.CONSUMABLES_CATEGORY;
        }// end function

        override public function updateView() : void
        {
            super.updateView();
            if (StorageOptionManager.getInstance().bankCategory == StorageOptionManager.CONSUMABLES_CATEGORY && !StorageOptionManager.getInstance().hasBankFilter())
            {
                _hookLock.addHook(InventoryHookList.BankViewContent, [content, InventoryManager.getInstance().bankInventory.localKamas]);
            }
            return;
        }// end function

        override public function sortField() : int
        {
            return StorageOptionManager.getInstance().sortBankField;
        }// end function

        override public function sortRevert() : Boolean
        {
            return StorageOptionManager.getInstance().sortBankRevert;
        }// end function

    }
}
