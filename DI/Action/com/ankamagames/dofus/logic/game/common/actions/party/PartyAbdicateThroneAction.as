﻿package com.ankamagames.dofus.logic.game.common.actions.party
{
    import com.ankamagames.jerakine.handlers.messages.*;

    public class PartyAbdicateThroneAction extends Object implements Action
    {
        public var playerId:uint;
        public var partyId:int;

        public function PartyAbdicateThroneAction()
        {
            return;
        }// end function

        public static function create(param1:int, param2:uint) : PartyAbdicateThroneAction
        {
            var _loc_3:* = new PartyAbdicateThroneAction;
            _loc_3.partyId = param1;
            _loc_3.playerId = param2;
            return _loc_3;
        }// end function

    }
}
