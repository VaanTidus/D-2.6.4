﻿package com.ankamagames.dofus.network.messages.game.pvp
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class AlignmentSubAreaUpdateMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var subAreaId:uint = 0;
        public var side:int = 0;
        public var quiet:Boolean = false;
        public static const protocolId:uint = 6057;

        public function AlignmentSubAreaUpdateMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6057;
        }// end function

        public function initAlignmentSubAreaUpdateMessage(param1:uint = 0, param2:int = 0, param3:Boolean = false) : AlignmentSubAreaUpdateMessage
        {
            this.subAreaId = param1;
            this.side = param2;
            this.quiet = param3;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.subAreaId = 0;
            this.side = 0;
            this.quiet = false;
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
            this.serializeAs_AlignmentSubAreaUpdateMessage(param1);
            return;
        }// end function

        public function serializeAs_AlignmentSubAreaUpdateMessage(param1:IDataOutput) : void
        {
            if (this.subAreaId < 0)
            {
                throw new Error("Forbidden value (" + this.subAreaId + ") on element subAreaId.");
            }
            param1.writeShort(this.subAreaId);
            param1.writeByte(this.side);
            param1.writeBoolean(this.quiet);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_AlignmentSubAreaUpdateMessage(param1);
            return;
        }// end function

        public function deserializeAs_AlignmentSubAreaUpdateMessage(param1:IDataInput) : void
        {
            this.subAreaId = param1.readShort();
            if (this.subAreaId < 0)
            {
                throw new Error("Forbidden value (" + this.subAreaId + ") on element of AlignmentSubAreaUpdateMessage.subAreaId.");
            }
            this.side = param1.readByte();
            this.quiet = param1.readBoolean();
            return;
        }// end function

    }
}
