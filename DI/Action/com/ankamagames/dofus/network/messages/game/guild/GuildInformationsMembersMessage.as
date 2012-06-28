﻿package com.ankamagames.dofus.network.messages.game.guild
{
    import __AS3__.vec.*;
    import com.ankamagames.dofus.network.types.game.guild.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GuildInformationsMembersMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var members:Vector.<GuildMember>;
        public static const protocolId:uint = 5558;

        public function GuildInformationsMembersMessage()
        {
            this.members = new Vector.<GuildMember>;
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 5558;
        }// end function

        public function initGuildInformationsMembersMessage(param1:Vector.<GuildMember> = null) : GuildInformationsMembersMessage
        {
            this.members = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.members = new Vector.<GuildMember>;
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
            this.serializeAs_GuildInformationsMembersMessage(param1);
            return;
        }// end function

        public function serializeAs_GuildInformationsMembersMessage(param1:IDataOutput) : void
        {
            param1.writeShort(this.members.length);
            var _loc_2:uint = 0;
            while (_loc_2 < this.members.length)
            {
                
                (this.members[_loc_2] as GuildMember).serializeAs_GuildMember(param1);
                _loc_2 = _loc_2 + 1;
            }
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GuildInformationsMembersMessage(param1);
            return;
        }// end function

        public function deserializeAs_GuildInformationsMembersMessage(param1:IDataInput) : void
        {
            var _loc_4:GuildMember = null;
            var _loc_2:* = param1.readUnsignedShort();
            var _loc_3:uint = 0;
            while (_loc_3 < _loc_2)
            {
                
                _loc_4 = new GuildMember();
                _loc_4.deserialize(param1);
                this.members.push(_loc_4);
                _loc_3 = _loc_3 + 1;
            }
            return;
        }// end function

    }
}
