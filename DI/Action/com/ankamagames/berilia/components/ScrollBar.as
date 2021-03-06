﻿package com.ankamagames.berilia.components
{
    import com.ankamagames.berilia.*;
    import com.ankamagames.berilia.enums.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.berilia.types.data.*;
    import com.ankamagames.berilia.types.graphic.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.handlers.messages.mouse.*;
    import com.ankamagames.jerakine.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.pools.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.utils.display.*;
    import flash.events.*;
    import flash.utils.*;

    public class ScrollBar extends GraphicContainer implements FinalizableUIComponent
    {
        private const _common:String;
        private var _nWidth:uint = 16;
        private var _nHeight:uint = 200;
        private var _sCss:Uri;
        private var _uriTexBack:Uri;
        private var _uriTexMin:Uri;
        private var _uriTexMax:Uri;
        private var _uriTexBox:Uri;
        private var _nMin:int;
        private var _nMax:int;
        private var _nTotal:int = 1;
        private var _nStep:uint = 1;
        private var _nCurrentValue:int = 0;
        private var _bDisabled:Boolean = false;
        private var _texBack:Texture;
        private var _texBox:Texture;
        private var _texMin:Texture;
        private var _texMax:Texture;
        private var _gcMin:GraphicContainer;
        private var _gcMax:GraphicContainer;
        private var _gcBox:GraphicContainer;
        private var _nBoxSize:Number;
        private var _nBoxPosMin:Number;
        private var _nBoxPosMax:Number;
        private var _nCurrentPos:Number = 0;
        private var _nLastPos:Number = 0;
        private var _nScrollStep:Number;
        private var _nScrollSpeed:Number = 0.333333;
        private var _squareEdge:uint;
        private var _bVertical:Boolean;
        private var _bFinalized:Boolean = false;
        private var _nDecelerateScroll:uint = 1;
        private var _nAcelerateScroll:uint = 0;
        private var _nMaxDecelerateFactor:uint = 4;
        private var _bOnDrag:Boolean = false;
        public static var MEMORY_LOG:Dictionary = new Dictionary(true);
        static const _log:Logger = Log.getLogger(getQualifiedClassName(ScrollBar));

        public function ScrollBar()
        {
            this._common = XmlConfig.getInstance().getEntry("config.ui.skin");
            MEMORY_LOG[this] = 1;
            return;
        }// end function

        override public function get width() : Number
        {
            return this._nWidth;
        }// end function

        override public function set width(param1:Number) : void
        {
            this._nWidth = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        override public function get height() : Number
        {
            return this._nHeight;
        }// end function

        override public function set height(param1:Number) : void
        {
            this._nHeight = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get css() : Uri
        {
            return this._sCss;
        }// end function

        public function set css(param1:Uri) : void
        {
            if (param1 == null)
            {
                return;
            }
            if (param1 != this._sCss)
            {
                this._sCss = param1;
                CssManager.getInstance().askCss(param1.uri, new Callback(this.fakeCssLoaded));
            }
            return;
        }// end function

        public function get min() : int
        {
            return this._nMin;
        }// end function

        public function set min(param1:int) : void
        {
            this._nMin = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get max() : int
        {
            return this._nMax;
        }// end function

        public function set max(param1:int) : void
        {
            this._nMax = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get total() : int
        {
            return this._nTotal;
        }// end function

        public function set total(param1:int) : void
        {
            this._nTotal = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get step() : uint
        {
            return this._nStep;
        }// end function

        public function set step(param1:uint) : void
        {
            this._nStep = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get value() : int
        {
            return Math.min(Math.round((this._nCurrentPos - this._nBoxPosMin) / this._nScrollStep) * this._nStep + this._nMin, this._nMax);
        }// end function

        public function set value(param1:int) : void
        {
            if (param1 > this._nMax)
            {
                param1 = this._nMax;
            }
            if (param1 < this._nMin)
            {
                param1 = this._nMin;
            }
            this._nCurrentValue = param1;
            if (this.finalized)
            {
                this._nCurrentPos = (this._nCurrentValue - this._nMin) * (this._nStep * this._nScrollStep) + this._nBoxPosMin;
                this.updateDisplayFromCurrentPos();
            }
            return;
        }// end function

        public function set scrollSpeed(param1:Number) : void
        {
            this._nScrollSpeed = param1;
            return;
        }// end function

        public function get scrollSpeed() : Number
        {
            return this._nScrollSpeed;
        }// end function

        public function get finalized() : Boolean
        {
            return this._bFinalized;
        }// end function

        public function set finalized(param1:Boolean) : void
        {
            this._bFinalized = param1;
            return;
        }// end function

        public function get boxSize() : Number
        {
            return this._nBoxSize;
        }// end function

        public function set vertical(param1:Boolean) : void
        {
            this._bVertical = param1;
            if (this.finalized)
            {
                this.scrollBarProcess();
            }
            return;
        }// end function

        public function get vertical() : Boolean
        {
            return this._bVertical;
        }// end function

        override public function set disabled(param1:Boolean) : void
        {
            if (param1 == this._bDisabled)
            {
                return;
            }
            if (param1)
            {
                if (this._texBox && this._texMin && this._texMax)
                {
                    this._texBox.visible = false;
                    this._texMax.gotoAndStop = StatesEnum.STATE_DISABLED_STRING;
                    this._texMin.gotoAndStop = StatesEnum.STATE_DISABLED_STRING;
                }
                mouseEnabled = false;
                mouseChildren = false;
            }
            else
            {
                if (this._texBox && this._texMin && this._texMax)
                {
                    this._texBox.visible = true;
                    this._texMax.gotoAndStop = StatesEnum.STATE_NORMAL_STRING;
                    this._texMin.gotoAndStop = StatesEnum.STATE_NORMAL_STRING;
                }
                mouseEnabled = true;
                mouseChildren = true;
            }
            this._bDisabled = param1;
            return;
        }// end function

        public function finalize() : void
        {
            if (this._sCss)
            {
                if (this._nHeight > this._nWidth)
                {
                    this._bVertical = true;
                }
                else
                {
                    this._bVertical = false;
                }
                CssManager.getInstance().askCss(this._sCss.uri, new Callback(this.onCssLoaded));
            }
            return;
        }// end function

        private function scrollBarInit() : void
        {
            var _loc_1:Array = null;
            var _loc_2:Array = null;
            var _loc_3:Array = null;
            if (!this._gcMin)
            {
                this._gcMin = new ButtonContainer();
                this._gcMax = new ButtonContainer();
                this._gcBox = new ButtonContainer();
                (this._gcMin as ButtonContainer).soundId = "-1";
                (this._gcMax as ButtonContainer).soundId = "-1";
                this._texMin.name = name + "_scrollBar_buttonMin";
                this._texMin.keepRatio = true;
                getUi().registerId(this._texMin.name, new GraphicElement(this._texMin, new Array(), "buttonMin"));
                this._texMax.name = name + "_scrollBar_buttonMax";
                this._texMax.keepRatio = true;
                getUi().registerId(this._texMax.name, new GraphicElement(this._texMax, new Array(), "buttonMax"));
                this._texBox.name = name + "_scrollBar_buttonBox";
                getUi().registerId(this._texBox.name, new GraphicElement(this._texBox, new Array(), "buttonBox"));
                this._gcMin.addChild(this._texMin);
                this._gcMax.addChild(this._texMax);
                this._gcBox.addChild(this._texBox);
                _loc_1 = new Array();
                _loc_1[StatesEnum.STATE_OVER] = new Array();
                _loc_1[StatesEnum.STATE_OVER][this._texBox.name] = new Array();
                _loc_1[StatesEnum.STATE_OVER][this._texBox.name]["gotoAndStop"] = StatesEnum.STATE_OVER_STRING.toLocaleLowerCase();
                _loc_1[StatesEnum.STATE_CLICKED] = new Array();
                _loc_1[StatesEnum.STATE_CLICKED][this._texBox.name] = new Array();
                _loc_1[StatesEnum.STATE_CLICKED][this._texBox.name]["gotoAndStop"] = StatesEnum.STATE_CLICKED_STRING.toLocaleLowerCase();
                _loc_2 = new Array();
                _loc_2[StatesEnum.STATE_OVER] = new Array();
                _loc_2[StatesEnum.STATE_OVER][this._texMin.name] = new Array();
                _loc_2[StatesEnum.STATE_OVER][this._texMin.name]["gotoAndStop"] = StatesEnum.STATE_OVER_STRING.toLocaleLowerCase();
                _loc_2[StatesEnum.STATE_CLICKED] = new Array();
                _loc_2[StatesEnum.STATE_CLICKED][this._texMin.name] = new Array();
                _loc_2[StatesEnum.STATE_CLICKED][this._texMin.name]["gotoAndStop"] = StatesEnum.STATE_CLICKED_STRING.toLocaleLowerCase();
                _loc_3 = new Array();
                _loc_3[StatesEnum.STATE_OVER] = new Array();
                _loc_3[StatesEnum.STATE_OVER][this._texMax.name] = new Array();
                _loc_3[StatesEnum.STATE_OVER][this._texMax.name]["gotoAndStop"] = StatesEnum.STATE_OVER_STRING.toLocaleLowerCase();
                _loc_3[StatesEnum.STATE_CLICKED] = new Array();
                _loc_3[StatesEnum.STATE_CLICKED][this._texMax.name] = new Array();
                _loc_3[StatesEnum.STATE_CLICKED][this._texMax.name]["gotoAndStop"] = StatesEnum.STATE_CLICKED_STRING.toLocaleLowerCase();
                ButtonContainer(this._gcBox).changingStateData = _loc_1;
                ButtonContainer(this._gcMin).changingStateData = _loc_2;
                ButtonContainer(this._gcMax).changingStateData = _loc_3;
            }
            this.finalized = true;
            this.scrollBarProcess();
            getUi().iAmFinalized(this);
            return;
        }// end function

        private function scrollBarProcess() : void
        {
            var _loc_1:* = Math.max(this._nWidth, this._nHeight);
            this._squareEdge = Math.min(this._nWidth, this._nHeight);
            this._nBoxSize = (_loc_1 - 2 * this._squareEdge) * ((this._nTotal - this._nMax) / this._nTotal);
            if (this._nBoxSize < 10)
            {
                this._nBoxSize = (_loc_1 - 2 * this._squareEdge - (this._nMax - this._nMin + 1)) * this._nStep;
            }
            if (this._nBoxSize < this._squareEdge)
            {
                this._nBoxSize = this._squareEdge;
            }
            this._nBoxPosMin = this._squareEdge - 6;
            this._nBoxPosMax = int(_loc_1 - this._squareEdge - this._nBoxSize);
            this._nScrollStep = (_loc_1 - 2 * this._squareEdge + 6 - this._nBoxSize) / (this._nMax - this._nMin);
            this._nLastPos = this._nCurrentPos;
            if (this._nCurrentValue > this._nMax)
            {
                this._nCurrentValue = this._nMax;
            }
            if (this._nCurrentValue < this._nMin)
            {
                this._nCurrentValue = this._nMin;
            }
            this._nCurrentPos = (this._nCurrentValue - this._nMin) / this._nStep * this._nScrollStep + this._nBoxPosMin;
            if (this._nCurrentValue != 0)
            {
                this.updateDisplayFromCurrentPos();
            }
            if (!this._texBack.finalized)
            {
                this._texBack.autoGrid = true;
                this._texBack.width = this._nWidth;
                this._texBack.height = this._nHeight - this._squareEdge * 0.4;
                this._texBack.x = 0;
                this._texBack.y = 0;
                this._texBack.finalize();
                addChild(this._texBack);
            }
            else
            {
                this._texBack.width = this._nWidth;
                this._texBack.height = this._nHeight - this._squareEdge * 0.4;
            }
            if (!this._texMin.finalized)
            {
                if (this._bVertical)
                {
                    this._texMin.width = this._squareEdge;
                }
                else
                {
                    this._texMin.height = this._squareEdge;
                }
                this._texMin.dispatchMessages = true;
                this._texMin.finalize();
                addChild(this._gcMin);
            }
            else if (this._bVertical)
            {
                this._texMin.width = this._squareEdge;
            }
            else
            {
                this._texMin.height = this._squareEdge;
            }
            if (!this._texMax.finalized)
            {
                if (this._bVertical)
                {
                    this._texMax.width = this._squareEdge;
                }
                else
                {
                    this._texMax.height = this._squareEdge;
                }
                this._texMax.dispatchMessages = true;
                this._texMax.finalize();
                this._gcMax.x = this._bVertical ? (0) : (this._nWidth - this._squareEdge);
                this._gcMax.y = this._bVertical ? (this._nHeight - this._squareEdge) : (0);
                addChild(this._gcMax);
            }
            else
            {
                if (this._bVertical)
                {
                    this._texMax.width = this._squareEdge;
                }
                else
                {
                    this._texMax.height = this._squareEdge;
                }
                this._gcMax.x = this._bVertical ? (0) : (this._nWidth - this._squareEdge);
                this._gcMax.y = this._bVertical ? (this._nHeight - this._squareEdge) : (0);
            }
            if (!this._texBox.finalized)
            {
                this._texBox.width = this._bVertical ? (this._squareEdge) : (this._nBoxSize);
                this._texBox.height = this._bVertical ? (this._nBoxSize) : (this._squareEdge);
                this._texBox.autoGrid = true;
                this._texBox.finalize();
                this._gcBox.x = this._bVertical ? (0) : (this._nCurrentPos);
                this._gcBox.y = this._bVertical ? (this._nCurrentPos) : (0);
                addChild(this._gcBox);
            }
            else
            {
                this._texBox.width = this._bVertical ? (this._squareEdge) : (this._nBoxSize);
                this._texBox.height = this._bVertical ? (this._nBoxSize) : (this._squareEdge);
                this._texBox.autoGrid = true;
                this._gcBox.x = this._bVertical ? (0) : (this._nCurrentPos);
                this._gcBox.y = this._bVertical ? (this._nCurrentPos) : (0);
            }
            if (this._nMax <= this._nMin)
            {
                this._texBox.visible = false;
            }
            else
            {
                this._texBox.visible = true;
            }
            if (this._texMin.loading)
            {
                this._texMin.addEventListener(Event.COMPLETE, this.eventOnTextureReady);
            }
            else
            {
                this._texMin.gotoAndStop = this._bDisabled ? (StatesEnum.STATE_DISABLED_STRING) : (StatesEnum.STATE_NORMAL_STRING);
            }
            if (this._texMax.loading)
            {
                this._texMax.addEventListener(Event.COMPLETE, this.eventOnTextureReady);
            }
            else
            {
                this._texMax.gotoAndStop = this._bDisabled ? (StatesEnum.STATE_DISABLED_STRING) : (StatesEnum.STATE_NORMAL_STRING);
            }
            this._texBack.mouseEnabled = true;
            return;
        }// end function

        private function updateDisplayFromCurrentPos() : void
        {
            if (this._texMin && this._texMax)
            {
                if (this._bVertical)
                {
                    this._texMin.width = this._squareEdge;
                }
                else
                {
                    this._texMin.height = this._squareEdge;
                }
                if (this._bVertical)
                {
                    this._texMax.width = this._squareEdge;
                }
                else
                {
                    this._texMax.height = this._squareEdge;
                }
            }
            if (this._gcBox)
            {
                if (this._bVertical)
                {
                    this._gcBox.y = this._nCurrentPos;
                }
                else
                {
                    this._gcBox.x = this._nCurrentPos;
                }
            }
            return;
        }// end function

        private function approximate(param1:Number) : Number
        {
            return param1 + this._nMin;
        }// end function

        private function valueOfPos(param1:Number) : int
        {
            return Math.min(Math.ceil((param1 - this._nBoxPosMin) / this._nScrollStep) * this._nStep + this._nMin, this._nBoxPosMax);
        }// end function

        override public function remove() : void
        {
            if (!__removed)
            {
                EnterFrameDispatcher.removeEventListener(this.onDragRunning);
                EnterFrameDispatcher.removeEventListener(this.onBottomArrowDown);
                EnterFrameDispatcher.removeEventListener(this.onTopArrowDown);
                removeEventListener(MouseEvent.MOUSE_WHEEL, this.onWheel);
                if (this._texMax)
                {
                    this._texMax.removeEventListener(Event.COMPLETE, this.eventOnTextureReady);
                }
                if (this._texMin)
                {
                    this._texMin.addEventListener(Event.COMPLETE, this.eventOnTextureReady);
                }
                this.clear();
            }
            super.remove();
            return;
        }// end function

        private function clear() : void
        {
            if (this._gcBox != null && contains(this._gcBox))
            {
                this._texBox.remove();
                getUi().removeFromRenderList(this._texBox.name);
                this._gcBox.remove();
            }
            if (this._gcMax != null && contains(this._gcMax))
            {
                this._texMax.remove();
                getUi().removeFromRenderList(this._texMax.name);
                this._gcMax.remove();
            }
            if (this._gcMin != null && contains(this._gcMin))
            {
                this._texMin.remove();
                getUi().removeFromRenderList(this._texMin.name);
                this._gcMin.remove();
            }
            if (this._texBack != null)
            {
                this._texBack.remove();
            }
            return;
        }// end function

        override public function process(param1:Message) : Boolean
        {
            var _loc_4:Number = NaN;
            var _loc_5:IInterfaceListener = null;
            var _loc_6:IInterfaceListener = null;
            var _loc_2:* = this.value;
            var _loc_3:* = PoolsManager.getInstance().getRectanglePool().checkOut() as PoolableRectangle;
            switch(true)
            {
                case param1 is MouseDownMessage:
                {
                    switch(MouseDownMessage(param1).target)
                    {
                        case this._gcMax:
                        {
                            for each (_loc_5 in Berilia.getInstance().UISoundListeners)
                            {
                                
                                _loc_5.playUISound("16015");
                            }
                            if (this._nCurrentPos + this._nScrollStep <= this._nBoxPosMax)
                            {
                                this._nCurrentPos = this._nCurrentPos + this._nScrollStep;
                            }
                            else
                            {
                                this._nCurrentPos = this._nBoxPosMax;
                            }
                            if (_loc_2 != this.valueOfPos(this._nCurrentPos))
                            {
                                this.updateDisplayFromCurrentPos();
                                dispatchEvent(new Event(Event.CHANGE));
                            }
                            this._nDecelerateScroll = 1;
                            this._nAcelerateScroll = 0;
                            EnterFrameDispatcher.addEventListener(this.onBottomArrowDown, "ScrollBarBottomArrow");
                            break;
                        }
                        case this._gcMin:
                        {
                            for each (_loc_6 in Berilia.getInstance().UISoundListeners)
                            {
                                
                                _loc_6.playUISound("16014");
                            }
                            if (this._nCurrentPos - this._nScrollStep >= this._nBoxPosMin)
                            {
                                this._nCurrentPos = this._nCurrentPos - this._nScrollStep;
                            }
                            else
                            {
                                this._nCurrentPos = this._nBoxPosMin;
                            }
                            this.updateDisplayFromCurrentPos();
                            dispatchEvent(new Event(Event.CHANGE));
                            this._nDecelerateScroll = 1;
                            this._nAcelerateScroll = 0;
                            EnterFrameDispatcher.addEventListener(this.onTopArrowDown, "ScrollBarTopArrow");
                            break;
                        }
                        case this._texBack:
                        {
                            if (this._bVertical)
                            {
                                this._nCurrentPos = this.approximate(int(this._texBack.mouseY));
                            }
                            else
                            {
                                this._nCurrentPos = this.approximate(int(this._texBack.mouseX));
                            }
                            _loc_4 = this._nCurrentPos - this._nCurrentPos % this._nScrollStep;
                            this._nCurrentPos = _loc_4 - this._squareEdge / 2;
                            if (this._nCurrentPos > this._nBoxPosMax || this._nCurrentPos > this._nBoxPosMax - this._nScrollStep)
                            {
                                this._nCurrentPos = this._nBoxPosMax;
                            }
                            if (this._nCurrentPos < this._nBoxPosMin)
                            {
                                this._nCurrentPos = this._nBoxPosMin;
                            }
                            this.updateDisplayFromCurrentPos();
                            dispatchEvent(new Event(Event.CHANGE));
                            break;
                        }
                        case this._gcBox:
                        {
                            if (this._bVertical)
                            {
                                this._bOnDrag = true;
                                this._gcBox.startDrag(false, _loc_3.renew(this._texBack.x, this._texBack.y + this._nBoxPosMin, 0, Math.ceil(this._nBoxPosMax - this._nBoxPosMin)));
                            }
                            else
                            {
                                this._bOnDrag = true;
                                this._gcBox.startDrag(false, _loc_3.renew(this._texBack.x + this._nBoxPosMin, this._texBack.y, this._nBoxPosMax - this._nBoxPosMin, 0));
                            }
                            EnterFrameDispatcher.addEventListener(this.onDragRunning, "ScrollBarDragRunning");
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    PoolsManager.getInstance().getRectanglePool().checkIn(_loc_3);
                    return true;
                }
                case param1 is MouseUpMessage:
                {
                    switch(MouseUpMessage(param1).target)
                    {
                        case this._gcMax:
                        {
                            EnterFrameDispatcher.removeEventListener(this.onBottomArrowDown);
                            break;
                        }
                        case this._gcMin:
                        {
                            EnterFrameDispatcher.removeEventListener(this.onTopArrowDown);
                            break;
                        }
                        case this._gcBox:
                        {
                            if (this._bOnDrag)
                            {
                                this._gcBox.stopDrag();
                                this._bOnDrag = false;
                                EnterFrameDispatcher.removeEventListener(this.onDragRunning);
                                dispatchEvent(new Event(Event.CHANGE));
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    PoolsManager.getInstance().getRectanglePool().checkIn(_loc_3);
                    return true;
                }
                case param1 is MouseReleaseOutsideMessage:
                {
                    if (this._bOnDrag)
                    {
                        this._gcBox.stopDrag();
                        this._bOnDrag = false;
                        this._nCurrentPos = this._bVertical ? (this._gcBox.y) : (this._gcBox.x);
                        dispatchEvent(new Event(Event.CHANGE));
                        EnterFrameDispatcher.removeEventListener(this.onDragRunning);
                    }
                    EnterFrameDispatcher.removeEventListener(this.onBottomArrowDown);
                    EnterFrameDispatcher.removeEventListener(this.onTopArrowDown);
                    PoolsManager.getInstance().getRectanglePool().checkIn(_loc_3);
                    return true;
                }
                case param1 is MouseWheelMessage:
                {
                    addEventListener(MouseEvent.MOUSE_WHEEL, this.onWheel);
                    return true;
                }
                default:
                {
                    break;
                }
            }
            PoolsManager.getInstance().getRectanglePool().checkIn(_loc_3);
            return false;
        }// end function

        private function onDragRunning(event:Event) : void
        {
            var _loc_2:int = 0;
            var _loc_4:int = 0;
            var _loc_3:* = this.value;
            if (this._bVertical)
            {
                _loc_2 = this.approximate(int(this._gcBox.y));
                if (_loc_3 != this.valueOfPos(_loc_2))
                {
                    this._nCurrentPos = _loc_2;
                    _loc_4 = this._nHeight - this._nBoxSize;
                    if (this._nCurrentPos > _loc_4)
                    {
                        this._nCurrentPos = _loc_4;
                    }
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }
            else
            {
                _loc_2 = this.approximate(int(this._gcBox.x));
                if (_loc_3 != this.valueOfPos(_loc_2))
                {
                    this._nCurrentPos = _loc_2;
                    _loc_4 = this._nWidth - this._nBoxSize;
                    if (this._nCurrentPos > _loc_4)
                    {
                        this._nCurrentPos = _loc_4;
                    }
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }
            return;
        }// end function

        private function onTopArrowDown(event:Event) : void
        {
            var _loc_2:* = Berilia.getInstance().docMain.stage.frameRate;
            var _loc_3:* = this.value;
            if (this._nDecelerateScroll >= this._nMaxDecelerateFactor)
            {
                if (this._nCurrentPos - this._nScrollStep >= this._nBoxPosMin)
                {
                    this._nCurrentPos = this._nCurrentPos - this._nScrollStep;
                }
                else
                {
                    this._nCurrentPos = this._nBoxPosMin;
                }
                this._nDecelerateScroll = this._nAcelerateScroll < this._nMaxDecelerateFactor ? (var _loc_4:String = this, _loc_4._nAcelerateScroll = this._nAcelerateScroll + 1, this._nAcelerateScroll++) : ((this._nMaxDecelerateFactor - 1));
                if (_loc_3 != this.valueOfPos(this._nCurrentPos))
                {
                    this.updateDisplayFromCurrentPos();
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }
            var _loc_4:String = this;
            var _loc_5:* = this._nDecelerateScroll + 1;
            _loc_4._nDecelerateScroll = _loc_5;
            return;
        }// end function

        private function onBottomArrowDown(event:Event) : void
        {
            var _loc_2:* = Berilia.getInstance().docMain.stage.frameRate;
            var _loc_3:* = this.value;
            var _loc_4:* = this._nCurrentPos;
            if (this._nDecelerateScroll >= this._nMaxDecelerateFactor)
            {
                if (this._nCurrentPos + this._nScrollStep <= this._nBoxPosMax)
                {
                    this._nCurrentPos = this._nCurrentPos + this._nScrollStep;
                }
                else
                {
                    this._nCurrentPos = this._nBoxPosMax;
                }
                this._nDecelerateScroll = this._nAcelerateScroll < this._nMaxDecelerateFactor ? (var _loc_5:String = this, _loc_5._nAcelerateScroll = this._nAcelerateScroll + 1, this._nAcelerateScroll++) : ((this._nMaxDecelerateFactor - 1));
                if (_loc_4 != this._nCurrentPos)
                {
                    this.updateDisplayFromCurrentPos();
                    dispatchEvent(new Event(Event.CHANGE));
                }
            }
            var _loc_5:String = this;
            var _loc_6:* = this._nDecelerateScroll + 1;
            _loc_5._nDecelerateScroll = _loc_6;
            return;
        }// end function

        public function onWheel(event:MouseEvent) : void
        {
            this._nCurrentPos = this._nCurrentPos - this._nScrollStep * (event.delta * this._nScrollSpeed);
            if (this._nCurrentPos > this._nBoxPosMax)
            {
                this._nCurrentPos = Math.floor(this._nBoxPosMax);
            }
            if (this._nCurrentPos < this._nBoxPosMin)
            {
                this._nCurrentPos = this._nBoxPosMin;
            }
            this.updateDisplayFromCurrentPos();
            dispatchEvent(new Event(Event.CHANGE));
            return;
        }// end function

        private function fakeCssLoaded() : void
        {
            return;
        }// end function

        private function onCssLoaded() : void
        {
            var _loc_1:ExtendedStyleSheet = null;
            var _loc_2:Object = null;
            if (!this._gcMin)
            {
                _loc_1 = CssManager.getInstance().getCss(this._sCss.uri);
                _loc_2 = _loc_1.getStyle(".skin");
                this._uriTexBack = new Uri(this._common + _loc_2["textureBack"]);
                this._uriTexBox = new Uri(this._common + _loc_2["textureBox"]);
                this._uriTexMax = new Uri(this._common + _loc_2["textureMax"]);
                this._uriTexMin = new Uri(this._common + _loc_2["textureMin"]);
                this._texBack = new Texture();
                this._texBack.uri = this._uriTexBack;
                this._texBox = new Texture();
                this._texBox.uri = this._uriTexBox;
                this._texMin = new Texture();
                this._texMin.uri = this._uriTexMin;
                this._texMax = new Texture();
                this._texMax.uri = this._uriTexMax;
            }
            this.scrollBarInit();
            return;
        }// end function

        public function eventOnTextureReady(event:Event) : void
        {
            if (event.target == this._texMin)
            {
                this._texMin.gotoAndStop = this._bDisabled ? (StatesEnum.STATE_DISABLED_STRING.toLowerCase()) : (StatesEnum.STATE_NORMAL_STRING.toLowerCase());
            }
            else if (event.target == this._texMax)
            {
                this._texMax.gotoAndStop = this._bDisabled ? (StatesEnum.STATE_DISABLED_STRING.toLowerCase()) : (StatesEnum.STATE_NORMAL_STRING.toLowerCase());
            }
            return;
        }// end function

    }
}
