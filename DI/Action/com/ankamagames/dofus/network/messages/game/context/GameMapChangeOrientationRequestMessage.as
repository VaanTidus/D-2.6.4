﻿package com.ankamagames.dofus.network.messages.game.context
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GameMapChangeOrientationRequestMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var direction:uint = 1;
        public static const protocolId:uint = 945;

        public function GameMapChangeOrientationRequestMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 945;
        }// end function

        public function initGameMapChangeOrientationRequestMessage(param1:uint = 1) : GameMapChangeOrientationRequestMessage
        {
            this.direction = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.direction = 1;
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
            this.serializeAs_GameMapChangeOrientationRequestMessage(param1);
            return;
        }// end function

        public function serializeAs_GameMapChangeOrientationRequestMessage(param1:IDataOutput) : void
        {
            param1.writeByte(this.direction);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GameMapChangeOrientationRequestMessage(param1);
            return;
        }// end function

        public function deserializeAs_GameMapChangeOrientationRequestMessage(param1:IDataInput) : void
        {
            this.direction = param1.readByte();
            if (this.direction < 0)
            {
                throw new Error("Forbidden value (" + this.direction + ") on element of GameMapChangeOrientationRequestMessage.direction.");
            }
            return;
        }// end function

    }
}
