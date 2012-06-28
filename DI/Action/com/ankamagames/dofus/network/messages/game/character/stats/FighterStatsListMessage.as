﻿package com.ankamagames.dofus.network.messages.game.character.stats
{
    import com.ankamagames.dofus.network.types.game.character.characteristic.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class FighterStatsListMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var stats:CharacterCharacteristicsInformations;
        public static const protocolId:uint = 6322;

        public function FighterStatsListMessage()
        {
            this.stats = new CharacterCharacteristicsInformations();
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6322;
        }// end function

        public function initFighterStatsListMessage(param1:CharacterCharacteristicsInformations = null) : FighterStatsListMessage
        {
            this.stats = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.stats = new CharacterCharacteristicsInformations();
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
            this.serializeAs_FighterStatsListMessage(param1);
            return;
        }// end function

        public function serializeAs_FighterStatsListMessage(param1:IDataOutput) : void
        {
            this.stats.serializeAs_CharacterCharacteristicsInformations(param1);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_FighterStatsListMessage(param1);
            return;
        }// end function

        public function deserializeAs_FighterStatsListMessage(param1:IDataInput) : void
        {
            this.stats = new CharacterCharacteristicsInformations();
            this.stats.deserialize(param1);
            return;
        }// end function

    }
}
