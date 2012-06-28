﻿package com.ankamagames.berilia.components
{
    import com.ankamagames.berilia.*;
    import com.ankamagames.berilia.types.graphic.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.jerakine.utils.display.spellZone.*;

    public class SpellZoneComponent extends GraphicContainer implements FinalizableUIComponent
    {
        private var _cellWidth:Number;
        private var _cellHeight:Number;
        private var _spellRange:uint;
        private var _centerCellId:uint;
        private var _verticalCells:uint;
        private var _horizontalCells:uint;
        private var _cellRatio:Number = 2;
        private var _spellZoneManager:SpellZoneCellManager;
        private var _spellLevel:ICellZoneProvider;
        private var _infiniteLabel:Label;
        private var _minRange:uint;
        private var _maxRange:uint;
        private var _infiniteRange:Boolean = false;
        private var _finalized:Boolean;

        public function SpellZoneComponent()
        {
            disabled = false;
            this._spellZoneManager = new SpellZoneCellManager();
            addChild(this._spellZoneManager);
            return;
        }// end function

        public function setSpellLevel(param1:ICellZoneProvider) : void
        {
            var _loc_5:Object = null;
            this._spellLevel = param1;
            this._spellZoneManager.spellLevel = this._spellLevel;
            var _loc_2:* = this._spellLevel.minimalRange == 0 && this._spellLevel.maximalRange == 0 || this._spellLevel.maximalRange == 63;
            var _loc_3:Boolean = false;
            var _loc_4:Boolean = true;
            for each (_loc_5 in this._spellLevel.spellZoneEffects)
            {
                
                if (!(_loc_5.zoneSize == 0 && _loc_5.zoneShape == 80))
                {
                    _loc_4 = false;
                }
            }
            if (_loc_2 && !_loc_4 || _loc_3)
            {
                this._infiniteRange = false;
                return;
            }
            this._infiniteRange = false;
            this.setRange(this._spellLevel.minimalRange, this._spellLevel.maximalRange);
            return;
        }// end function

        private function setRange(param1:uint, param2:uint) : void
        {
            var _loc_3:uint = 0;
            var _loc_4:IZoneShape = null;
            this._minRange = param1;
            this._maxRange = param2;
            this._horizontalCells = this._maxRange + 2 + 1;
            if (this._spellLevel)
            {
                _loc_3 = 0;
                for each (_loc_4 in this._spellLevel.spellZoneEffects)
                {
                    
                    if (_loc_3 < _loc_4.zoneSize / 2 && _loc_4.zoneSize != 63)
                    {
                        _loc_3 = _loc_4.zoneSize;
                    }
                }
                this._horizontalCells = this._horizontalCells + _loc_3;
            }
            if (this._horizontalCells % 2 == 0)
            {
                var _loc_5:String = this;
                var _loc_6:* = this._horizontalCells + 1;
                _loc_5._horizontalCells = _loc_6;
            }
            if (this._horizontalCells > 14)
            {
                this._horizontalCells = 14;
            }
            this._verticalCells = this._horizontalCells * 2 - 1;
            if (this._verticalCells > 20)
            {
                this._verticalCells = 20;
            }
            this._centerCellId = this.getCenterCellId(this._horizontalCells);
            return;
        }// end function

        public function removeCells() : void
        {
            this._spellZoneManager.remove();
            return;
        }// end function

        public function get finalized() : Boolean
        {
            return this._finalized;
        }// end function

        public function set finalized(param1:Boolean) : void
        {
            this._finalized = param1;
            return;
        }// end function

        public function finalize() : void
        {
            var _loc_1:String = null;
            if (this._infiniteRange)
            {
                if (this.contains(this._spellZoneManager))
                {
                    removeChild(this._spellZoneManager);
                }
                if (this._infiniteLabel && this.contains(this._infiniteLabel))
                {
                    return;
                }
                this._infiniteLabel = new Label();
                this._infiniteLabel.width = this.width;
                this._infiniteLabel.multiline = true;
                this._infiniteLabel.wordWrap = true;
                this._infiniteLabel.css = new Uri("[config.ui.skin]css/normal.css");
                this._infiniteLabel.cssClass = "center";
                _loc_1 = I18n.getUiText("ui.common.infiniteRange");
                this._infiniteLabel.text = _loc_1;
                addChild(this._infiniteLabel);
                this._infiniteLabel.y = (height - this._infiniteLabel.height) / 2;
            }
            else
            {
                if (this._infiniteLabel && this.contains(this._infiniteLabel))
                {
                    removeChild(this._infiniteLabel);
                }
                if (!this.contains(this._spellZoneManager))
                {
                    addChild(this._spellZoneManager);
                }
                this._spellZoneManager.setDisplayZone(__width, __height);
                this._cellWidth = __width / this._horizontalCells;
                this._cellHeight = this._cellWidth / this._cellRatio;
                this._spellZoneManager.show();
                this._finalized = true;
                getUi().iAmFinalized(this);
            }
            return;
        }// end function

        override public function remove() : void
        {
            this.removeCells();
            return;
        }// end function

        private function getCenterCellId(param1:uint) : uint
        {
            var _loc_2:* = param1;
            var _loc_3:uint = 0;
            var _loc_4:* = MapPoint.fromCoords(_loc_2, _loc_3).cellId;
            return MapPoint.fromCoords(_loc_2, _loc_3).cellId;
        }// end function

    }
}
