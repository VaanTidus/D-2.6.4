﻿package com.ankamagames.dofus.network.messages.game.guild
{
    import com.ankamagames.dofus.network.types.game.guild.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GuildInformationsMemberUpdateMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var member:GuildMember;
        public static const protocolId:uint = 5597;

        public function GuildInformationsMemberUpdateMessage()
        {
            this.member = new GuildMember();
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5597;
        }// end function

        public function initGuildInformationsMemberUpdateMessage(param1:GuildMember = null) : GuildInformationsMemberUpdateMessage
        {
            this.member = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.member = new GuildMember();
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
            this.serializeAs_GuildInformationsMemberUpdateMessage(param1);
            return;
        }// end function

        public function serializeAs_GuildInformationsMemberUpdateMessage(param1:IDataOutput) : void
        {
            this.member.serializeAs_GuildMember(param1);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GuildInformationsMemberUpdateMessage(param1);
            return;
        }// end function

        public function deserializeAs_GuildInformationsMemberUpdateMessage(param1:IDataInput) : void
        {
            this.member = new GuildMember();
            this.member.deserialize(param1);
            return;
        }// end function

    }
}
