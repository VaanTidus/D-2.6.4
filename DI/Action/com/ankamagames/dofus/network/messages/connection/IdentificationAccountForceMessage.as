﻿package com.ankamagames.dofus.network.messages.connection
{
    import __AS3__.vec.*;
    import com.ankamagames.dofus.network.types.version.*;
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class IdentificationAccountForceMessage extends IdentificationMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var forcedAccountLogin:String = "";
        public static const protocolId:uint = 6119;

        public function IdentificationAccountForceMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return super.isInitialized && this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6119;
        }// end function

        public function initIdentificationAccountForceMessage(param1:Version = null, param2:String = "", param3:String = "", param4:Vector.<int> = null, param5:int = 0, param6:Boolean = false, param7:Boolean = false, param8:Boolean = false, param9:String = "") : IdentificationAccountForceMessage
        {
            super.initIdentificationMessage(param1, param2, param3, param4, param5, param6, param7, param8);
            this.forcedAccountLogin = param9;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            super.reset();
            this.forcedAccountLogin = "";
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
            this.serializeAs_IdentificationAccountForceMessage(param1);
            return;
        }// end function

        public function serializeAs_IdentificationAccountForceMessage(param1:IDataOutput) : void
        {
            super.serializeAs_IdentificationMessage(param1);
            param1.writeUTF(this.forcedAccountLogin);
            return;
        }// end function

        override public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_IdentificationAccountForceMessage(param1);
            return;
        }// end function

        public function deserializeAs_IdentificationAccountForceMessage(param1:IDataInput) : void
        {
            super.deserialize(param1);
            this.forcedAccountLogin = param1.readUTF();
            return;
        }// end function

    }
}
