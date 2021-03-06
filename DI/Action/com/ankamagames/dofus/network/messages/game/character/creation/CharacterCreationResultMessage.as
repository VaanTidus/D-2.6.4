﻿package com.ankamagames.dofus.network.messages.game.character.creation
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class CharacterCreationResultMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var result:uint = 1;
        public static const protocolId:uint = 161;

        public function CharacterCreationResultMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 161;
        }// end function

        public function initCharacterCreationResultMessage(param1:uint = 1) : CharacterCreationResultMessage
        {
            this.result = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.result = 1;
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
            this.serializeAs_CharacterCreationResultMessage(param1);
            return;
        }// end function

        public function serializeAs_CharacterCreationResultMessage(param1:IDataOutput) : void
        {
            param1.writeByte(this.result);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_CharacterCreationResultMessage(param1);
            return;
        }// end function

        public function deserializeAs_CharacterCreationResultMessage(param1:IDataInput) : void
        {
            this.result = param1.readByte();
            if (this.result < 0)
            {
                throw new Error("Forbidden value (" + this.result + ") on element of CharacterCreationResultMessage.result.");
            }
            return;
        }// end function

    }
}
