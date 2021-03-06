﻿package com.ankamagames.dofus.network.messages.game.guild
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GuildSpellUpgradeRequestMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var spellId:uint = 0;
        public static const protocolId:uint = 5699;

        public function GuildSpellUpgradeRequestMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5699;
        }// end function

        public function initGuildSpellUpgradeRequestMessage(param1:uint = 0) : GuildSpellUpgradeRequestMessage
        {
            this.spellId = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.spellId = 0;
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
            this.serializeAs_GuildSpellUpgradeRequestMessage(param1);
            return;
        }// end function

        public function serializeAs_GuildSpellUpgradeRequestMessage(param1:IDataOutput) : void
        {
            if (this.spellId < 0)
            {
                throw new Error("Forbidden value (" + this.spellId + ") on element spellId.");
            }
            param1.writeInt(this.spellId);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GuildSpellUpgradeRequestMessage(param1);
            return;
        }// end function

        public function deserializeAs_GuildSpellUpgradeRequestMessage(param1:IDataInput) : void
        {
            this.spellId = param1.readInt();
            if (this.spellId < 0)
            {
                throw new Error("Forbidden value (" + this.spellId + ") on element of GuildSpellUpgradeRequestMessage.spellId.");
            }
            return;
        }// end function

    }
}
