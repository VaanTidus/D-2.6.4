﻿package com.ankamagames.dofus.network.messages.game.inventory.storage
{
    import com.ankamagames.dofus.network.types.game.data.items.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class StorageObjectUpdateMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var object:ObjectItem;
        public static const protocolId:uint = 5647;

        public function StorageObjectUpdateMessage()
        {
            this.object = new ObjectItem();
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5647;
        }// end function

        public function initStorageObjectUpdateMessage(param1:ObjectItem = null) : StorageObjectUpdateMessage
        {
            this.object = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.object = new ObjectItem();
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
            this.serializeAs_StorageObjectUpdateMessage(param1);
            return;
        }// end function

        public function serializeAs_StorageObjectUpdateMessage(param1:IDataOutput) : void
        {
            this.object.serializeAs_ObjectItem(param1);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_StorageObjectUpdateMessage(param1);
            return;
        }// end function

        public function deserializeAs_StorageObjectUpdateMessage(param1:IDataInput) : void
        {
            this.object = new ObjectItem();
            this.object.deserialize(param1);
            return;
        }// end function

    }
}
