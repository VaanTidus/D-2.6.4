﻿package com.ankamagames.dofus.network.messages.game.context.fight.character
{
    import com.ankamagames.dofus.network.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class GameFightRefreshFighterMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var informations:GameContextActorInformations;
        public static const protocolId:uint = 6309;

        public function GameFightRefreshFighterMessage()
        {
            this.informations = new GameContextActorInformations();
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6309;
        }// end function

        public function initGameFightRefreshFighterMessage(param1:GameContextActorInformations = null) : GameFightRefreshFighterMessage
        {
            this.informations = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.informations = new GameContextActorInformations();
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
            this.serializeAs_GameFightRefreshFighterMessage(param1);
            return;
        }// end function

        public function serializeAs_GameFightRefreshFighterMessage(param1:IDataOutput) : void
        {
            param1.writeShort(this.informations.getTypeId());
            this.informations.serialize(param1);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_GameFightRefreshFighterMessage(param1);
            return;
        }// end function

        public function deserializeAs_GameFightRefreshFighterMessage(param1:IDataInput) : void
        {
            var _loc_2:* = param1.readUnsignedShort();
            this.informations = ProtocolTypeManager.getInstance(GameContextActorInformations, _loc_2);
            this.informations.deserialize(param1);
            return;
        }// end function

    }
}
