﻿package com.ankamagames.dofus.network.messages.game.inventory
{
    import __AS3__.vec.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class ObjectAveragePricesMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var ids:Vector.<uint>;
        public var avgPrices:Vector.<uint>;
        public static const protocolId:uint = 6335;

        public function ObjectAveragePricesMessage()
        {
            this.ids = new Vector.<uint>;
            this.avgPrices = new Vector.<uint>;
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6335;
        }// end function

        public function initObjectAveragePricesMessage(param1:Vector.<uint> = null, param2:Vector.<uint> = null) : ObjectAveragePricesMessage
        {
            this.ids = param1;
            this.avgPrices = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.ids = new Vector.<uint>;
            this.avgPrices = new Vector.<uint>;
            this._isInitialized = false;
            return;
        }// end function

        override public function pack(param1:IDataOutput) : void
        {
            var _loc_2:* = new ByteArray();
            this.serialize(_loc_2);
            writePacket(param1, this.getMessageId(), _loc_2);
            return;
        }// end function

        override public function unpack(param1:IDataInput, param2:uint) : void
        {
            this.deserialize(param1);
            return;
        }// end function

        public function serialize(param1:IDataOutput) : void
        {
            this.serializeAs_ObjectAveragePricesMessage(param1);
            return;
        }// end function

        public function serializeAs_ObjectAveragePricesMessage(param1:IDataOutput) : void
        {
            param1.writeShort(this.ids.length);
            var _loc_2:uint = 0;
            while (_loc_2 < this.ids.length)
            {
                
                if (this.ids[_loc_2] < 0)
                {
                    throw new Error("Forbidden value (" + this.ids[_loc_2] + ") on element 1 (starting at 1) of ids.");
                }
                param1.writeShort(this.ids[_loc_2]);
                _loc_2 = _loc_2 + 1;
            }
            param1.writeShort(this.avgPrices.length);
            var _loc_3:uint = 0;
            while (_loc_3 < this.avgPrices.length)
            {
                
                if (this.avgPrices[_loc_3] < 0)
                {
                    throw new Error("Forbidden value (" + this.avgPrices[_loc_3] + ") on element 2 (starting at 1) of avgPrices.");
                }
                param1.writeInt(this.avgPrices[_loc_3]);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_ObjectAveragePricesMessage(param1);
            return;
        }// end function

        public function deserializeAs_ObjectAveragePricesMessage(param1:IDataInput) : void
        {
            var _loc_6:uint = 0;
            var _loc_7:uint = 0;
            var _loc_2:* = param1.readUnsignedShort();
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_6 = param1.readShort();
                if (_loc_6 < 0)
                {
                    throw new Error("Forbidden value (" + _loc_6 + ") on elements of ids.");
                }
                this.ids.push(_loc_6);
                _loc_3 = _loc_3 + 1;
            }
            var _loc_4:* = param1.readUnsignedShort();
            var _loc_5:uint = 0;
            while (_loc_5 < _loc_4)
            {
                
                _loc_7 = param1.readInt();
                if (_loc_7 < 0)
                {
                    throw new Error("Forbidden value (" + _loc_7 + ") on elements of avgPrices.");
                }
                this.avgPrices.push(_loc_7);
                _loc_5 = _loc_5 + 1;
            }
            return;
        }// end function

    }
}
