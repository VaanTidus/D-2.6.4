﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.emote
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class EmotePlayErrorMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var emoteId:int = 0;
        public static const protocolId:uint = 5688;

        public function EmotePlayErrorMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5688;
        }// end function

        public function initEmotePlayErrorMessage(param1:int = 0) : EmotePlayErrorMessage
        {
            this.emoteId = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.emoteId = 0;
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
            this.serializeAs_EmotePlayErrorMessage(param1);
            return;
        }// end function

        public function serializeAs_EmotePlayErrorMessage(param1:IDataOutput) : void
        {
            param1.writeByte(this.emoteId);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_EmotePlayErrorMessage(param1);
            return;
        }// end function

        public function deserializeAs_EmotePlayErrorMessage(param1:IDataInput) : void
        {
            this.emoteId = param1.readByte();
            return;
        }// end function

    }
}
