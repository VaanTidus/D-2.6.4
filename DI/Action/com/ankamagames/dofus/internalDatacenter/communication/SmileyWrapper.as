﻿package com.ankamagames.dofus.internalDatacenter.communication
{
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.types.*;
    import flash.utils.*;

    public class SmileyWrapper extends Proxy implements IDataCenter, ISlotData
    {
        private var _uri:Uri;
        public var id:uint = 0;
        public var iconId:int;
        public var isOkForMultiUse:Boolean = false;
        public var quantity:uint = 1;
        private static var _cache:Array = new Array();
        static const _log:Logger = Log.getLogger(getQualifiedClassName(SmileyWrapper));

        public function SmileyWrapper()
        {
            return;
        }// end function

        public function get iconUri() : Uri
        {
            if (!this._uri)
            {
                this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|smiley_" + this.id);
            }
            return this._uri;
        }// end function

        public function get fullSizeIconUri() : Uri
        {
            if (!this._uri)
            {
                this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|smiley_" + this.id);
            }
            return this._uri;
        }// end function

        public function get backGroundIconUri() : Uri
        {
            return null;
        }// end function

        public function get errorIconUri() : Uri
        {
            return null;
        }// end function

        public function get info1() : String
        {
            return null;
        }// end function

        public function get timer() : int
        {
            return 0;
        }// end function

        public function get active() : Boolean
        {
            return true;
        }// end function

        public function get currentCooldown() : uint
        {
            return 0;
        }// end function

        public function get isUsable() : Boolean
        {
            return true;
        }// end function

        override function getProperty(param1)
        {
            if (isAttribute(param1))
            {
                return this[param1];
            }
            return "Error on smiley " + param1;
        }// end function

        override function hasProperty(param1) : Boolean
        {
            return isAttribute(param1);
        }// end function

        public function toString() : String
        {
            return "[SmileyWrapper#" + this.id + "]";
        }// end function

        public function addHolder(param1:ISlotDataHolder) : void
        {
            return;
        }// end function

        public function removeHolder(param1:ISlotDataHolder) : void
        {
            return;
        }// end function

        public function getIconUri(param1:Boolean = true) : Uri
        {
            if (!this._uri)
            {
                this._uri = new Uri(XmlConfig.getInstance().getEntry("config.content.path") + "gfx/smilies/assets.swf|smiley_" + this.id);
            }
            return this._uri;
        }// end function

        public static function create(param1:uint, param2:uint, param3:Boolean = true) : SmileyWrapper
        {
            var _loc_4:SmileyWrapper = null;
            if (!_cache[param1] || !param3)
            {
                _loc_4 = new SmileyWrapper;
                _loc_4.id = param1;
                if (param3)
                {
                    _cache[param1] = _loc_4;
                }
            }
            else
            {
                _loc_4 = _cache[param1];
            }
            _loc_4.iconId = param2;
            return _loc_4;
        }// end function

        public static function getSmileyWrapperById(param1:uint) : SmileyWrapper
        {
            return _cache[param1];
        }// end function

    }
}
