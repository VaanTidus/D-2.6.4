﻿package com.ankamagames.dofus.network.messages.game.context.roleplay.quest
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class QuestObjectiveValidatedMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var questId:uint = 0;
        public var objectiveId:uint = 0;
        public static const protocolId:uint = 6098;

        public function QuestObjectiveValidatedMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6098;
        }// end function

        public function initQuestObjectiveValidatedMessage(param1:uint = 0, param2:uint = 0) : QuestObjectiveValidatedMessage
        {
            this.questId = param1;
            this.objectiveId = param2;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.questId = 0;
            this.objectiveId = 0;
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
            this.serializeAs_QuestObjectiveValidatedMessage(param1);
            return;
        }// end function

        public function serializeAs_QuestObjectiveValidatedMessage(param1:IDataOutput) : void
        {
            if (this.questId < 0 || this.questId > 65535)
            {
                throw new Error("Forbidden value (" + this.questId + ") on element questId.");
            }
            param1.writeShort(this.questId);
            if (this.objectiveId < 0 || this.objectiveId > 65535)
            {
                throw new Error("Forbidden value (" + this.objectiveId + ") on element objectiveId.");
            }
            param1.writeShort(this.objectiveId);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_QuestObjectiveValidatedMessage(param1);
            return;
        }// end function

        public function deserializeAs_QuestObjectiveValidatedMessage(param1:IDataInput) : void
        {
            this.questId = param1.readUnsignedShort();
            if (this.questId < 0 || this.questId > 65535)
            {
                throw new Error("Forbidden value (" + this.questId + ") on element of QuestObjectiveValidatedMessage.questId.");
            }
            this.objectiveId = param1.readUnsignedShort();
            if (this.objectiveId < 0 || this.objectiveId > 65535)
            {
                throw new Error("Forbidden value (" + this.objectiveId + ") on element of QuestObjectiveValidatedMessage.objectiveId.");
            }
            return;
        }// end function

    }
}
