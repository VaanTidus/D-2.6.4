﻿package com.ankamagames.dofus.network.messages.game.chat
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class ChatAbstractClientMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var content:String = "";
        public static const protocolId:uint = 850;

        public function ChatAbstractClientMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 850;
        }// end function

        public function initChatAbstractClientMessage(param1:String = "") : ChatAbstractClientMessage
        {
            this.content = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.content = "";
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
            this.serializeAs_ChatAbstractClientMessage(param1);
            return;
        }// end function

        public function serializeAs_ChatAbstractClientMessage(param1:IDataOutput) : void
        {
            param1.writeUTF(this.content);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_ChatAbstractClientMessage(param1);
            return;
        }// end function

        public function deserializeAs_ChatAbstractClientMessage(param1:IDataInput) : void
        {
            this.content = param1.readUTF();
            return;
        }// end function

    }
}
