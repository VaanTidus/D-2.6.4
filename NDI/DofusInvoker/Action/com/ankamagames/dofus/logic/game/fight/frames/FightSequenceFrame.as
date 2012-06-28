package com.ankamagames.dofus.logic.game.fight.frames
{
    import __AS3__.vec.*;
    import com.ankamagames.atouin.managers.*;
    import com.ankamagames.atouin.types.sequences.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.dofus.datacenter.monsters.*;
    import com.ankamagames.dofus.datacenter.spells.*;
    import com.ankamagames.dofus.internalDatacenter.spells.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.common.misc.*;
    import com.ankamagames.dofus.logic.game.fight.managers.*;
    import com.ankamagames.dofus.logic.game.fight.messages.*;
    import com.ankamagames.dofus.logic.game.fight.miscs.*;
    import com.ankamagames.dofus.logic.game.fight.steps.*;
    import com.ankamagames.dofus.logic.game.fight.types.*;
    import com.ankamagames.dofus.misc.*;
    import com.ankamagames.dofus.misc.lists.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.messages.game.actions.*;
    import com.ankamagames.dofus.network.messages.game.actions.fight.*;
    import com.ankamagames.dofus.network.messages.game.context.*;
    import com.ankamagames.dofus.network.messages.game.context.fight.character.*;
    import com.ankamagames.dofus.network.types.game.actions.fight.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.dofus.network.types.game.context.fight.*;
    import com.ankamagames.dofus.network.types.game.look.*;
    import com.ankamagames.dofus.scripts.*;
    import com.ankamagames.dofus.types.entities.*;
    import com.ankamagames.dofus.types.enums.*;
    import com.ankamagames.dofus.types.sequences.*;
    import com.ankamagames.jerakine.entities.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.managers.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.script.*;
    import com.ankamagames.jerakine.sequencer.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.enums.*;
    import com.ankamagames.jerakine.types.events.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.tiphon.display.*;
    import com.ankamagames.tiphon.sequence.*;
    import flash.display.*;
    import flash.utils.*;

    public class FightSequenceFrame extends Object implements Frame, ISpellCastProvider
    {
        private var _fxScriptId:uint;
        private var _scriptStarted:uint;
        private var _castingSpell:CastingSpell;
        private var _stepsBuffer:Vector.<ISequencable>;
        public var mustAck:Boolean;
        public var ackIdent:int;
        private var _sequenceEndCallback:Function;
        private var _subSequenceWaitingCount:uint = 0;
        private var _scriptInit:Boolean;
        private var _sequencer:SerialSequencer;
        private var _parent:FightSequenceFrame;
        private var _fightBattleFrame:FightBattleFrame;
        private var _fightEntitiesFrame:FightEntitiesFrame;
        private var _instanceId:uint;
        static const _log:Logger = Log.getLogger(getQualifiedClassName(FightSequenceFrame));
        private static var _lastCastingSpell:CastingSpell;
        private static var _currentInstanceId:uint;
        public static const FIGHT_SEQUENCERS_CATEGORY:String = "FightSequencer";

        public function FightSequenceFrame(param1:FightBattleFrame, param2:FightSequenceFrame = null)
        {
            this._instanceId = _currentInstanceId + 1;
            this._fightBattleFrame = param1;
            this._parent = param2;
            this.clearBuffer();
            return;
        }// end function

        public function get priority() : int
        {
            return Priority.HIGHEST;
        }// end function

        public function get castingSpell() : CastingSpell
        {
            return this._castingSpell;
        }// end function

        public function get stepsBuffer() : Vector.<ISequencable>
        {
            return this._stepsBuffer;
        }// end function

        public function get parent() : FightSequenceFrame
        {
            return this._parent;
        }// end function

        public function get isWaiting() : Boolean
        {
            return this._subSequenceWaitingCount != 0 || !this._scriptInit;
        }// end function

        public function get instanceId() : uint
        {
            return this._instanceId;
        }// end function

        public function pushed() : Boolean
        {
            this._scriptInit = false;
            return true;
        }// end function

        public function pulled() : Boolean
        {
            this._stepsBuffer = null;
            this._castingSpell = null;
            _lastCastingSpell = null;
            this._sequenceEndCallback = null;
            this._parent = null;
            this._fightBattleFrame = null;
            this._fightEntitiesFrame = null;
            this._sequencer.clear();
            return true;
        }// end function

        public function get fightEntitiesFrame() : FightEntitiesFrame
        {
            if (!this._fightEntitiesFrame)
            {
                this._fightEntitiesFrame = Kernel.getWorker().getFrame(FightEntitiesFrame) as FightEntitiesFrame;
            }
            return this._fightEntitiesFrame;
        }// end function

        public function addSubSequence(param1:ISequencer) : void
        {
            var _loc_2:String = this;
            var _loc_3:* = this._subSequenceWaitingCount + 1;
            _loc_2._subSequenceWaitingCount = _loc_3;
            this._stepsBuffer.push(new ParallelStartSequenceStep([param1], false));
            return;
        }// end function

        public function process(param1:Message) : Boolean
        {
            var _loc_2:GameActionFightSpellCastMessage = null;
            var _loc_3:Boolean = false;
            var _loc_4:uint = 0;
            var _loc_5:int = 0;
            var _loc_6:Boolean = false;
            var _loc_7:Dictionary = null;
            var _loc_8:GameFightFighterInformations = null;
            var _loc_9:PlayedCharacterManager = null;
            var _loc_10:Boolean = false;
            var _loc_11:GameMapMovementMessage = null;
            var _loc_12:GameActionFightPointsVariationMessage = null;
            var _loc_13:GameActionFightLifeAndShieldPointsLostMessage = null;
            var _loc_14:GameActionFightLifePointsGainMessage = null;
            var _loc_15:GameActionFightLifePointsLostMessage = null;
            var _loc_16:GameActionFightTeleportOnSameMapMessage = null;
            var _loc_17:GameActionFightExchangePositionsMessage = null;
            var _loc_18:GameActionFightSlideMessage = null;
            var _loc_19:GameActionFightSummonMessage = null;
            var _loc_20:GameActionFightMarkCellsMessage = null;
            var _loc_21:GameActionFightUnmarkCellsMessage = null;
            var _loc_22:GameActionFightChangeLookMessage = null;
            var _loc_23:GameActionFightInvisibilityMessage = null;
            var _loc_24:GameContextActorInformations = null;
            var _loc_25:GameActionFightLeaveMessage = null;
            var _loc_26:Dictionary = null;
            var _loc_27:GameContextActorInformations = null;
            var _loc_28:GameActionFightDeathMessage = null;
            var _loc_29:Dictionary = null;
            var _loc_30:int = 0;
            var _loc_31:GameFightFighterInformations = null;
            var _loc_32:GameFightFighterInformations = null;
            var _loc_33:GameFightFighterInformations = null;
            var _loc_34:GameContextActorInformations = null;
            var _loc_35:FightContextFrame = null;
            var _loc_36:GameActionFightVanishMessage = null;
            var _loc_37:GameContextActorInformations = null;
            var _loc_38:FightContextFrame = null;
            var _loc_39:GameActionFightDispellEffectMessage = null;
            var _loc_40:GameActionFightDispellSpellMessage = null;
            var _loc_41:GameActionFightDispellMessage = null;
            var _loc_42:GameActionFightDodgePointLossMessage = null;
            var _loc_43:GameActionFightSpellCooldownVariationMessage = null;
            var _loc_44:GameActionFightSpellImmunityMessage = null;
            var _loc_45:GameActionFightInvisibleObstacleMessage = null;
            var _loc_46:GameActionFightKillMessage = null;
            var _loc_47:GameActionFightReduceDamagesMessage = null;
            var _loc_48:GameActionFightReflectDamagesMessage = null;
            var _loc_49:GameActionFightReflectSpellMessage = null;
            var _loc_50:GameActionFightStealKamaMessage = null;
            var _loc_51:GameActionFightTackledMessage = null;
            var _loc_52:GameActionFightTriggerGlyphTrapMessage = null;
            var _loc_53:int = 0;
            var _loc_54:GameActionFightDispellableEffectMessage = null;
            var _loc_55:CastingSpell = null;
            var _loc_56:AbstractFightDispellableEffect = null;
            var _loc_57:BasicBuff = null;
            var _loc_58:GameActionFightModifyEffectsDurationMessage = null;
            var _loc_59:GameActionFightCarryCharacterMessage = null;
            var _loc_60:GameActionFightThrowCharacterMessage = null;
            var _loc_61:GameActionFightDropCharacterMessage = null;
            var _loc_62:GameActionFightInvisibleDetectedMessage = null;
            var _loc_63:GameActionFightCloseCombatMessage = null;
            var _loc_64:Array = null;
            var _loc_65:Boolean = false;
            var _loc_66:SpellWrapper = null;
            var _loc_67:Spell = null;
            var _loc_68:SpellLevel = null;
            var _loc_69:int = 0;
            var _loc_70:GameFightShowFighterRandomStaticPoseMessage = null;
            var _loc_71:Sprite = null;
            var _loc_72:GameFightShowFighterMessage = null;
            var _loc_73:Sprite = null;
            var _loc_74:Boolean = false;
            var _loc_75:Boolean = false;
            var _loc_76:GameContextActorInformations = null;
            var _loc_77:GameFightMonsterInformations = null;
            var _loc_78:Monster = null;
            var _loc_79:GameContextActorInformations = null;
            var _loc_80:int = 0;
            var _loc_81:GameFightMonsterInformations = null;
            var _loc_82:Monster = null;
            var _loc_83:GameContextActorInformations = null;
            var _loc_84:int = 0;
            var _loc_85:GameFightMonsterInformations = null;
            var _loc_86:GameFightFighterInformations = null;
            var _loc_87:int = 0;
            switch(true)
            {
                case param1 is GameActionFightCloseCombatMessage:
                case param1 is GameActionFightSpellCastMessage:
                {
                    if (param1 is GameActionFightSpellCastMessage)
                    {
                        _loc_2 = param1 as GameActionFightSpellCastMessage;
                    }
                    else
                    {
                        _loc_63 = param1 as GameActionFightCloseCombatMessage;
                        _loc_3 = true;
                        _loc_4 = _loc_63.weaponGenericId;
                        _loc_2 = new GameActionFightSpellCastMessage();
                        _loc_2.initGameActionFightSpellCastMessage(_loc_63.actionId, _loc_63.sourceId, _loc_63.targetId, _loc_63.destinationCellId, _loc_63.critical, _loc_63.silentCast, 0, 1);
                    }
                    _loc_5 = this.fightEntitiesFrame.getEntityInfos(_loc_2.sourceId).disposition.cellId;
                    if (this._castingSpell)
                    {
                        if (_loc_3 && _loc_4 != 0)
                        {
                            this.pushCloseCombatStep(_loc_2.sourceId, _loc_4, _loc_2.critical);
                        }
                        else
                        {
                            this.pushSpellCastStep(_loc_2.sourceId, _loc_2.destinationCellId, _loc_5, _loc_2.spellId, _loc_2.spellLevel, _loc_2.critical);
                        }
                        _log.error("Il ne peut y avoir qu\'un seul cast de sort par séquence (" + param1 + ")");
                        break;
                    }
                    this._castingSpell = new CastingSpell();
                    this._castingSpell.casterId = _loc_2.sourceId;
                    this._castingSpell.spell = Spell.getSpellById(_loc_2.spellId);
                    this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(_loc_2.spellLevel);
                    this._castingSpell.isCriticalFail = _loc_2.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL;
                    this._castingSpell.isCriticalHit = _loc_2.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
                    this._castingSpell.silentCast = _loc_2.silentCast;
                    if (_loc_2.destinationCellId != -1)
                    {
                        this._castingSpell.targetedCell = MapPoint.fromCellId(_loc_2.destinationCellId);
                    }
                    if (this._castingSpell.isCriticalFail)
                    {
                        this._fxScriptId = 0;
                    }
                    else
                    {
                        this._fxScriptId = this._castingSpell.spell.getScriptId(this._castingSpell.isCriticalHit);
                    }
                    if (param1 is GameActionFightCloseCombatMessage)
                    {
                        this._fxScriptId = 7;
                        this._castingSpell.weaponId = GameActionFightCloseCombatMessage(param1).weaponGenericId;
                    }
                    if (_loc_2.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId && _loc_2.critical != FightSpellCastCriticalEnum.CRITICAL_FAIL)
                    {
                        _loc_64 = new Array();
                        _loc_64.push(_loc_2.targetId);
                        CurrentPlayedFighterManager.getInstance().getSpellCastManager().castSpell(_loc_2.spellId, _loc_2.spellLevel, _loc_64);
                    }
                    _loc_6 = _loc_2.critical == FightSpellCastCriticalEnum.CRITICAL_HIT;
                    _loc_7 = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
                    _loc_8 = _loc_7[_loc_2.sourceId];
                    if (_loc_3 && _loc_4 != 0)
                    {
                        this.pushCloseCombatStep(_loc_2.sourceId, _loc_4, _loc_2.critical);
                    }
                    else
                    {
                        this.pushSpellCastStep(_loc_2.sourceId, _loc_2.destinationCellId, _loc_5, _loc_2.spellId, _loc_2.spellLevel, _loc_2.critical);
                    }
                    if (_loc_2.sourceId == CurrentPlayedFighterManager.getInstance().currentFighterId)
                    {
                        KernelEventsManager.getInstance().processCallback(TriggerHookList.FightSpellCast);
                    }
                    _loc_9 = PlayedCharacterManager.getInstance();
                    _loc_10 = false;
                    if (_loc_7[_loc_9.id] && _loc_8 && (_loc_7[_loc_9.id] as GameFightFighterInformations).teamId == _loc_8.teamId)
                    {
                        _loc_10 = true;
                    }
                    if (_loc_2.sourceId != _loc_9.id && _loc_10 && !this._castingSpell.isCriticalFail)
                    {
                        _loc_65 = false;
                        for each (_loc_66 in _loc_9.spellsInventory)
                        {
                            
                            if (_loc_66.id == _loc_2.spellId)
                            {
                                _loc_65 = true;
                                break;
                            }
                        }
                        if (_loc_65)
                        {
                            _loc_67 = Spell.getSpellById(_loc_2.spellId);
                            _loc_68 = SpellLevel.getLevelById(_loc_67.spellLevels[(_loc_66.spellLevel - 1)]);
                            if (_loc_68.globalCooldown)
                            {
                                if (_loc_68.globalCooldown == -1)
                                {
                                    _loc_69 = _loc_68.minCastInterval;
                                }
                                else
                                {
                                    _loc_69 = _loc_68.globalCooldown;
                                }
                                this.pushSpellCooldownVariationStep(_loc_9.id, 0, _loc_2.spellId, _loc_69);
                            }
                        }
                    }
                    _loc_30 = PlayedCharacterManager.getInstance().infos.id;
                    _loc_31 = this.fightEntitiesFrame.getEntityInfos(_loc_2.sourceId) as GameFightFighterInformations;
                    _loc_33 = this.fightEntitiesFrame.getEntityInfos(_loc_30) as GameFightFighterInformations;
                    if (_loc_6)
                    {
                        if (_loc_2.sourceId == _loc_30)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_OWNER);
                        }
                        else if (_loc_33 && _loc_31.teamId == _loc_33.teamId)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ALLIED);
                        }
                        else
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_CC_ENEMY);
                        }
                    }
                    else if (_loc_2.critical == FightSpellCastCriticalEnum.CRITICAL_FAIL)
                    {
                        if (_loc_2.sourceId == _loc_30)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_OWNER);
                        }
                        else if (_loc_33 && _loc_31.teamId == _loc_33.teamId)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ALLIED);
                        }
                        else
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_EC_ENEMY);
                        }
                    }
                    return true;
                }
                case param1 is GameMapMovementMessage:
                {
                    _loc_11 = param1 as GameMapMovementMessage;
                    if (_loc_11.actorId == CurrentPlayedFighterManager.getInstance().currentFighterId)
                    {
                        KernelEventsManager.getInstance().processCallback(TriggerHookList.PlayerFightMove);
                    }
                    this.pushMovementStep(_loc_11.actorId, MapMovementAdapter.getClientMovement(_loc_11.keyMovements));
                    return true;
                }
                case param1 is GameActionFightPointsVariationMessage:
                {
                    _loc_12 = param1 as GameActionFightPointsVariationMessage;
                    this.pushPointsVariationStep(_loc_12.targetId, _loc_12.actionId, _loc_12.delta);
                    return false;
                }
                case param1 is GameActionFightLifeAndShieldPointsLostMessage:
                {
                    _loc_13 = param1 as GameActionFightLifeAndShieldPointsLostMessage;
                    this.pushShieldPointsVariationStep(_loc_13.targetId, -_loc_13.shieldLoss, _loc_13.actionId);
                    this.pushLifePointsVariationStep(_loc_13.targetId, -_loc_13.loss, -_loc_13.permanentDamages, _loc_13.actionId);
                    return true;
                }
                case param1 is GameActionFightLifePointsGainMessage:
                {
                    _loc_14 = param1 as GameActionFightLifePointsGainMessage;
                    this.pushLifePointsVariationStep(_loc_14.targetId, _loc_14.delta, 0, _loc_14.actionId);
                    return true;
                }
                case param1 is GameActionFightLifePointsLostMessage:
                {
                    _loc_15 = param1 as GameActionFightLifePointsLostMessage;
                    this.pushLifePointsVariationStep(_loc_15.targetId, -_loc_15.loss, -_loc_15.permanentDamages, _loc_15.actionId);
                    return true;
                }
                case param1 is GameActionFightTeleportOnSameMapMessage:
                {
                    _loc_16 = param1 as GameActionFightTeleportOnSameMapMessage;
                    this.pushTeleportStep(_loc_16.targetId, _loc_16.cellId);
                    return true;
                }
                case param1 is GameActionFightExchangePositionsMessage:
                {
                    _loc_17 = param1 as GameActionFightExchangePositionsMessage;
                    this.pushExchangePositionsStep(_loc_17.sourceId, _loc_17.casterCellId, _loc_17.targetId, _loc_17.targetCellId);
                    return true;
                }
                case param1 is GameActionFightSlideMessage:
                {
                    _loc_18 = param1 as GameActionFightSlideMessage;
                    this.pushSlideStep(_loc_18.targetId, _loc_18.startCellId, _loc_18.endCellId);
                    return true;
                }
                case param1 is GameActionFightSummonMessage:
                {
                    _loc_19 = param1 as GameActionFightSummonMessage;
                    if (_loc_19.actionId == 1024 || _loc_19.actionId == 1097)
                    {
                        _loc_70 = new GameFightShowFighterRandomStaticPoseMessage();
                        _loc_70.initGameFightShowFighterRandomStaticPoseMessage(_loc_19.summon);
                        Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc_70);
                        _loc_71 = DofusEntities.getEntity(_loc_19.summon.contextualId) as Sprite;
                        _loc_71.visible = false;
                        this.pushVisibilityStep(_loc_19.summon.contextualId, true);
                    }
                    else
                    {
                        _loc_72 = new GameFightShowFighterMessage();
                        _loc_72.initGameFightShowFighterMessage(_loc_19.summon);
                        Kernel.getWorker().getFrame(FightEntitiesFrame).process(_loc_72);
                        _loc_73 = DofusEntities.getEntity(_loc_19.summon.contextualId) as Sprite;
                        _loc_73.visible = false;
                        this.pushSummonStep(_loc_19.sourceId, _loc_19.summon);
                        if (_loc_19.sourceId == PlayedCharacterManager.getInstance().id && _loc_19.actionId != 185)
                        {
                            _loc_74 = false;
                            _loc_75 = false;
                            if (_loc_19.actionId == 1008)
                            {
                                _loc_74 = true;
                            }
                            else
                            {
                                _loc_76 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc_19.summon.contextualId);
                                _loc_74 = false;
                                _loc_77 = _loc_76 as GameFightMonsterInformations;
                                if (_loc_77)
                                {
                                    _loc_78 = Monster.getMonsterById(_loc_77.creatureGenericId);
                                    if (_loc_78 && _loc_78.useBombSlot)
                                    {
                                        _loc_74 = true;
                                    }
                                    if (_loc_78 && _loc_78.useSummonSlot)
                                    {
                                        _loc_75 = true;
                                    }
                                }
                            }
                            if (_loc_75)
                            {
                                PlayedCharacterManager.getInstance().addSummonedCreature();
                            }
                            else if (_loc_74)
                            {
                                PlayedCharacterManager.getInstance().addSummonedBomb();
                            }
                        }
                    }
                    return true;
                }
                case param1 is GameActionFightMarkCellsMessage:
                {
                    _loc_20 = param1 as GameActionFightMarkCellsMessage;
                    if (this._castingSpell)
                    {
                        this._castingSpell.markId = _loc_20.mark.markId;
                        this._castingSpell.markType = _loc_20.mark.markType;
                        this.pushMarkCellsStep(_loc_20.mark.markId, _loc_20.mark.markType, _loc_20.mark.cells, _loc_20.mark.markSpellId);
                    }
                    return true;
                }
                case param1 is GameActionFightUnmarkCellsMessage:
                {
                    _loc_21 = param1 as GameActionFightUnmarkCellsMessage;
                    this.pushUnmarkCellsStep(_loc_21.markId);
                    return true;
                }
                case param1 is GameActionFightChangeLookMessage:
                {
                    _loc_22 = param1 as GameActionFightChangeLookMessage;
                    this.pushChangeLookStep(_loc_22.targetId, _loc_22.entityLook);
                    return true;
                }
                case param1 is GameActionFightInvisibilityMessage:
                {
                    _loc_23 = param1 as GameActionFightInvisibilityMessage;
                    _loc_24 = this.fightEntitiesFrame.getEntityInfos(_loc_23.targetId);
                    FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc_23.targetId, _loc_24.disposition.cellId);
                    FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc_23.targetId, 0, true);
                    this.pushChangeVisibilityStep(_loc_23.targetId, _loc_23.state);
                    return true;
                }
                case param1 is GameActionFightLeaveMessage:
                {
                    _loc_25 = param1 as GameActionFightLeaveMessage;
                    _loc_26 = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
                    for each (_loc_79 in _loc_26)
                    {
                        
                        if (_loc_79 is GameFightFighterInformations)
                        {
                            _loc_80 = (_loc_79 as GameFightFighterInformations).stats.summoner;
                            if (_loc_80 == _loc_25.targetId)
                            {
                                this.pushDeathStep(_loc_79.contextualId);
                            }
                        }
                    }
                    this.pushDeathStep(_loc_25.targetId, false);
                    _loc_27 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc_25.targetId);
                    if (_loc_27 is GameFightMonsterInformations)
                    {
                        _loc_81 = _loc_27 as GameFightMonsterInformations;
                        if (_loc_81.stats.summoner == PlayedCharacterManager.getInstance().id)
                        {
                            _loc_82 = Monster.getMonsterById(_loc_81.creatureGenericId);
                            if (_loc_82.useSummonSlot)
                            {
                                PlayedCharacterManager.getInstance().removeSummonedCreature();
                            }
                            if (_loc_82.useBombSlot)
                            {
                                PlayedCharacterManager.getInstance().removeSummonedBomb();
                            }
                        }
                    }
                    return true;
                }
                case param1 is GameActionFightDeathMessage:
                {
                    _loc_28 = param1 as GameActionFightDeathMessage;
                    _log.fatal("GameActionFightDeathMessage");
                    _loc_29 = FightEntitiesFrame.getCurrentInstance().getEntitiesDictionnary();
                    for each (_loc_83 in _loc_29)
                    {
                        
                        if (_loc_83 is GameFightFighterInformations)
                        {
                            _loc_84 = (_loc_83 as GameFightFighterInformations).stats.summoner;
                            if (_loc_84 == _loc_28.targetId)
                            {
                                this.pushDeathStep(_loc_83.contextualId);
                            }
                        }
                    }
                    _loc_30 = PlayedCharacterManager.getInstance().infos.id;
                    _loc_31 = this.fightEntitiesFrame.getEntityInfos(_loc_28.sourceId) as GameFightFighterInformations;
                    _loc_32 = this.fightEntitiesFrame.getEntityInfos(_loc_28.targetId) as GameFightFighterInformations;
                    _loc_33 = this.fightEntitiesFrame.getEntityInfos(_loc_30) as GameFightFighterInformations;
                    if (_loc_28.targetId == _loc_30)
                    {
                        if (_loc_28.sourceId == _loc_28.targetId)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_HIMSELF);
                        }
                        else if (_loc_31.teamId != _loc_33.teamId)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                        }
                        else
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILLED_BY_ENEMY);
                        }
                    }
                    else if (_loc_28.sourceId == _loc_30)
                    {
                        if (_loc_32.teamId != _loc_33.teamId)
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ENEMY);
                        }
                        else
                        {
                            SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_KILL_ALLY);
                        }
                    }
                    this.pushDeathStep(_loc_28.targetId);
                    _loc_34 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc_28.targetId);
                    if (_loc_34 is GameFightMonsterInformations)
                    {
                        _loc_85 = _loc_34 as GameFightMonsterInformations;
                        _loc_85.alive = false;
                        if (_loc_85.stats.summoner == PlayedCharacterManager.getInstance().id)
                        {
                            _loc_82 = Monster.getMonsterById(_loc_85.creatureGenericId);
                            if (_loc_82.useSummonSlot)
                            {
                                PlayedCharacterManager.getInstance().removeSummonedCreature();
                            }
                            if (_loc_82.useBombSlot)
                            {
                                PlayedCharacterManager.getInstance().removeSummonedBomb();
                            }
                            SpellWrapper.refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
                        }
                    }
                    else if (_loc_34 is GameFightFighterInformations)
                    {
                        (_loc_34 as GameFightFighterInformations).alive = false;
                        if ((_loc_34 as GameFightFighterInformations).stats.summoner != 0)
                        {
                            _loc_86 = _loc_34 as GameFightFighterInformations;
                            if (_loc_86.stats.summoner == PlayedCharacterManager.getInstance().id)
                            {
                                PlayedCharacterManager.getInstance().removeSummonedCreature();
                                SpellWrapper.refreshAllPlayerSpellHolder(PlayedCharacterManager.getInstance().id);
                            }
                        }
                    }
                    _loc_35 = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
                    if (_loc_35)
                    {
                        _loc_35.outEntity(_loc_28.targetId);
                    }
                    FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc_28.targetId);
                    return true;
                }
                case param1 is GameActionFightVanishMessage:
                {
                    _loc_36 = param1 as GameActionFightVanishMessage;
                    this.pushVanishStep(_loc_36.targetId, _loc_36.sourceId);
                    _loc_37 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc_36.targetId);
                    if (_loc_37 is GameFightFighterInformations)
                    {
                        (_loc_37 as GameFightFighterInformations).alive = false;
                    }
                    _loc_38 = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
                    if (_loc_38)
                    {
                        _loc_38.outEntity(_loc_36.targetId);
                    }
                    FightEntitiesFrame.getCurrentInstance().updateRemovedEntity(_loc_36.targetId);
                    return true;
                }
                case param1 is GameActionFightTriggerEffectMessage:
                {
                    return true;
                }
                case param1 is GameActionFightDispellEffectMessage:
                {
                    _loc_39 = param1 as GameActionFightDispellEffectMessage;
                    this.pushDispellEffectStep(_loc_39.targetId, _loc_39.boostUID);
                    return true;
                }
                case param1 is GameActionFightDispellSpellMessage:
                {
                    _loc_40 = param1 as GameActionFightDispellSpellMessage;
                    this.pushDispellSpellStep(_loc_40.targetId, _loc_40.spellId);
                    return true;
                }
                case param1 is GameActionFightDispellMessage:
                {
                    _loc_41 = param1 as GameActionFightDispellMessage;
                    this.pushDispellStep(_loc_41.targetId);
                    return true;
                }
                case param1 is GameActionFightDodgePointLossMessage:
                {
                    _loc_42 = param1 as GameActionFightDodgePointLossMessage;
                    this.pushPointsLossDodgeStep(_loc_42.targetId, _loc_42.actionId, _loc_42.amount);
                    return true;
                }
                case param1 is GameActionFightSpellCooldownVariationMessage:
                {
                    _loc_43 = param1 as GameActionFightSpellCooldownVariationMessage;
                    this.pushSpellCooldownVariationStep(_loc_43.targetId, _loc_43.actionId, _loc_43.spellId, _loc_43.value);
                    return true;
                }
                case param1 is GameActionFightSpellImmunityMessage:
                {
                    _loc_44 = param1 as GameActionFightSpellImmunityMessage;
                    this.pushSpellImmunityStep(_loc_44.targetId);
                    return true;
                }
                case param1 is GameActionFightInvisibleObstacleMessage:
                {
                    _loc_45 = param1 as GameActionFightInvisibleObstacleMessage;
                    this.pushInvisibleObstacleStep(_loc_45.sourceId, _loc_45.sourceSpellId);
                    return true;
                }
                case param1 is GameActionFightKillMessage:
                {
                    _loc_46 = param1 as GameActionFightKillMessage;
                    this.pushKillStep(_loc_46.targetId, _loc_46.sourceId);
                    return true;
                }
                case param1 is GameActionFightReduceDamagesMessage:
                {
                    _loc_47 = param1 as GameActionFightReduceDamagesMessage;
                    this.pushReducedDamagesStep(_loc_47.targetId, _loc_47.amount);
                    return true;
                }
                case param1 is GameActionFightReflectDamagesMessage:
                {
                    _loc_48 = param1 as GameActionFightReflectDamagesMessage;
                    this.pushReflectedDamagesStep(_loc_48.sourceId, _loc_48.amount);
                    return true;
                }
                case param1 is GameActionFightReflectSpellMessage:
                {
                    _loc_49 = param1 as GameActionFightReflectSpellMessage;
                    this.pushReflectedSpellStep(_loc_49.targetId);
                    return true;
                }
                case param1 is GameActionFightStealKamaMessage:
                {
                    _loc_50 = param1 as GameActionFightStealKamaMessage;
                    this.pushStealKamasStep(_loc_50.sourceId, _loc_50.targetId, _loc_50.amount);
                    return true;
                }
                case param1 is GameActionFightTackledMessage:
                {
                    _loc_51 = param1 as GameActionFightTackledMessage;
                    this.pushTackledStep(_loc_51.sourceId);
                    return true;
                }
                case param1 is GameActionFightTriggerGlyphTrapMessage:
                {
                    _loc_52 = param1 as GameActionFightTriggerGlyphTrapMessage;
                    this.pushMarkTriggeredStep(_loc_52.triggeringCharacterId, _loc_52.sourceId, _loc_52.markId);
                    this._fxScriptId = 1;
                    this._castingSpell = new CastingSpell();
                    this._castingSpell.casterId = _loc_52.sourceId;
                    _loc_53 = FightEntitiesFrame.getCurrentInstance().getEntityInfos(_loc_52.triggeringCharacterId).disposition.cellId;
                    if (_loc_53 != -1)
                    {
                        this._castingSpell.targetedCell = MapPoint.fromCellId(_loc_53);
                        this._castingSpell.spell = Spell.getSpellById(1750);
                        this._castingSpell.spellRank = this._castingSpell.spell.getSpellLevel(1);
                    }
                    return true;
                }
                case param1 is GameActionFightDispellableEffectMessage:
                {
                    _loc_54 = param1 as GameActionFightDispellableEffectMessage;
                    if (_loc_54.actionId == ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST)
                    {
                        _loc_55 = new CastingSpell(false);
                    }
                    else
                    {
                        _loc_55 = new CastingSpell(this._castingSpell == null);
                    }
                    if (this._castingSpell)
                    {
                        _loc_55.castingSpellId = this._castingSpell.castingSpellId;
                    }
                    _loc_55.spell = Spell.getSpellById(_loc_54.effect.spellId);
                    _loc_55.casterId = _loc_54.sourceId;
                    _loc_56 = _loc_54.effect;
                    _loc_57 = BuffManager.makeBuffFromEffect(_loc_56, _loc_55, _loc_54.actionId);
                    switch(true)
                    {
                        case _loc_56 is FightTemporaryBoostEffect:
                        {
                            _loc_87 = _loc_54.actionId;
                            if (_loc_87 != ActionIdConverter.ACTION_CHARACTER_MAKE_INVISIBLE && _loc_87 != ActionIdConverter.ACTION_CHARACTER_UPDATE_BOOST && _loc_87 != ActionIdConverter.ACTION_CHARACTER_CHANGE_LOOK && _loc_87 != ActionIdConverter.ACTION_CHARACTER_CHANGE_COLOR && _loc_87 != ActionIdConverter.ACTION_CHARACTER_ADD_APPEARANCE && _loc_87 != ActionIdConverter.ACTION_FIGHT_SET_STATE)
                            {
                                this.pushTemporaryBoostStep(_loc_54.effect.targetId, _loc_57.effects.description, _loc_57.effects.duration, _loc_57.effects.durationString);
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    this.pushDisplayBuffStep(_loc_57);
                    return true;
                }
                case param1 is GameActionFightModifyEffectsDurationMessage:
                {
                    _loc_58 = param1 as GameActionFightModifyEffectsDurationMessage;
                    this.pushModifyEffectsDurationStep(_loc_58.sourceId, _loc_58.targetId, _loc_58.delta);
                    return false;
                }
                case param1 is GameActionFightCarryCharacterMessage:
                {
                    _loc_59 = param1 as GameActionFightCarryCharacterMessage;
                    if (_loc_59.cellId != -1)
                    {
                        this.pushCarryCharacterStep(_loc_59.sourceId, _loc_59.targetId, _loc_59.cellId);
                    }
                    return false;
                }
                case param1 is GameActionFightThrowCharacterMessage:
                {
                    _loc_60 = param1 as GameActionFightThrowCharacterMessage;
                    this.pushThrowCharacterStep(_loc_60.sourceId, _loc_60.targetId, _loc_60.cellId);
                    return false;
                }
                case param1 is GameActionFightDropCharacterMessage:
                {
                    _loc_61 = param1 as GameActionFightDropCharacterMessage;
                    this.pushThrowCharacterStep(_loc_61.sourceId, _loc_61.targetId, _loc_61.cellId);
                    return false;
                }
                case param1 is GameActionFightInvisibleDetectedMessage:
                {
                    _loc_62 = param1 as GameActionFightInvisibleDetectedMessage;
                    this.pushFightInvisibleTemporarilyDetectedStep(_loc_62.sourceId, _loc_62.cellId);
                    FightEntitiesFrame.getCurrentInstance().setLastKnownEntityPosition(_loc_62.targetId, _loc_62.cellId);
                    FightEntitiesFrame.getCurrentInstance().setLastKnownEntityMovementPoint(_loc_62.targetId, 0);
                    return true;
                }
                case param1 is AbstractGameActionMessage:
                {
                    _log.error("Unsupported game action " + param1 + " ! This action was discarded.");
                    return true;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        public function execute(param1:Function = null) : void
        {
            var _loc_2:Uri = null;
            var _loc_3:SpellFxRunner = null;
            this._sequencer = new SerialSequencer(FIGHT_SEQUENCERS_CATEGORY);
            if (this._parent)
            {
                _log.info("Process sub sequence");
                this._parent.addSubSequence(this._sequencer);
            }
            else
            {
                _log.info("Execute sequence");
            }
            if (this._fxScriptId > 0)
            {
                _loc_2 = new Uri(LangManager.getInstance().getEntry("config.script.spellFx") + this._fxScriptId + ".dx");
                _loc_3 = new SpellFxRunner(this);
                this._scriptStarted = getTimer();
                ScriptExec.exec(_loc_2, _loc_3, true, new Callback(this.executeBuffer, param1, true, true), new Callback(this.executeBuffer, param1, true, false));
            }
            else
            {
                this.executeBuffer(param1, false);
            }
            return;
        }// end function

        private function executeBuffer(param1:Function, param2:Boolean, param3:Boolean = false) : void
        {
            var _loc_8:ISequencable = null;
            var _loc_10:Boolean = false;
            var _loc_11:Boolean = false;
            var _loc_12:Array = null;
            var _loc_13:Array = null;
            var _loc_14:Boolean = false;
            var _loc_15:Dictionary = null;
            var _loc_16:Dictionary = null;
            var _loc_17:Dictionary = null;
            var _loc_18:Dictionary = null;
            var _loc_19:Dictionary = null;
            var _loc_20:int = 0;
            var _loc_21:* = undefined;
            var _loc_22:* = undefined;
            var _loc_23:WaitAnimationEventStep = null;
            var _loc_24:uint = 0;
            var _loc_25:PlayAnimationStep = null;
            var _loc_26:FightDeathStep = null;
            var _loc_27:FightActionPointsVariationStep = null;
            var _loc_28:FightShieldPointsVariationStep = null;
            var _loc_29:FightLifeVariationStep = null;
            var _loc_30:int = 0;
            var _loc_31:* = undefined;
            var _loc_32:uint = 0;
            if (param2)
            {
                _loc_24 = getTimer() - this._scriptStarted;
                if (!param3)
                {
                    _log.warn("Script failed during a fight sequence, but still took " + _loc_24 + "ms.");
                }
                else
                {
                    _log.info("Script successfuly executed in " + _loc_24 + "ms.");
                }
            }
            var _loc_4:Array = [];
            var _loc_5:* = new Dictionary(true);
            var _loc_6:* = new Dictionary(true);
            var _loc_7:* = new Dictionary(true);
            var _loc_9:Boolean = false;
            for each (_loc_8 in this._stepsBuffer)
            {
                
                switch(true)
                {
                    case _loc_8 is FightMarkTriggeredStep:
                    {
                        _loc_9 = true;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            _loc_10 = OptionManager.getOptionManager("dofus")["allowHitAnim"];
            _loc_11 = OptionManager.getOptionManager("dofus")["allowSpellEffects"];
            _loc_12 = [];
            _loc_13 = [];
            _loc_15 = new Dictionary();
            _loc_16 = new Dictionary(true);
            _loc_17 = new Dictionary(true);
            _loc_18 = new Dictionary(true);
            _loc_19 = new Dictionary(true);
            _loc_20 = this._stepsBuffer.length;
            while (--_loc_20 >= 0)
            {
                
                if (_loc_14 && _loc_8)
                {
                    _loc_8.clear();
                }
                _loc_14 = true;
                _loc_8 = this._stepsBuffer[_loc_20];
                switch(true)
                {
                    case _loc_8 is PlayAnimationStep:
                    {
                        _loc_25 = _loc_8 as PlayAnimationStep;
                        if (_loc_25.animation.indexOf(AnimationEnum.ANIM_HIT) != -1)
                        {
                            if (!_loc_10)
                            {
                                break;
                            }
                            _loc_25.waitEvent = _loc_9;
                            if (_loc_5[EntitiesManager.getInstance().getEntityID(_loc_25.target as IEntity)])
                            {
                                break;
                            }
                            if (_loc_6[_loc_25.target])
                            {
                                break;
                            }
                            _loc_6[_loc_25.target] = true;
                        }
                        if (this._castingSpell.casterId < 0)
                        {
                            if (_loc_15[_loc_25.target])
                            {
                                _loc_4.unshift(_loc_15[_loc_25.target]);
                                delete _loc_15[_loc_25.target];
                            }
                            if (_loc_25.animation.indexOf(AnimationEnum.ANIM_ATTAQUE_BASE) != -1)
                            {
                                _loc_15[_loc_25.target] = new WaitAnimationEventStep(_loc_25);
                            }
                        }
                        break;
                    }
                    case _loc_8 is FightDeathStep:
                    {
                        _loc_26 = _loc_8 as FightDeathStep;
                        _loc_5[_loc_26.entityId] = true;
                        break;
                    }
                    case _loc_8 is FightActionPointsVariationStep:
                    {
                        _loc_27 = _loc_8 as FightActionPointsVariationStep;
                        if (_loc_27.voluntarlyUsed)
                        {
                            _loc_12.push(_loc_27);
                            _loc_14 = false;
                            break;
                        }
                        break;
                    }
                    case _loc_8 is FightShieldPointsVariationStep:
                    {
                        _loc_28 = _loc_8 as FightShieldPointsVariationStep;
                        if (_loc_18[_loc_28.target] == null)
                        {
                            _loc_18[_loc_28.target] = 0;
                        }
                        _loc_18[_loc_28.target] = _loc_18[_loc_28.target] + _loc_28.value;
                        _loc_19[_loc_28.target] = _loc_28;
                        break;
                    }
                    case _loc_8 is FightLifeVariationStep:
                    {
                        _loc_29 = _loc_8 as FightLifeVariationStep;
                        if (_loc_29.delta < 0)
                        {
                            _loc_7[_loc_29.target] = _loc_29;
                        }
                        if (_loc_16[_loc_29.target] == null)
                        {
                            _loc_16[_loc_29.target] = 0;
                        }
                        _loc_16[_loc_29.target] = _loc_16[_loc_29.target] + _loc_29.delta;
                        _loc_17[_loc_29.target] = _loc_29;
                        break;
                    }
                    case _loc_8 is AddGfxEntityStep:
                    case _loc_8 is AddGfxInLineStep:
                    case _loc_8 is ParableGfxMovementStep:
                    case _loc_8 is AddWorldEntityStep:
                    {
                        if (!_loc_11)
                        {
                            break;
                        }
                        break;
                    }
                    default:
                    {
                        break;
                        break;
                    }
                }
                _loc_14 = false;
                _loc_4.unshift(_loc_8);
            }
            for each (_loc_21 in _loc_4)
            {
                
                if (_loc_21 is FightLifeVariationStep && _loc_16[_loc_21.target] == 0 && _loc_18[_loc_21.target] != null)
                {
                    _loc_21.skipTextEvent = true;
                }
            }
            for (_loc_22 in _loc_16)
            {
                
                if (_loc_16[_loc_22] != 0)
                {
                    _loc_30 = _loc_4.indexOf(_loc_17[_loc_22]);
                    _loc_4.splice(_loc_30, 0, new FightLossAnimStep(_loc_22, _loc_16[_loc_22], FightLifeVariationStep.COLOR));
                }
                _loc_17[_loc_22] = -1;
                _loc_16[_loc_22] = 0;
            }
            for (_loc_22 in _loc_18)
            {
                
                if (_loc_18[_loc_22] != 0)
                {
                    _loc_30 = _loc_4.indexOf(_loc_19[_loc_22]);
                    _loc_4.splice(_loc_30, 0, new FightLossAnimStep(_loc_22, _loc_18[_loc_22], FightShieldPointsVariationStep.COLOR));
                }
                _loc_19[_loc_22] = -1;
                _loc_18[_loc_22] = 0;
            }
            for each (_loc_23 in _loc_15)
            {
                
                _loc_13.push(_loc_23);
            }
            if (_loc_10)
            {
                for (_loc_31 in _loc_7)
                {
                    
                    if (!_loc_6[_loc_31])
                    {
                        _loc_32 = 0;
                        while (_loc_32 < _loc_4.length)
                        {
                            
                            if (_loc_4[_loc_32] == _loc_7[_loc_31])
                            {
                                _loc_4.splice(_loc_32, 0, new PlayAnimationStep(_loc_31 as TiphonSprite, AnimationEnum.ANIM_HIT, true, false));
                                break;
                            }
                            _loc_32 = _loc_32 + 1;
                        }
                    }
                }
            }
            _loc_4 = _loc_12.concat(_loc_4).concat(_loc_13);
            for each (_loc_8 in _loc_4)
            {
                
                this._sequencer.addStep(_loc_8);
            }
            this.clearBuffer();
            if (param1 != null && !this._parent)
            {
                this._sequenceEndCallback = param1;
                this._sequencer.addEventListener(SequencerEvent.SEQUENCE_END, this.onSequenceEnd);
            }
            _lastCastingSpell = this._castingSpell;
            this._scriptInit = true;
            if (!this._parent)
            {
                if (!this._subSequenceWaitingCount)
                {
                    this._sequencer.start();
                }
                else
                {
                    _log.warn("Waiting sub sequence init end (" + this._subSequenceWaitingCount + " seq)");
                }
            }
            else
            {
                if (param1 != null)
                {
                    this.param1();
                }
                this._parent.subSequenceInitDone();
            }
            return;
        }// end function

        private function onSequenceEnd(event:SequencerEvent) : void
        {
            this._sequencer.removeEventListener(SequencerEvent.SEQUENCE_END, this.onSequenceEnd);
            this._sequenceEndCallback();
            return;
        }// end function

        private function subSequenceInitDone() : void
        {
            var _loc_1:String = this;
            var _loc_2:* = this._subSequenceWaitingCount - 1;
            _loc_1._subSequenceWaitingCount = _loc_2;
            if (!this.isWaiting && this._sequencer && !this._sequencer.running)
            {
                _log.warn("Sub sequence init end -- Run main sequence");
                this._sequencer.start();
            }
            return;
        }// end function

        private function pushMovementStep(param1:int, param2:MovementPath) : void
        {
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param1)));
            var _loc_3:* = new FightEntityMovementStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushTeleportStep(param1:int, param2:int) : void
        {
            var _loc_3:FightTeleportStep = null;
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param1)));
            if (param2 != -1)
            {
                _loc_3 = new FightTeleportStep(param1, MapPoint.fromCellId(param2));
                if (this.castingSpell != null)
                {
                    _loc_3.castingSpellId = this.castingSpell.castingSpellId;
                }
                this._stepsBuffer.push(_loc_3);
            }
            return;
        }// end function

        private function pushExchangePositionsStep(param1:int, param2:int, param3:int, param4:int) : void
        {
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param1)));
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param3)));
            var _loc_5:* = new FightExchangePositionsStep(param1, param2, param3, param4);
            if (this.castingSpell != null)
            {
                _loc_5.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_5);
            return;
        }// end function

        private function pushSlideStep(param1:int, param2:int, param3:int) : void
        {
            if (param2 < 0 || param3 < 0)
            {
                return;
            }
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param1)));
            var _loc_4:* = new FightEntitySlideStep(param1, MapPoint.fromCellId(param2), MapPoint.fromCellId(param3));
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushSummonStep(param1:int, param2:GameFightFighterInformations) : void
        {
            var _loc_3:* = new FightSummonStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushVisibilityStep(param1:int, param2:Boolean) : void
        {
            var _loc_3:* = new FightVisibilityStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushMarkCellsStep(param1:int, param2:int, param3:Vector.<GameActionMarkedCell>, param4:int) : void
        {
            var _loc_5:* = new FightMarkCellsStep(param1, param2, this._castingSpell.spellRank, param3, param4);
            if (this.castingSpell != null)
            {
                _loc_5.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_5);
            return;
        }// end function

        private function pushUnmarkCellsStep(param1:int) : void
        {
            var _loc_2:* = new FightUnmarkCellsStep(param1);
            if (this.castingSpell != null)
            {
                _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushChangeLookStep(param1:int, param2:EntityLook) : void
        {
            var _loc_3:* = new FightChangeLookStep(param1, EntityLookAdapter.fromNetwork(param2));
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushChangeVisibilityStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightChangeVisibilityStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushPointsVariationStep(param1:int, param2:uint, param3:int) : void
        {
            var _loc_4:IFightStep = null;
            switch(param2)
            {
                case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_USE:
                {
                    _loc_4 = new FightActionPointsVariationStep(param1, param3, true);
                    break;
                }
                case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_LOST:
                case ActionIdConverter.ACTION_CHARACTER_ACTION_POINTS_WIN:
                {
                    _loc_4 = new FightActionPointsVariationStep(param1, param3, false);
                    break;
                }
                case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_USE:
                {
                    _loc_4 = new FightMovementPointsVariationStep(param1, param3, true);
                    break;
                }
                case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_LOST:
                case ActionIdConverter.ACTION_CHARACTER_MOVEMENT_POINTS_WIN:
                {
                    _loc_4 = new FightMovementPointsVariationStep(param1, param3, false);
                    break;
                }
                default:
                {
                    _log.warn("Points variation with unsupported action (" + param2 + "), skipping.");
                    return;
                    break;
                }
            }
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushShieldPointsVariationStep(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = new FightShieldPointsVariationStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushTemporaryBoostStep(param1:int, param2:String, param3:int, param4:String) : void
        {
            var _loc_5:* = new FightTemporaryBoostStep(param1, param2, param3, param4);
            if (this.castingSpell != null)
            {
                _loc_5.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_5);
            return;
        }// end function

        private function pushPointsLossDodgeStep(param1:int, param2:uint, param3:int) : void
        {
            var _loc_4:IFightStep = null;
            switch(param2)
            {
                case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PA:
                {
                    _loc_4 = new FightActionPointsLossDodgeStep(param1, param3);
                    break;
                }
                case ActionIdConverter.ACTION_FIGHT_SPELL_DODGED_PM:
                {
                    _loc_4 = new FightMovementPointsLossDodgeStep(param1, param3);
                    break;
                }
                default:
                {
                    _log.warn("Points dodge with unsupported action (" + param2 + "), skipping.");
                    return;
                    break;
                }
            }
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushLifePointsVariationStep(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:* = new FightLifeVariationStep(param1, param2, param3, param4);
            if (this.castingSpell != null)
            {
                _loc_5.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_5);
            return;
        }// end function

        private function pushDeathStep(param1:int, param2:Boolean = true) : void
        {
            var _loc_3:* = new FightDeathStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushVanishStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightVanishStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushDispellStep(param1:int) : void
        {
            var _loc_2:* = new FightDispellStep(param1);
            _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushDispellEffectStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightDispellEffectStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushDispellSpellStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightDispellSpellStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushSpellCooldownVariationStep(param1:int, param2:int, param3:int, param4:int) : void
        {
            var _loc_5:* = new FightSpellCooldownVariationStep(param1, param2, param3, param4);
            if (this.castingSpell != null)
            {
                _loc_5.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_5);
            return;
        }// end function

        private function pushSpellImmunityStep(param1:int) : void
        {
            var _loc_2:* = new FightSpellImmunityStep(param1);
            if (this.castingSpell != null)
            {
                _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushInvisibleObstacleStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightInvisibleObstacleStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushKillStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightKillStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushReducedDamagesStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightReducedDamagesStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushReflectedDamagesStep(param1:int, param2:int) : void
        {
            var _loc_3:* = new FightReflectedDamagesStep(param1, param2);
            if (this.castingSpell != null)
            {
                _loc_3.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_3);
            return;
        }// end function

        private function pushReflectedSpellStep(param1:int) : void
        {
            var _loc_2:* = new FightReflectedSpellStep(param1);
            if (this.castingSpell != null)
            {
                _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushSpellCastStep(param1:int, param2:int, param3:int, param4:int, param5:uint, param6:uint) : void
        {
            var _loc_7:* = new FightSpellCastStep(param1, param2, param3, param4, param5, param6);
            if (this.castingSpell != null)
            {
                _loc_7.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_7);
            return;
        }// end function

        private function pushCloseCombatStep(param1:int, param2:uint, param3:uint) : void
        {
            var _loc_4:* = new FightCloseCombatStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushStealKamasStep(param1:int, param2:int, param3:uint) : void
        {
            var _loc_4:* = new FightStealingKamasStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushTackledStep(param1:int) : void
        {
            var _loc_2:* = new FightTackledStep(param1);
            if (this.castingSpell != null)
            {
                _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushMarkTriggeredStep(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = new FightMarkTriggeredStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushDisplayBuffStep(param1:BasicBuff) : void
        {
            var _loc_2:* = new FightDisplayBuffStep(param1);
            if (this.castingSpell != null)
            {
                _loc_2.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_2);
            return;
        }// end function

        private function pushModifyEffectsDurationStep(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = new FightModifyEffectsDurationStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushCarryCharacterStep(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = new FightCarryCharacterStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            this._stepsBuffer.push(new CallbackStep(new Callback(deleteTooltip, param2)));
            return;
        }// end function

        private function pushThrowCharacterStep(param1:int, param2:int, param3:int) : void
        {
            var _loc_4:* = new FightThrowCharacterStep(param1, param2, param3);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function pushFightInvisibleTemporarilyDetectedStep(param1:int, param2:uint) : void
        {
            var _loc_3:* = DofusEntities.getEntity(param1) as AnimatedCharacter;
            var _loc_4:* = new FightInvisibleTemporarilyDetectedStep(_loc_3, param2);
            if (this.castingSpell != null)
            {
                _loc_4.castingSpellId = this.castingSpell.castingSpellId;
            }
            this._stepsBuffer.push(_loc_4);
            return;
        }// end function

        private function clearBuffer() : void
        {
            this._stepsBuffer = new Vector.<ISequencable>(0, false);
            return;
        }// end function

        public static function get lastCastingSpell() : CastingSpell
        {
            return _lastCastingSpell;
        }// end function

        public static function get currentInstanceId() : uint
        {
            return _currentInstanceId;
        }// end function

        private static function deleteTooltip(param1:int) : void
        {
            var _loc_2:FightContextFrame = null;
            if (FightContextFrame.fighterEntityTooltipId == param1)
            {
                TooltipManager.hide();
                TooltipManager.hide("fighter");
                _loc_2 = Kernel.getWorker().getFrame(FightContextFrame) as FightContextFrame;
                if (_loc_2)
                {
                    _loc_2.outEntity(param1);
                }
            }
            return;
        }// end function

    }
}
