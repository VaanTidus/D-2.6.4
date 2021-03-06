﻿package com.ankamagames.dofus.network.messages.game.pvp
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class SetEnablePVPRequestMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var enable:Boolean = false;
        public static const protocolId:uint = 1810;

        public function SetEnablePVPRequestMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 1810;
        }// end function

        public function initSetEnablePVPRequestMessage(param1:Boolean = false) : SetEnablePVPRequestMessage
        {
            this.enable = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.enable = false;
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
            this.serializeAs_SetEnablePVPRequestMessage(param1);
            return;
        }// end function

        public function serializeAs_SetEnablePVPRequestMessage(param1:IDataOutput) : void
        {
            param1.writeBoolean(this.enable);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_SetEnablePVPRequestMessage(param1);
            return;
        }// end function

        public function deserializeAs_SetEnablePVPRequestMessage(param1:IDataInput) : void
        {
            this.enable = param1.readBoolean();
            return;
        }// end function

    }
}
