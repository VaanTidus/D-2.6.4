﻿package com.ankamagames.dofus.network.messages.game.inventory.exchanges
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class ExchangeWaitingResultMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var bwait:Boolean = false;
        public static const protocolId:uint = 5786;

        public function ExchangeWaitingResultMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5786;
        }// end function

        public function initExchangeWaitingResultMessage(param1:Boolean = false) : ExchangeWaitingResultMessage
        {
            this.bwait = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.bwait = false;
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
            this.serializeAs_ExchangeWaitingResultMessage(param1);
            return;
        }// end function

        public function serializeAs_ExchangeWaitingResultMessage(param1:IDataOutput) : void
        {
            param1.writeBoolean(this.bwait);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_ExchangeWaitingResultMessage(param1);
            return;
        }// end function

        public function deserializeAs_ExchangeWaitingResultMessage(param1:IDataInput) : void
        {
            this.bwait = param1.readBoolean();
            return;
        }// end function

    }
}
