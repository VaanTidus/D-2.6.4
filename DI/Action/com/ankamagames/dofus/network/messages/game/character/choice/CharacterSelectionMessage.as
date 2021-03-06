﻿package com.ankamagames.dofus.network.messages.game.character.choice
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class CharacterSelectionMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var id:int = 0;
        public static const protocolId:uint = 152;

        public function CharacterSelectionMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 152;
        }// end function

        public function initCharacterSelectionMessage(param1:int = 0) : CharacterSelectionMessage
        {
            this.id = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.id = 0;
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
            this.serializeAs_CharacterSelectionMessage(param1);
            return;
        }// end function

        public function serializeAs_CharacterSelectionMessage(param1:IDataOutput) : void
        {
            if (this.id < 1 || this.id > 2147483647)
            {
                throw new Error("Forbidden value (" + this.id + ") on element id.");
            }
            param1.writeInt(this.id);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_CharacterSelectionMessage(param1);
            return;
        }// end function

        public function deserializeAs_CharacterSelectionMessage(param1:IDataInput) : void
        {
            this.id = param1.readInt();
            if (this.id < 1 || this.id > 2147483647)
            {
                throw new Error("Forbidden value (" + this.id + ") on element of CharacterSelectionMessage.id.");
            }
            return;
        }// end function

    }
}
