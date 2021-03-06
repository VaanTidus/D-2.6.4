﻿package com.ankamagames.berilia.types.uiDefinition
{

    public class BasicElement extends Object
    {
        public var name:String;
        public var strata:uint = 1;
        public var size:SizeElement;
        public var minSize:SizeElement;
        public var maxSize:SizeElement;
        public var anchors:Array;
        public var event:Array;
        public var properties:Array;
        public var className:String;
        public var cachedWidth:int = 2.14748e+009;
        public var cachedHeight:int = 2.14748e+009;
        public var cachedX:int = 2.14748e+009;
        public var cachedY:int = 2.14748e+009;

        public function BasicElement()
        {
            this.event = new Array();
            this.properties = new Array();
            return;
        }// end function

        public function setName(param1:String) : void
        {
            this.name = param1;
            this.properties["name"] = param1;
            return;
        }// end function

        public function copy(param1:BasicElement) : void
        {
            var _loc_2:String = null;
            param1.strata = this.strata;
            param1.size = this.size;
            param1.minSize = this.minSize;
            param1.maxSize = this.maxSize;
            param1.anchors = this.anchors;
            param1.event = this.event;
            param1.properties = [];
            for (_loc_2 in this.properties)
            {
                
                param1.properties[_loc_2] = this.properties[_loc_2];
            }
            param1.className = this.className;
            param1.cachedWidth = this.cachedWidth;
            param1.cachedHeight = this.cachedHeight;
            param1.cachedX = this.cachedX;
            param1.cachedY = this.cachedY;
            param1.setName(this.name);
            return;
        }// end function

    }
}
