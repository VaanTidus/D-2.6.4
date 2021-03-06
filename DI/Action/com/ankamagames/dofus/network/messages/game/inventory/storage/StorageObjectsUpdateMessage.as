﻿package com.ankamagames.dofus.network.messages.game.inventory.storage
{
    import __AS3__.vec.*;
    import com.ankamagames.dofus.network.types.game.data.items.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class StorageObjectsUpdateMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var objectList:Vector.<ObjectItem>;
        public static const protocolId:uint = 6036;

        public function StorageObjectsUpdateMessage()
        {
            this.objectList = new Vector.<ObjectItem>;
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6036;
        }// end function

        public function initStorageObjectsUpdateMessage(param1:Vector.<ObjectItem> = null) : StorageObjectsUpdateMessage
        {
            this.objectList = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.objectList = new Vector.<ObjectItem>;
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
            this.serializeAs_StorageObjectsUpdateMessage(param1);
            return;
        }// end function

        public function serializeAs_StorageObjectsUpdateMessage(param1:IDataOutput) : void
        {
            param1.writeShort(this.objectList.length);
            var _loc_2:uint = 0;
            while (_loc_2 < this.objectList.length)
            {
                
                (this.objectList[_loc_2] as ObjectItem).serializeAs_ObjectItem(param1);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_StorageObjectsUpdateMessage(param1);
            return;
        }// end function

        public function deserializeAs_StorageObjectsUpdateMessage(param1:IDataInput) : void
        {
            var _loc_4:ObjectItem = null;
            var _loc_2:* = param1.readUnsignedShort();
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = new ObjectItem();
                _loc_4.deserialize(param1);
                this.objectList.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

    }
}
