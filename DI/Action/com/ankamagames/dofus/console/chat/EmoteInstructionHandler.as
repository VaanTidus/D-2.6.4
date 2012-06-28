﻿package com.ankamagames.dofus.console.chat
{
    import com.ankamagames.dofus.datacenter.communication.*;
    import com.ankamagames.dofus.kernel.net.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.emote.*;
    import com.ankamagames.jerakine.console.*;
    import com.ankamagames.jerakine.data.*;

    public class EmoteInstructionHandler extends Object implements ConsoleInstructionHandler
    {

        public function EmoteInstructionHandler()
        {
            return;
        }// end function

        public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
        {
            var _loc_5:EmotePlayRequestMessage = null;
            var _loc_4:* = PlayedCharacterManager.getInstance();
            if (PlayedCharacterManager.getInstance().state == PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING && _loc_4.isRidding || _loc_4.isPetsMounting || _loc_4.infos.entityLook.bonesId == 1)
            {
                _loc_5 = new EmotePlayRequestMessage();
                _loc_5.initEmotePlayRequestMessage(this.getEmoteId(param2));
                ConnectionsHandler.getConnection().send(_loc_5);
            }
            return;
        }// end function

        public function getHelp(param1:String) : String
        {
            return I18n.getUiText("ui.chat.console.help.emote", [Emoticon.getEmoticonById(this.getEmoteId(param1)).name]);
        }// end function

        private function getEmoteId(param1:String) : uint
        {
            var _loc_3:* = undefined;
            var _loc_2:uint = 0;
            for each (_loc_3 in Emoticon.getEmoticons())
            {
                
                if (_loc_3.shortcut == param1)
                {
                    _loc_2 = _loc_3.id;
                }
            }
            return _loc_2;
        }// end function

        public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
        {
            return [];
        }// end function

    }
}
