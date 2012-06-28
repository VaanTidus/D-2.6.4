﻿package com.ankamagames.dofus.network.messages.game.friend
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class FriendSetWarnOnLevelGainMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var enable:Boolean = false;
        public static const protocolId:uint = 6077;

        public function FriendSetWarnOnLevelGainMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6077;
        }// end function

        public function initFriendSetWarnOnLevelGainMessage(param1:Boolean = false) : FriendSetWarnOnLevelGainMessage
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
            this.serializeAs_FriendSetWarnOnLevelGainMessage(param1);
            return;
        }// end function

        public function serializeAs_FriendSetWarnOnLevelGainMessage(param1:IDataOutput) : void
        {
            param1.writeBoolean(this.enable);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_FriendSetWarnOnLevelGainMessage(param1);
            return;
        }// end function

        public function deserializeAs_FriendSetWarnOnLevelGainMessage(param1:IDataInput) : void
        {
            this.enable = param1.readBoolean();
            return;
        }// end function

    }
}
