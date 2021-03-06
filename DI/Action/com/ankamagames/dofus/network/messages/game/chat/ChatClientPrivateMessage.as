﻿package com.ankamagames.dofus.network.messages.game.chat
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class ChatClientPrivateMessage extends ChatAbstractClientMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var receiver:String = "";
        public static const protocolId:uint = 851;

        public function ChatClientPrivateMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return super.isInitialized && this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 851;
        }// end function

        public function initChatClientPrivateMessage(param1:String = "", param2:String = "") : ChatClientPrivateMessage
        {
            super.initChatAbstractClientMessage(param1);
            this.receiver = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            super.reset();
            this.receiver = "";
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

        override public function serialize(param1:IDataOutput) : void
        {
            this.serializeAs_ChatClientPrivateMessage(param1);
            return;
        }// end function

        public function serializeAs_ChatClientPrivateMessage(param1:IDataOutput) : void
        {
            super.serializeAs_ChatAbstractClientMessage(param1);
            param1.writeUTF(this.receiver);
            return;
        }// end function

        override public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_ChatClientPrivateMessage(param1);
            return;
        }// end function

        public function deserializeAs_ChatClientPrivateMessage(param1:IDataInput) : void
        {
            super.deserialize(param1);
            this.receiver = param1.readUTF();
            return;
        }// end function

    }
}
