﻿package com.ankamagames.dofus.network.messages.game.shortcut
{
    import com.ankamagames.jerakine.network.*;
    import flash.utils.*;

    public class ShortcutBarAddErrorMessage extends NetworkMessage implements INetworkMessage
    {
        private var _isInitialized:Boolean = false;
        public var error:uint = 0;
        public static const protocolId:uint = 6227;

        public function ShortcutBarAddErrorMessage()
        {
            return;
        }// end function

        override public function get isInitialized() : Boolean
        {
            return this._isInitialized;
        }// end function

        override public function getMessageId() : uint
        {
            return 6227;
        }// end function

        public function initShortcutBarAddErrorMessage(param1:uint = 0) : ShortcutBarAddErrorMessage
        {
            this.error = param1;
            this._isInitialized = true;
            return this;
        }// end function

        override public function reset() : void
        {
            this.error = 0;
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
            this.serializeAs_ShortcutBarAddErrorMessage(param1);
            return;
        }// end function

        public function serializeAs_ShortcutBarAddErrorMessage(param1:IDataOutput) : void
        {
            param1.writeByte(this.error);
            return;
        }// end function

        public function deserialize(param1:IDataInput) : void
        {
            this.deserializeAs_ShortcutBarAddErrorMessage(param1);
            return;
        }// end function

        public function deserializeAs_ShortcutBarAddErrorMessage(param1:IDataInput) : void
        {
            this.error = param1.readByte();
            if (this.error < 0)
            {
                throw new Error("Forbidden value (" + this.error + ") on element of ShortcutBarAddErrorMessage.error.");
            }
            return;
        }// end function

    }
}
