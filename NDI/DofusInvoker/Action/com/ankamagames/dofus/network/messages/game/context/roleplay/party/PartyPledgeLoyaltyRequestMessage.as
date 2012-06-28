﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.party
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class PartyPledgeLoyaltyRequestMessage extends AbstractPartyMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var loyal:Boolean = false;
        public static const protocolId:uint = 6269;

        public function PartyPledgeLoyaltyRequestMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return super.isInitialized && this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6269;
        }// end function

        public function initPartyPledgeLoyaltyRequestMessage(param1:uint = 0, param2:Boolean = false) : PartyPledgeLoyaltyRequestMessage
        {
            super.initAbstractPartyMessage(param1);
            this.loyal = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            super.reset();
            this.loyal = false;
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
            this.serializeAs_PartyPledgeLoyaltyRequestMessage(param1);
            return;
        }// end function

        public function serializeAs_PartyPledgeLoyaltyRequestMessage(param1:IDataOutput) : void
        {
            super.serializeAs_AbstractPartyMessage(param1);
            param1.writeBoolean(this.loyal);
            return;
        }// end function

        override public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_PartyPledgeLoyaltyRequestMessage(param1);
            return;
        }// end function

        public function deserializeAs_PartyPledgeLoyaltyRequestMessage(param1:IDataInput) : void
        {
            super.deserialize(param1);
            this.loyal = param1.readBoolean();
            return;
        }// end function

    }
}
