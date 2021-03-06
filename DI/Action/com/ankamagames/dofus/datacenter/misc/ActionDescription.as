﻿package com.ankamagames.dofus.datacenter.misc
{
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.interfaces.*;

    public class ActionDescription extends Object implements IDataCenter
    {
        public var id:uint;
        public var typeId:uint;
        public var name:String;
        public var descriptionId:uint;
        public var trusted:Boolean;
        public var needInteraction:Boolean;
        public var maxUsePerFrame:uint;
        public var minimalUseInterval:uint;
        public var needConfirmation:Boolean;
        private var _name:String;
        private var _description:String;
        public static const MODULE:String = "ActionDescriptions";
        private static var _actionByName:Array;

        public function ActionDescription()
        {
            return;
        }// end function

        public function get description() : String
        {
            if (!this._description)
            {
                this._description = I18n.getText(this.descriptionId);
            }
            return this._description;
        }// end function

        public static function getActionDescriptionByName(param1:String) : ActionDescription
        {
            var _loc_2:Array = null;
            var _loc_3:ActionDescription = null;
            if (!_actionByName)
            {
                _actionByName = new Array();
                _loc_2 = GameData.getObjects(MODULE);
                for each (_loc_3 in _loc_2)
                {
                    
                    _actionByName[_loc_3.name] = _loc_3;
                }
            }
            return _actionByName[param1];
        }// end function

    }
}
