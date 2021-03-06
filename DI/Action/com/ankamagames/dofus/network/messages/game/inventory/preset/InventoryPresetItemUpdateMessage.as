﻿package com.ankamagames.dofus.network.messages.game.inventory.preset
{
    import com.ankamagames.dofus.network.types.game.inventory.preset.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class InventoryPresetItemUpdateMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var presetId:uint = 0;
        public var presetItem:PresetItem;
        public static const protocolId:uint = 6168;

        public function InventoryPresetItemUpdateMessage()
        {
            this.presetItem = new PresetItem();
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6168;
        }// end function

        public function initInventoryPresetItemUpdateMessage(param1:uint = 0, param2:PresetItem = null) : InventoryPresetItemUpdateMessage
        {
            this.presetId = param1;
            this.presetItem = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.presetId = 0;
            this.presetItem = new PresetItem();
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
            this.serializeAs_InventoryPresetItemUpdateMessage(param1);
            return;
        }// end function

        public function serializeAs_InventoryPresetItemUpdateMessage(param1:IDataOutput) : void
        {
            if (this.presetId < 0)
            {
                throw new Error("Forbidden value (" + this.presetId + ") on element presetId.");
            }
            param1.writeByte(this.presetId);
            this.presetItem.serializeAs_PresetItem(param1);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_InventoryPresetItemUpdateMessage(param1);
            return;
        }// end function

        public function deserializeAs_InventoryPresetItemUpdateMessage(param1:IDataInput) : void
        {
            this.presetId = param1.readByte();
            if (this.presetId < 0)
            {
                throw new Error("Forbidden value (" + this.presetId + ") on element of InventoryPresetItemUpdateMessage.presetId.");
            }
            this.presetItem = new PresetItem();
            this.presetItem.deserialize(param1);
            return;
        }// end function

    }
}
