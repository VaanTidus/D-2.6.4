﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.spell
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class SpellUpgradeSuccessMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var spellId:int = 0;
        public var spellLevel:int = 0;
        public static const protocolId:uint = 1201;

        public function SpellUpgradeSuccessMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 1201;
        }// end function

        public function initSpellUpgradeSuccessMessage(param1:int = 0, param2:int = 0) : SpellUpgradeSuccessMessage
        {
            this.spellId = param1;
            this.spellLevel = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.spellId = 0;
            this.spellLevel = 0;
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
            this.serializeAs_SpellUpgradeSuccessMessage(param1);
            return;
        }// end function

        public function serializeAs_SpellUpgradeSuccessMessage(param1:IDataOutput) : void
        {
            param1.writeInt(this.spellId);
            if (this.spellLevel < 1 || this.spellLevel > 6)
            {
                throw new Error("Forbidden value (" + this.spellLevel + ") on element spellLevel.");
            }
            param1.writeByte(this.spellLevel);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_SpellUpgradeSuccessMessage(param1);
            return;
        }// end function

        public function deserializeAs_SpellUpgradeSuccessMessage(param1:IDataInput) : void
        {
            this.spellId = param1.readInt();
            this.spellLevel = param1.readByte();
            if (this.spellLevel < 1 || this.spellLevel > 6)
            {
                throw new Error("Forbidden value (" + this.spellLevel + ") on element of SpellUpgradeSuccessMessage.spellLevel.");
            }
            return;
        }// end function

    }
}
