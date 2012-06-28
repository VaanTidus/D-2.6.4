﻿package com.ankamagames.dofus.logic.game.roleplay.frames
{
    import __AS3__.vec.*;
    import com.ankamagames.atouin.*;
    import com.ankamagames.atouin.data.*;
    import com.ankamagames.atouin.data.map.*;
    import com.ankamagames.atouin.managers.*;
    import com.ankamagames.atouin.messages.*;
    import com.ankamagames.atouin.utils.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.berilia.types.*;
    import com.ankamagames.dofus.datacenter.communication.*;
    import com.ankamagames.dofus.datacenter.items.*;
    import com.ankamagames.dofus.datacenter.npcs.*;
    import com.ankamagames.dofus.datacenter.spells.*;
    import com.ankamagames.dofus.datacenter.world.*;
    import com.ankamagames.dofus.internalDatacenter.communication.*;
    import com.ankamagames.dofus.internalDatacenter.guild.*;
    import com.ankamagames.dofus.internalDatacenter.world.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.kernel.net.*;
    import com.ankamagames.dofus.kernel.sound.*;
    import com.ankamagames.dofus.logic.common.actions.*;
    import com.ankamagames.dofus.logic.game.approach.managers.*;
    import com.ankamagames.dofus.logic.game.common.actions.*;
    import com.ankamagames.dofus.logic.game.common.actions.bid.*;
    import com.ankamagames.dofus.logic.game.common.actions.craft.*;
    import com.ankamagames.dofus.logic.game.common.actions.exchange.*;
    import com.ankamagames.dofus.logic.game.common.actions.humanVendor.*;
    import com.ankamagames.dofus.logic.game.common.actions.mount.*;
    import com.ankamagames.dofus.logic.game.common.actions.roleplay.*;
    import com.ankamagames.dofus.logic.game.common.actions.taxCollector.*;
    import com.ankamagames.dofus.logic.game.common.frames.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.common.misc.*;
    import com.ankamagames.dofus.logic.game.fight.managers.*;
    import com.ankamagames.dofus.logic.game.roleplay.actions.*;
    import com.ankamagames.dofus.logic.game.roleplay.managers.*;
    import com.ankamagames.dofus.logic.game.roleplay.messages.*;
    import com.ankamagames.dofus.logic.game.roleplay.types.*;
    import com.ankamagames.dofus.misc.*;
    import com.ankamagames.dofus.misc.lists.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.messages.game.basic.*;
    import com.ankamagames.dofus.network.messages.game.context.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.death.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.document.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.fight.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.job.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.npc.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.paddock.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.spell.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.visual.*;
    import com.ankamagames.dofus.network.messages.game.dialog.*;
    import com.ankamagames.dofus.network.messages.game.guild.*;
    import com.ankamagames.dofus.network.messages.game.guild.tax.*;
    import com.ankamagames.dofus.network.messages.game.interactive.zaap.*;
    import com.ankamagames.dofus.network.messages.game.inventory.exchanges.*;
    import com.ankamagames.dofus.network.messages.game.inventory.items.*;
    import com.ankamagames.dofus.network.messages.game.script.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.*;
    import com.ankamagames.dofus.scripts.*;
    import com.ankamagames.dofus.types.entities.*;
    import com.ankamagames.dofus.types.enums.*;
    import com.ankamagames.dofus.uiApi.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.entities.interfaces.*;
    import com.ankamagames.jerakine.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.network.messages.*;
    import com.ankamagames.jerakine.script.*;
    import com.ankamagames.jerakine.sequencer.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.jerakine.utils.display.*;
    import com.ankamagames.jerakine.utils.system.*;
    import com.hurlant.util.*;
    import flash.events.*;
    import flash.geom.*;
    import flash.utils.*;

    public class RoleplayContextFrame extends Object implements Frame
    {
        private var _priority:int = 0;
        private var _entitiesFrame:RoleplayEntitiesFrame;
        private var _worldFrame:RoleplayWorldFrame;
        private var _interactivesFrame:RoleplayInteractivesFrame;
        private var _npcDialogFrame:NpcDialogFrame;
        private var _documentFrame:DocumentFrame;
        private var _zaapFrame:ZaapFrame;
        private var _paddockFrame:PaddockFrame;
        private var _emoticonFrame:RoleplayEmoticonFrame;
        private var _exchangeManagementFrame:ExchangeManagementFrame;
        private var _humanVendorManagementFrame:HumanVendorManagementFrame;
        private var _spectatorManagementFrame:SpectatorManagementFrame;
        private var _bidHouseManagementFrame:BidHouseManagementFrame;
        private var _estateFrame:EstateFrame;
        private var _prismFrame:PrismFrame;
        private var _craftFrame:CraftFrame;
        private var _commonExchangeFrame:CommonExchangeManagementFrame;
        private var _movementFrame:RoleplayMovementFrame;
        private var _spellForgetDialogFrame:SpellForgetDialogFrame;
        private var _currentWaitingFightId:uint;
        private var _crafterId:uint;
        private var _customerID:uint;
        private var _playersMultiCraftSkill:Array;
        private var _currentPaddock:PaddockWrapper;
        private var _playerEntity:AnimatedCharacter;
        private var _intercationIsLimited:Boolean = false;
        static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayContextFrame));
        private static const ASTRUB_SUBAREA_IDS:Array = [143, 92, 95, 96, 97, 98, 99, 100, 101, 173, 318, 306];
        private static var currentStatus:int = -1;

        public function RoleplayContextFrame()
        {
            return;
        }// end function

        public function get crafterId() : uint
        {
            return this._crafterId;
        }// end function

        public function get customerID() : uint
        {
            return this._customerID;
        }// end function

        public function get priority() : int
        {
            return this._priority;
        }// end function

        public function set priority(param1:int) : void
        {
            this._priority = param1;
            return;
        }// end function

        public function get entitiesFrame() : RoleplayEntitiesFrame
        {
            return this._entitiesFrame;
        }// end function

        public function get hasWorldInteraction() : Boolean
        {
            return !this._intercationIsLimited;
        }// end function

        public function get commonExchangeFrame() : CommonExchangeManagementFrame
        {
            return this._commonExchangeFrame;
        }// end function

        public function get hasGuildedPaddock() : Boolean
        {
            return this._currentPaddock && this._currentPaddock.guildIdentity;
        }// end function

        public function get currentPaddock() : PaddockWrapper
        {
            return this._currentPaddock;
        }// end function

        public function pushed() : Boolean
        {
            this._entitiesFrame = new RoleplayEntitiesFrame();
            this._movementFrame = new RoleplayMovementFrame();
            this._worldFrame = new RoleplayWorldFrame();
            this._interactivesFrame = new RoleplayInteractivesFrame();
            this._npcDialogFrame = new NpcDialogFrame();
            this._documentFrame = new DocumentFrame();
            this._zaapFrame = new ZaapFrame();
            this._paddockFrame = new PaddockFrame();
            this._exchangeManagementFrame = new ExchangeManagementFrame();
            this._spectatorManagementFrame = new SpectatorManagementFrame();
            this._bidHouseManagementFrame = new BidHouseManagementFrame();
            this._estateFrame = new EstateFrame();
            this._craftFrame = new CraftFrame();
            this._humanVendorManagementFrame = new HumanVendorManagementFrame();
            this._spellForgetDialogFrame = new SpellForgetDialogFrame();
            Kernel.getWorker().addFrame(this._spectatorManagementFrame);
            if (!Kernel.getWorker().contains(EstateFrame))
            {
                Kernel.getWorker().addFrame(this._estateFrame);
            }
            this._prismFrame = Kernel.getWorker().getFrame(PrismFrame) as PrismFrame;
            this._prismFrame.pushRoleplay();
            if (!Kernel.getWorker().contains(RoleplayEmoticonFrame))
            {
                this._emoticonFrame = new RoleplayEmoticonFrame();
                Kernel.getWorker().addFrame(this._emoticonFrame);
            }
            else
            {
                this._emoticonFrame = Kernel.getWorker().getFrame(RoleplayEmoticonFrame) as RoleplayEmoticonFrame;
            }
            this._playersMultiCraftSkill = new Array();
            return true;
        }// end function

        public function process(param1:Message) : Boolean
        {
            var _loc_2:CurrentMapMessage = null;
            var _loc_3:WorldPointWrapper = null;
            var _loc_4:ByteArray = null;
            var _loc_5:Object = null;
            var _loc_6:MapPosition = null;
            var _loc_7:ChangeWorldInteractionAction = null;
            var _loc_8:Boolean = false;
            var _loc_9:NpcGenericActionRequestAction = null;
            var _loc_10:IEntity = null;
            var _loc_11:NpcGenericActionRequestMessage = null;
            var _loc_12:ExchangeRequestOnTaxCollectorAction = null;
            var _loc_13:ExchangeRequestOnTaxCollectorMessage = null;
            var _loc_14:IEntity = null;
            var _loc_15:GameRolePlayTaxCollectorFightRequestAction = null;
            var _loc_16:GameRolePlayTaxCollectorFightRequestMessage = null;
            var _loc_17:InteractiveElementActivationAction = null;
            var _loc_18:InteractiveElementActivationMessage = null;
            var _loc_19:DisplayContextualMenuAction = null;
            var _loc_20:GameContextActorInformations = null;
            var _loc_21:RoleplayInteractivesFrame = null;
            var _loc_22:NpcDialogCreationMessage = null;
            var _loc_23:Object = null;
            var _loc_24:ExchangeShowVendorTaxMessage = null;
            var _loc_25:ExchangeReplyTaxVendorMessage = null;
            var _loc_26:ExchangeOnHumanVendorRequestAction = null;
            var _loc_27:ExchangeRequestOnShopStockMessage = null;
            var _loc_28:ExchangeOnHumanVendorRequestAction = null;
            var _loc_29:ExchangeOnHumanVendorRequestMessage = null;
            var _loc_30:ExchangeStartOkHumanVendorMessage = null;
            var _loc_31:ExchangeShopStockStartedMessage = null;
            var _loc_32:IEntity = null;
            var _loc_33:ExchangeStartAsVendorMessage = null;
            var _loc_34:ExpectedSocketClosureMessage = null;
            var _loc_35:ExchangeStartedMountStockMessage = null;
            var _loc_36:ExchangeStartOkNpcShopMessage = null;
            var _loc_37:ExchangeStartedMessage = null;
            var _loc_38:ObjectFoundWhileRecoltingMessage = null;
            var _loc_39:Item = null;
            var _loc_40:uint = 0;
            var _loc_41:CraftSmileyItem = null;
            var _loc_42:uint = 0;
            var _loc_43:String = null;
            var _loc_44:String = null;
            var _loc_45:String = null;
            var _loc_46:PlayerFightRequestAction = null;
            var _loc_47:GameRolePlayPlayerFightRequestMessage = null;
            var _loc_48:IEntity = null;
            var _loc_49:PlayerFightFriendlyAnswerAction = null;
            var _loc_50:GameRolePlayPlayerFightFriendlyAnswerMessage = null;
            var _loc_51:GameRolePlayPlayerFightFriendlyAnsweredMessage = null;
            var _loc_52:GameRolePlayFightRequestCanceledMessage = null;
            var _loc_53:GameRolePlayPlayerFightFriendlyRequestedMessage = null;
            var _loc_54:GameRolePlayFreeSoulRequestMessage = null;
            var _loc_55:LeaveDialogRequestMessage = null;
            var _loc_56:ExchangeErrorMessage = null;
            var _loc_57:String = null;
            var _loc_58:ItemNoMoreAvailableMessage = null;
            var _loc_59:String = null;
            var _loc_60:GameRolePlayAggressionMessage = null;
            var _loc_61:LeaveDialogRequestMessage = null;
            var _loc_62:ExchangeShopStockMouvmentAddAction = null;
            var _loc_63:ExchangeObjectMovePricedMessage = null;
            var _loc_64:ExchangeShopStockMouvmentRemoveAction = null;
            var _loc_65:ExchangeObjectMoveMessage = null;
            var _loc_66:ExchangeBuyAction = null;
            var _loc_67:ExchangeBuyMessage = null;
            var _loc_68:ExchangeSellAction = null;
            var _loc_69:ExchangeSellMessage = null;
            var _loc_70:ExchangeBuyOkMessage = null;
            var _loc_71:ExchangeSellOkMessage = null;
            var _loc_72:ExchangePlayerRequestAction = null;
            var _loc_73:ExchangePlayerRequestMessage = null;
            var _loc_74:ExchangePlayerMultiCraftRequestAction = null;
            var _loc_75:ExchangePlayerMultiCraftRequestMessage = null;
            var _loc_76:JobAllowMultiCraftRequestSetAction = null;
            var _loc_77:JobAllowMultiCraftRequestSetMessage = null;
            var _loc_78:JobAllowMultiCraftRequestMessage = null;
            var _loc_79:uint = 0;
            var _loc_80:SpellForgetUIMessage = null;
            var _loc_81:ChallengeFightJoinRefusedMessage = null;
            var _loc_82:SpellForgottenMessage = null;
            var _loc_83:ExchangeCraftResultMessage = null;
            var _loc_84:uint = 0;
            var _loc_85:ExchangeCraftInformationObjectMessage = null;
            var _loc_86:CraftSmileyItem = null;
            var _loc_87:DocumentReadingBeginMessage = null;
            var _loc_88:PaddockSellBuyDialogMessage = null;
            var _loc_89:LeaveDialogRequestMessage = null;
            var _loc_90:GameRolePlaySpellAnimMessage = null;
            var _loc_91:RoleplaySpellCastProvider = null;
            var _loc_92:Uri = null;
            var _loc_93:SpellFxRunner = null;
            var _loc_94:CinematicMessage = null;
            var _loc_95:BasicSwitchModeAction = null;
            var _loc_96:String = null;
            var _loc_97:Object = null;
            var _loc_98:ErrorMapNotFoundMessage = null;
            var _loc_99:int = 0;
            var _loc_100:int = 0;
            var _loc_101:int = 0;
            var _loc_102:Map = null;
            var _loc_103:Boolean = false;
            var _loc_104:GameRolePlayNpcInformations = null;
            var _loc_105:GameRolePlayTaxCollectorInformations = null;
            var _loc_106:IRectangle = null;
            var _loc_107:GameRolePlayCharacterInformations = null;
            var _loc_108:int = 0;
            var _loc_109:int = 0;
            var _loc_110:RoleplayContextFrame = null;
            var _loc_111:GameRolePlayActorInformations = null;
            var _loc_112:GameContextActorInformations = null;
            var _loc_113:JobMultiCraftAvailableSkillsMessage = null;
            var _loc_114:MultiCraftEnableForPlayer = null;
            var _loc_115:Boolean = false;
            var _loc_116:uint = 0;
            var _loc_117:uint = 0;
            var _loc_118:MultiCraftEnableForPlayer = null;
            var _loc_119:Item = null;
            var _loc_120:uint = 0;
            var _loc_121:IRectangle = null;
            var _loc_122:BasicSetAwayModeRequestMessage = null;
            switch(true)
            {
                case param1 is CurrentMapMessage:
                {
                    _loc_2 = param1 as CurrentMapMessage;
                    Kernel.getWorker().pause();
                    ConnectionsHandler.pause();
                    if (TacticModeManager.getInstance().tacticModeActivated)
                    {
                        TacticModeManager.getInstance().hide();
                    }
                    KernelEventsManager.getInstance().processCallback(HookList.StartZoom, false);
                    if (this._entitiesFrame && Kernel.getWorker().contains(RoleplayEntitiesFrame))
                    {
                        Kernel.getWorker().removeFrame(this._entitiesFrame);
                    }
                    if (this._worldFrame && Kernel.getWorker().contains(RoleplayWorldFrame))
                    {
                        Kernel.getWorker().removeFrame(this._worldFrame);
                    }
                    if (this._interactivesFrame && Kernel.getWorker().contains(RoleplayInteractivesFrame))
                    {
                        Kernel.getWorker().removeFrame(this._interactivesFrame);
                    }
                    if (this._movementFrame && Kernel.getWorker().contains(RoleplayMovementFrame))
                    {
                        Kernel.getWorker().removeFrame(this._movementFrame);
                    }
                    if (PlayedCharacterManager.getInstance().isInHouse)
                    {
                        _loc_3 = new WorldPointWrapper(_loc_2.mapId, true, PlayedCharacterManager.getInstance().currentMap.outdoorX, PlayedCharacterManager.getInstance().currentMap.outdoorY);
                    }
                    else
                    {
                        _loc_3 = new WorldPointWrapper(_loc_2.mapId);
                    }
                    Atouin.getInstance().initPreDisplay(_loc_3);
                    Atouin.getInstance().clearEntities();
                    if (_loc_2.mapKey && _loc_2.mapKey.length)
                    {
                        _loc_96 = XmlConfig.getInstance().getEntry("config.maps.encryptionKey");
                        if (!_loc_96)
                        {
                            _loc_96 = _loc_2.mapKey;
                        }
                        _loc_4 = Hex.toArray(Hex.fromString(_loc_96));
                    }
                    Atouin.getInstance().display(_loc_3, _loc_4);
                    PlayedCharacterManager.getInstance().currentMap = _loc_3;
                    TooltipManager.hideAll();
                    _loc_5 = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                    _loc_5.closeAllMenu();
                    this._currentPaddock = null;
                    _loc_6 = MapPosition.getMapPositionById(_loc_2.mapId);
                    if (_loc_6 && ASTRUB_SUBAREA_IDS.indexOf(_loc_6.subAreaId) != -1)
                    {
                        PartManager.getInstance().checkAndDownload("all");
                    }
                    KernelEventsManager.getInstance().processCallback(HookList.CurrentMap, _loc_2.mapId);
                    return true;
                }
                case param1 is MapsLoadingCompleteMessage:
                {
                    if (!Kernel.getWorker().contains(RoleplayEntitiesFrame))
                    {
                        Kernel.getWorker().addFrame(this._entitiesFrame);
                    }
                    TooltipManager.hideAll();
                    KernelEventsManager.getInstance().processCallback(HookList.MapsLoadingComplete, MapsLoadingCompleteMessage(param1).mapPoint);
                    if (!Kernel.getWorker().contains(RoleplayWorldFrame))
                    {
                        Kernel.getWorker().addFrame(this._worldFrame);
                    }
                    if (!Kernel.getWorker().contains(RoleplayInteractivesFrame))
                    {
                        Kernel.getWorker().addFrame(this._interactivesFrame);
                    }
                    if (!Kernel.getWorker().contains(RoleplayMovementFrame))
                    {
                        Kernel.getWorker().addFrame(this._movementFrame);
                    }
                    SoundManager.getInstance().manager.setSubArea(MapsLoadingCompleteMessage(param1).mapData);
                    Atouin.getInstance().updateCursor();
                    Kernel.getWorker().resume();
                    ConnectionsHandler.resume();
                    return true;
                }
                case param1 is MapLoadingFailedMessage:
                {
                    switch(MapLoadingFailedMessage(param1).errorReason)
                    {
                        case MapLoadingFailedMessage.NO_FILE:
                        {
                            _loc_97 = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
                            _loc_97.openPopup(I18n.getUiText("ui.popup.information"), I18n.getUiText("ui.no.mapdata.file"), [I18n.getUiText("ui.common.ok")]);
                            _loc_98 = new ErrorMapNotFoundMessage();
                            _loc_98.initErrorMapNotFoundMessage(MapLoadingFailedMessage(param1).id);
                            ConnectionsHandler.getConnection().send(_loc_98);
                            MapDisplayManager.getInstance().fromMap(new DefaultMap(MapLoadingFailedMessage(param1).id));
                            return true;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    return false;
                }
                case param1 is MapLoadedMessage:
                {
                    if (MapDisplayManager.getInstance().isDefaultMap)
                    {
                        _loc_99 = PlayedCharacterManager.getInstance().currentMap.x;
                        _loc_100 = PlayedCharacterManager.getInstance().currentMap.y;
                        _loc_101 = PlayedCharacterManager.getInstance().currentMap.worldId;
                        _loc_102 = MapDisplayManager.getInstance().getDataMapContainer().dataMap;
                        _loc_102.rightNeighbourId = WorldPoint.fromCoords(_loc_101, (_loc_99 + 1), _loc_100).mapId;
                        _loc_102.leftNeighbourId = WorldPoint.fromCoords(_loc_101, (_loc_99 - 1), _loc_100).mapId;
                        _loc_102.bottomNeighbourId = WorldPoint.fromCoords(_loc_101, _loc_99, (_loc_100 + 1)).mapId;
                        _loc_102.topNeighbourId = WorldPoint.fromCoords(_loc_101, _loc_99, (_loc_100 - 1)).mapId;
                    }
                    return true;
                }
                case param1 is ChangeWorldInteractionAction:
                {
                    _loc_7 = param1 as ChangeWorldInteractionAction;
                    _loc_8 = false;
                    if (Kernel.getWorker().contains(BidHouseManagementFrame) && this._bidHouseManagementFrame.switching)
                    {
                        _loc_8 = true;
                    }
                    this._intercationIsLimited = !_loc_7.enabled;
                    switch(_loc_7.total)
                    {
                        case true:
                        {
                            if (_loc_7.enabled)
                            {
                                if (!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc_8 && SystemApi.wordInterfactionEnable)
                                {
                                    _log.info("Enabling interaction with the roleplay world.");
                                    Kernel.getWorker().addFrame(this._worldFrame);
                                }
                                this._worldFrame.allowOnlyCharacterInteraction = false;
                            }
                            else if (Kernel.getWorker().contains(RoleplayWorldFrame))
                            {
                                _log.info("Disabling interaction with the roleplay world.");
                                Kernel.getWorker().removeFrame(this._worldFrame);
                            }
                            break;
                        }
                        case false:
                        {
                            if (_loc_7.enabled)
                            {
                                if (!Kernel.getWorker().contains(RoleplayWorldFrame) && !_loc_8)
                                {
                                    _log.info("Enabling total interaction with the roleplay world.");
                                    Kernel.getWorker().addFrame(this._worldFrame);
                                    this._worldFrame.allowOnlyCharacterInteraction = false;
                                }
                                if (!Kernel.getWorker().contains(RoleplayInteractivesFrame))
                                {
                                    Kernel.getWorker().addFrame(this._interactivesFrame);
                                }
                            }
                            else if (Kernel.getWorker().contains(RoleplayWorldFrame))
                            {
                                _log.info("Disabling partial interactions with the roleplay world.");
                                this._worldFrame.allowOnlyCharacterInteraction = true;
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    return true;
                }
                case param1 is NpcGenericActionRequestAction:
                {
                    _loc_9 = param1 as NpcGenericActionRequestAction;
                    _loc_10 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                    _loc_11 = new NpcGenericActionRequestMessage();
                    _loc_11.initNpcGenericActionRequestMessage(_loc_9.npcId, _loc_9.actionId, PlayedCharacterManager.getInstance().currentMap.mapId);
                    if ((_loc_10 as IMovable).isMoving)
                    {
                        (_loc_10 as IMovable).stop();
                        this._movementFrame.setFollowingMessage(_loc_11);
                    }
                    else
                    {
                        ConnectionsHandler.getConnection().send(_loc_11);
                    }
                    return true;
                }
                case param1 is ExchangeRequestOnTaxCollectorAction:
                {
                    _loc_12 = param1 as ExchangeRequestOnTaxCollectorAction;
                    _loc_13 = new ExchangeRequestOnTaxCollectorMessage();
                    _loc_13.initExchangeRequestOnTaxCollectorMessage(_loc_12.taxCollectorId);
                    _loc_14 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                    if ((_loc_14 as IMovable).isMoving)
                    {
                        this._movementFrame.setFollowingMessage(_loc_13);
                        (_loc_14 as IMovable).stop();
                    }
                    else
                    {
                        ConnectionsHandler.getConnection().send(_loc_13);
                    }
                    return true;
                }
                case param1 is GameRolePlayTaxCollectorFightRequestAction:
                {
                    _loc_15 = param1 as GameRolePlayTaxCollectorFightRequestAction;
                    _loc_16 = new GameRolePlayTaxCollectorFightRequestMessage();
                    _loc_16.initGameRolePlayTaxCollectorFightRequestMessage(_loc_15.taxCollectorId);
                    ConnectionsHandler.getConnection().send(_loc_16);
                    return true;
                }
                case param1 is InteractiveElementActivationAction:
                {
                    _loc_17 = param1 as InteractiveElementActivationAction;
                    _loc_18 = new InteractiveElementActivationMessage(_loc_17.interactiveElement, _loc_17.position, _loc_17.skillInstanceId);
                    Kernel.getWorker().process(_loc_18);
                    return true;
                }
                case param1 is DisplayContextualMenuAction:
                {
                    _loc_19 = param1 as DisplayContextualMenuAction;
                    _loc_20 = this.entitiesFrame.getEntityInfos(_loc_19.playerId);
                    if (_loc_20)
                    {
                        _loc_103 = RoleplayManager.getInstance().displayCharacterContextualMenu(_loc_20);
                    }
                    return false;
                }
                case param1 is PivotCharacterAction:
                {
                    _loc_21 = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
                    if (_loc_21 && !_loc_21.usingInteractive)
                    {
                        Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
                        this._playerEntity = DofusEntities.getEntity(PlayedCharacterManager.getInstance().infos.id) as AnimatedCharacter;
                        StageShareManager.stage.addEventListener(MouseEvent.MOUSE_MOVE, this.onListenOrientation);
                        StageShareManager.stage.addEventListener(MouseEvent.CLICK, this.onClickOrientation);
                    }
                    return true;
                }
                case param1 is NpcGenericActionFailureMessage:
                {
                    KernelEventsManager.getInstance().processCallback(HookList.NpcDialogCreationFailure);
                    return true;
                }
                case param1 is NpcDialogCreationMessage:
                {
                    _loc_22 = param1 as NpcDialogCreationMessage;
                    _loc_23 = this._entitiesFrame.getEntityInfos(_loc_22.npcId);
                    if (!Kernel.getWorker().contains(NpcDialogFrame))
                    {
                        Kernel.getWorker().addFrame(this._npcDialogFrame);
                    }
                    Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
                    if (_loc_23 is GameRolePlayNpcInformations)
                    {
                        _loc_104 = _loc_23 as GameRolePlayNpcInformations;
                        KernelEventsManager.getInstance().processCallback(HookList.NpcDialogCreation, _loc_22.mapId, _loc_104.npcId, EntityLookAdapter.fromNetwork(_loc_104.look));
                    }
                    else if (_loc_23 is GameRolePlayTaxCollectorInformations)
                    {
                        _loc_105 = _loc_23 as GameRolePlayTaxCollectorInformations;
                        KernelEventsManager.getInstance().processCallback(HookList.PonyDialogCreation, _loc_22.mapId, _loc_105.firstNameId, _loc_105.lastNameId, EntityLookAdapter.fromNetwork(_loc_105.look));
                    }
                    return true;
                }
                case param1 is GameContextDestroyMessage:
                {
                    TooltipManager.hide();
                    Kernel.getWorker().removeFrame(this);
                    return true;
                }
                case param1 is ExchangeStartedBidBuyerMessage:
                {
                    if (!Kernel.getWorker().contains(BidHouseManagementFrame))
                    {
                        KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
                    }
                    this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_BUY);
                    if (!Kernel.getWorker().contains(BidHouseManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
                    }
                    this._bidHouseManagementFrame.processExchangeStartedBidBuyerMessage(param1 as ExchangeStartedBidBuyerMessage);
                    return true;
                }
                case param1 is ExchangeStartedBidSellerMessage:
                {
                    if (!Kernel.getWorker().contains(BidHouseManagementFrame))
                    {
                        KernelEventsManager.getInstance().processCallback(HookList.CloseInventory);
                    }
                    this.addCommonExchangeFrame(ExchangeTypeEnum.BIDHOUSE_SELL);
                    if (!Kernel.getWorker().contains(BidHouseManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._bidHouseManagementFrame);
                    }
                    this._bidHouseManagementFrame.processExchangeStartedBidSellerMessage(param1 as ExchangeStartedBidSellerMessage);
                    return true;
                }
                case param1 is ExchangeShowVendorTaxAction:
                {
                    _loc_24 = new ExchangeShowVendorTaxMessage();
                    _loc_24.initExchangeShowVendorTaxMessage();
                    ConnectionsHandler.getConnection().send(_loc_24);
                    return true;
                }
                case param1 is ExchangeReplyTaxVendorMessage:
                {
                    _loc_25 = param1 as ExchangeReplyTaxVendorMessage;
                    KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeReplyTaxVendor, _loc_25.totalTaxValue);
                    return true;
                }
                case param1 is ExchangeRequestOnShopStockAction:
                {
                    _loc_26 = param1 as ExchangeOnHumanVendorRequestAction;
                    _loc_27 = new ExchangeRequestOnShopStockMessage();
                    _loc_27.initExchangeRequestOnShopStockMessage();
                    ConnectionsHandler.getConnection().send(_loc_27);
                    return true;
                }
                case param1 is ExchangeOnHumanVendorRequestAction:
                {
                    _loc_28 = param1 as ExchangeOnHumanVendorRequestAction;
                    _loc_10 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                    _loc_29 = new ExchangeOnHumanVendorRequestMessage();
                    _loc_29.initExchangeOnHumanVendorRequestMessage(_loc_28.humanVendorId, _loc_28.humanVendorCell);
                    if ((_loc_10 as IMovable).isMoving)
                    {
                        this._movementFrame.setFollowingMessage(_loc_29);
                        (_loc_10 as IMovable).stop();
                    }
                    else
                    {
                        ConnectionsHandler.getConnection().send(_loc_29);
                    }
                    return true;
                }
                case param1 is ExchangeStartOkHumanVendorMessage:
                {
                    _loc_30 = param1 as ExchangeStartOkHumanVendorMessage;
                    if (!Kernel.getWorker().contains(HumanVendorManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
                    }
                    this._humanVendorManagementFrame.process(param1);
                    return true;
                }
                case param1 is ExchangeShopStockStartedMessage:
                {
                    _loc_31 = param1 as ExchangeShopStockStartedMessage;
                    if (!Kernel.getWorker().contains(HumanVendorManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._humanVendorManagementFrame);
                    }
                    this._humanVendorManagementFrame.process(param1);
                    return true;
                }
                case param1 is ExchangeStartAsVendorRequestAction:
                {
                    _loc_32 = EntitiesManager.getInstance().getEntity(PlayedCharacterManager.getInstance().id);
                    if (_loc_32 && !DataMapProvider.getInstance().pointCanStop(_loc_32.position.x, _loc_32.position.y))
                    {
                        return true;
                    }
                    ConnectionsHandler.connectionGonnaBeClosed(DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR);
                    _loc_33 = new ExchangeStartAsVendorMessage();
                    _loc_33.initExchangeStartAsVendorMessage();
                    ConnectionsHandler.getConnection().send(_loc_33);
                    return true;
                }
                case param1 is ExpectedSocketClosureMessage:
                {
                    _loc_34 = param1 as ExpectedSocketClosureMessage;
                    if (_loc_34.reason == DisconnectionReasonEnum.SWITCHING_TO_HUMAN_VENDOR)
                    {
                        Kernel.getWorker().process(new ResetGameAction());
                        return true;
                    }
                    return false;
                }
                case param1 is ExchangeStartedMountStockMessage:
                {
                    _loc_35 = ExchangeStartedMountStockMessage(param1);
                    this.addCommonExchangeFrame(ExchangeTypeEnum.MOUNT);
                    if (!Kernel.getWorker().contains(ExchangeManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                    }
                    PlayedCharacterManager.getInstance().isInExchange = true;
                    KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeBankStarted, ExchangeTypeEnum.MOUNT, _loc_35.objectsInfos, 0);
                    this._exchangeManagementFrame.initMountStock(_loc_35.objectsInfos);
                    return true;
                }
                case param1 is ExchangeRequestedTradeMessage:
                {
                    this.addCommonExchangeFrame(ExchangeTypeEnum.PLAYER_TRADE);
                    if (!Kernel.getWorker().contains(ExchangeManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                        this._exchangeManagementFrame.processExchangeRequestedTradeMessage(param1 as ExchangeRequestedTradeMessage);
                    }
                    return true;
                }
                case param1 is ExchangeStartOkNpcTradeMessage:
                {
                    this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_TRADE);
                    if (!Kernel.getWorker().contains(ExchangeManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                        this._exchangeManagementFrame.processExchangeStartOkNpcTradeMessage(param1 as ExchangeStartOkNpcTradeMessage);
                    }
                    return true;
                }
                case param1 is ExchangeStartOkNpcShopMessage:
                {
                    _loc_36 = param1 as ExchangeStartOkNpcShopMessage;
                    this.addCommonExchangeFrame(ExchangeTypeEnum.NPC_SHOP);
                    if (!Kernel.getWorker().contains(ExchangeManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                    }
                    this._exchangeManagementFrame.process(param1);
                    return true;
                }
                case param1 is ExchangeStartedMessage:
                {
                    _loc_37 = param1 as ExchangeStartedMessage;
                    switch(_loc_37.exchangeType)
                    {
                        case ExchangeTypeEnum.CRAFT:
                        case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                        case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                        {
                            this.addCraftFrame();
                            break;
                        }
                        case ExchangeTypeEnum.BIDHOUSE_BUY:
                        case ExchangeTypeEnum.BIDHOUSE_SELL:
                        case ExchangeTypeEnum.PLAYER_TRADE:
                        {
                        }
                        default:
                        {
                            break;
                            break;
                        }
                    }
                    this.addCommonExchangeFrame(_loc_37.exchangeType);
                    if (!Kernel.getWorker().contains(ExchangeManagementFrame))
                    {
                        Kernel.getWorker().addFrame(this._exchangeManagementFrame);
                    }
                    this._exchangeManagementFrame.process(param1);
                    return true;
                }
                case param1 is ExchangeOkMultiCraftMessage:
                {
                    this.addCraftFrame();
                    this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
                    this._craftFrame.processExchangeOkMultiCraftMessage(param1 as ExchangeOkMultiCraftMessage);
                    return true;
                }
                case param1 is ExchangeStartOkCraftWithInformationMessage:
                {
                    this.addCraftFrame();
                    this.addCommonExchangeFrame(ExchangeTypeEnum.CRAFT);
                    this._craftFrame.processExchangeStartOkCraftWithInformationMessage(param1 as ExchangeStartOkCraftWithInformationMessage);
                    return true;
                }
                case param1 is ObjectFoundWhileRecoltingMessage:
                {
                    _loc_38 = param1 as ObjectFoundWhileRecoltingMessage;
                    _loc_39 = Item.getItemById(_loc_38.genericId);
                    _loc_40 = PlayedCharacterManager.getInstance().id;
                    _loc_41 = new CraftSmileyItem(_loc_40, _loc_39.iconId, 2);
                    if (DofusEntities.getEntity(_loc_40) as IDisplayable)
                    {
                        _loc_106 = (DofusEntities.getEntity(_loc_40) as IDisplayable).absoluteBounds;
                        TooltipManager.show(_loc_41, _loc_106, UiModuleManager.getInstance().getModule("Ankama_Tooltips"), true, "craftSmiley" + _loc_40, LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 0, true, null, null);
                    }
                    _loc_42 = _loc_38.quantity;
                    _loc_43 = _loc_38.genericId ? (Item.getItemById(_loc_38.genericId).name) : (I18n.getUiText("ui.common.kamas"));
                    _loc_44 = Item.getItemById(_loc_38.ressourceGenericId).name;
                    _loc_45 = I18n.getUiText("ui.common.itemFound", [_loc_42, _loc_43, _loc_44]);
                    KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation, _loc_45, ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO, TimeManager.getInstance().getTimestamp());
                    return true;
                }
                case param1 is PlayerFightRequestAction:
                {
                    _loc_46 = PlayerFightRequestAction(param1);
                    if (!_loc_46.launch && !_loc_46.friendly)
                    {
                        _loc_107 = this.entitiesFrame.getEntityInfos(_loc_46.targetedPlayerId) as GameRolePlayCharacterInformations;
                        if (_loc_107)
                        {
                            if (_loc_107.alignmentInfos.alignmentSide == 0)
                            {
                                _loc_110 = Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
                                _loc_111 = _loc_110.entitiesFrame.getEntityInfos(PlayedCharacterManager.getInstance().id) as GameRolePlayActorInformations;
                                if (!(_loc_111 is GameRolePlayMutantInformations))
                                {
                                    KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer, _loc_46.targetedPlayerId, _loc_107.name, 2, _loc_46.cellId);
                                    return true;
                                }
                            }
                            _loc_108 = _loc_107.alignmentInfos.characterPower - _loc_46.targetedPlayerId;
                            _loc_109 = PlayedCharacterManager.getInstance().levelDiff(_loc_108);
                            if (_loc_109)
                            {
                                KernelEventsManager.getInstance().processCallback(SocialHookList.AttackPlayer, _loc_46.targetedPlayerId, _loc_107.name, _loc_109, _loc_46.cellId);
                                return true;
                            }
                        }
                    }
                    _loc_47 = new GameRolePlayPlayerFightRequestMessage();
                    _loc_47.initGameRolePlayPlayerFightRequestMessage(_loc_46.targetedPlayerId, _loc_46.cellId, _loc_46.friendly);
                    _loc_48 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                    if ((_loc_48 as IMovable).isMoving)
                    {
                        this._movementFrame.setFollowingMessage(_loc_46);
                        (_loc_48 as IMovable).stop();
                    }
                    else
                    {
                        ConnectionsHandler.getConnection().send(_loc_47);
                    }
                    return true;
                }
                case param1 is PlayerFightFriendlyAnswerAction:
                {
                    _loc_49 = PlayerFightFriendlyAnswerAction(param1);
                    _loc_50 = new GameRolePlayPlayerFightFriendlyAnswerMessage();
                    _loc_50.initGameRolePlayPlayerFightFriendlyAnswerMessage(this._currentWaitingFightId, _loc_49.accept);
                    _loc_50.accept = _loc_49.accept;
                    _loc_50.fightId = this._currentWaitingFightId;
                    ConnectionsHandler.getConnection().send(_loc_50);
                    return true;
                }
                case param1 is GameRolePlayPlayerFightFriendlyAnsweredMessage:
                {
                    _loc_51 = param1 as GameRolePlayPlayerFightFriendlyAnsweredMessage;
                    KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered, _loc_51.accept);
                    return true;
                }
                case param1 is GameRolePlayFightRequestCanceledMessage:
                {
                    _loc_52 = param1 as GameRolePlayFightRequestCanceledMessage;
                    KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyAnswered, false);
                    return true;
                }
                case param1 is GameRolePlayPlayerFightFriendlyRequestedMessage:
                {
                    _loc_53 = param1 as GameRolePlayPlayerFightFriendlyRequestedMessage;
                    this._currentWaitingFightId = _loc_53.fightId;
                    if (_loc_53.sourceId != PlayedCharacterManager.getInstance().infos.id)
                    {
                        if (this._entitiesFrame.getEntityInfos(_loc_53.sourceId))
                        {
                            KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightFriendlyRequested, GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc_53.sourceId)).name);
                        }
                    }
                    else
                    {
                        _loc_112 = this._entitiesFrame.getEntityInfos(_loc_53.targetId);
                        if (_loc_112)
                        {
                            KernelEventsManager.getInstance().processCallback(RoleplayHookList.PlayerFightRequestSent, GameRolePlayNamedActorInformations(_loc_112).name, true);
                        }
                    }
                    return true;
                }
                case param1 is GameRolePlayFreeSoulRequestAction:
                {
                    _loc_54 = new GameRolePlayFreeSoulRequestMessage();
                    ConnectionsHandler.getConnection().send(_loc_54);
                    return true;
                }
                case param1 is LeaveBidHouseAction:
                {
                    _loc_55 = new LeaveDialogRequestMessage();
                    _loc_55.initLeaveDialogRequestMessage();
                    ConnectionsHandler.getConnection().send(_loc_55);
                    return true;
                }
                case param1 is ExchangeErrorMessage:
                {
                    _loc_56 = param1 as ExchangeErrorMessage;
                    switch(_loc_56.errorType)
                    {
                        case ExchangeErrorEnum.REQUEST_CHARACTER_OCCUPIED:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeCharacterOccupied");
                            break;
                        }
                        case ExchangeErrorEnum.REQUEST_CHARACTER_TOOL_TOO_FAR:
                        {
                            _loc_57 = I18n.getUiText("ui.craft.notNearCraftTable");
                            break;
                        }
                        case ExchangeErrorEnum.REQUEST_IMPOSSIBLE:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchange");
                            break;
                        }
                        case ExchangeErrorEnum.BID_SEARCH_ERROR:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeBIDSearchError");
                            break;
                        }
                        case ExchangeErrorEnum.BUY_ERROR:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeBuyError");
                            break;
                        }
                        case ExchangeErrorEnum.MOUNT_PADDOCK_ERROR:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeMountPaddockError");
                            break;
                        }
                        case ExchangeErrorEnum.REQUEST_CHARACTER_JOB_NOT_EQUIPED:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeCharacterJobNotEquiped");
                            break;
                        }
                        case ExchangeErrorEnum.REQUEST_CHARACTER_NOT_SUSCRIBER:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeCharacterNotSuscriber");
                            break;
                        }
                        case ExchangeErrorEnum.REQUEST_CHARACTER_OVERLOADED:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeCharacterOverloaded");
                            break;
                        }
                        case ExchangeErrorEnum.SELL_ERROR:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchangeSellError");
                            break;
                        }
                        default:
                        {
                            _loc_57 = I18n.getUiText("ui.exchange.cantExchange");
                            break;
                        }
                    }
                    KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation, _loc_57, ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO, TimeManager.getInstance().getTimestamp());
                    KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeError, _loc_56.errorType);
                    return true;
                }
                case param1 is ItemNoMoreAvailableMessage:
                {
                    _loc_58 = param1 as ItemNoMoreAvailableMessage;
                    _loc_59 = I18n.getUiText("ui.item.noItems");
                    KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation, _loc_59, ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO, TimeManager.getInstance().getTimestamp());
                    return true;
                }
                case param1 is GameRolePlayAggressionMessage:
                {
                    _loc_60 = param1 as GameRolePlayAggressionMessage;
                    _loc_45 = I18n.getUiText("ui.pvp.aAttackB", [GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc_60.attackerId)).name, GameRolePlayNamedActorInformations(this._entitiesFrame.getEntityInfos(_loc_60.defenderId)).name]);
                    KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation, _loc_45, ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO, TimeManager.getInstance().getTimestamp());
                    _loc_40 = PlayedCharacterManager.getInstance().infos.id;
                    if (_loc_40 == _loc_60.attackerId)
                    {
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESS);
                    }
                    else if (_loc_40 == _loc_60.defenderId)
                    {
                        SystemManager.getSingleton().notifyUser();
                        SpeakingItemManager.getInstance().triggerEvent(SpeakingItemManager.SPEAK_TRIGGER_AGRESSED);
                    }
                    return true;
                }
                case param1 is LeaveShopStockAction:
                {
                    _loc_61 = new LeaveDialogRequestMessage();
                    _loc_61.initLeaveDialogRequestMessage();
                    ConnectionsHandler.getConnection().send(_loc_61);
                    return true;
                }
                case param1 is ExchangeShopStockMouvmentAddAction:
                {
                    _loc_62 = param1 as ExchangeShopStockMouvmentAddAction;
                    _loc_63 = new ExchangeObjectMovePricedMessage();
                    _loc_63.initExchangeObjectMovePricedMessage(_loc_62.objectUID, _loc_62.quantity, _loc_62.price);
                    ConnectionsHandler.getConnection().send(_loc_63);
                    return true;
                }
                case param1 is ExchangeShopStockMouvmentRemoveAction:
                {
                    _loc_64 = param1 as ExchangeShopStockMouvmentRemoveAction;
                    _loc_65 = new ExchangeObjectMoveMessage();
                    _loc_65.initExchangeObjectMoveMessage(_loc_64.objectUID, _loc_64.quantity);
                    ConnectionsHandler.getConnection().send(_loc_65);
                    return true;
                }
                case param1 is ExchangeBuyAction:
                {
                    _loc_66 = param1 as ExchangeBuyAction;
                    _loc_67 = new ExchangeBuyMessage();
                    _loc_67.initExchangeBuyMessage(_loc_66.objectUID, _loc_66.quantity);
                    ConnectionsHandler.getConnection().send(_loc_67);
                    return true;
                }
                case param1 is ExchangeSellAction:
                {
                    _loc_68 = param1 as ExchangeSellAction;
                    _loc_69 = new ExchangeSellMessage();
                    _loc_69.initExchangeSellMessage(_loc_68.objectUID, _loc_68.quantity);
                    ConnectionsHandler.getConnection().send(_loc_69);
                    return true;
                }
                case param1 is ExchangeBuyOkMessage:
                {
                    _loc_70 = param1 as ExchangeBuyOkMessage;
                    KernelEventsManager.getInstance().processCallback(ExchangeHookList.BuyOk);
                    return true;
                }
                case param1 is ExchangeSellOkMessage:
                {
                    _loc_71 = param1 as ExchangeSellOkMessage;
                    KernelEventsManager.getInstance().processCallback(ExchangeHookList.SellOk);
                    return true;
                }
                case param1 is ExchangePlayerRequestAction:
                {
                    _loc_72 = param1 as ExchangePlayerRequestAction;
                    _loc_73 = new ExchangePlayerRequestMessage();
                    _loc_73.initExchangePlayerRequestMessage(_loc_72.exchangeType, _loc_72.target);
                    ConnectionsHandler.getConnection().send(_loc_73);
                    return true;
                }
                case param1 is ExchangePlayerMultiCraftRequestAction:
                {
                    _loc_74 = param1 as ExchangePlayerMultiCraftRequestAction;
                    switch(_loc_74.exchangeType)
                    {
                        case ExchangeTypeEnum.MULTICRAFT_CRAFTER:
                        {
                            this._customerID = _loc_74.target;
                            this._crafterId = PlayedCharacterManager.getInstance().infos.id;
                            break;
                        }
                        case ExchangeTypeEnum.MULTICRAFT_CUSTOMER:
                        {
                            this._crafterId = _loc_74.target;
                            this._customerID = PlayedCharacterManager.getInstance().infos.id;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    _loc_75 = new ExchangePlayerMultiCraftRequestMessage();
                    _loc_75.initExchangePlayerMultiCraftRequestMessage(_loc_74.exchangeType, _loc_74.target, _loc_74.skillId);
                    ConnectionsHandler.getConnection().send(_loc_75);
                    return true;
                }
                case param1 is JobAllowMultiCraftRequestSetAction:
                {
                    _loc_76 = param1 as JobAllowMultiCraftRequestSetAction;
                    _loc_77 = new JobAllowMultiCraftRequestSetMessage();
                    _loc_77.initJobAllowMultiCraftRequestSetMessage(_loc_76.isPublic);
                    ConnectionsHandler.getConnection().send(_loc_77);
                    return true;
                }
                case param1 is JobAllowMultiCraftRequestMessage:
                {
                    _loc_78 = param1 as JobAllowMultiCraftRequestMessage;
                    _loc_79 = (param1 as JobAllowMultiCraftRequestMessage).getMessageId();
                    switch(_loc_79)
                    {
                        case JobAllowMultiCraftRequestMessage.protocolId:
                        {
                            break;
                        }
                        case JobMultiCraftAvailableSkillsMessage.protocolId:
                        {
                            _loc_113 = param1 as JobMultiCraftAvailableSkillsMessage;
                            if (_loc_113.enabled)
                            {
                                _loc_114 = new MultiCraftEnableForPlayer();
                                _loc_114.playerId = _loc_113.playerId;
                                _loc_114.skills = _loc_113.skills;
                                _loc_115 = false;
                                _loc_116 = 0;
                                _loc_117 = 0;
                                for each (_loc_118 in this._playersMultiCraftSkill)
                                {
                                    
                                    if (_loc_118.playerId == _loc_114.playerId)
                                    {
                                        _loc_115 = true;
                                        _loc_118.skills = _loc_113.skills;
                                    }
                                }
                                if (!_loc_115)
                                {
                                    this._playersMultiCraftSkill.push(_loc_114);
                                }
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    PlayedCharacterManager.getInstance().publicMode = _loc_78.enabled;
                    KernelEventsManager.getInstance().processCallback(CraftHookList.JobAllowMultiCraftRequest, _loc_78.enabled);
                    return true;
                }
                case param1 is SpellForgetUIMessage:
                {
                    _loc_80 = param1 as SpellForgetUIMessage;
                    Kernel.getWorker().addFrame(this._spellForgetDialogFrame);
                    KernelEventsManager.getInstance().processCallback(RoleplayHookList.SpellForgetUI, _loc_80.open);
                    return true;
                }
                case param1 is ChallengeFightJoinRefusedMessage:
                {
                    _loc_81 = param1 as ChallengeFightJoinRefusedMessage;
                    switch(_loc_81.reason)
                    {
                        case FighterRefusedReasonEnum.CHALLENGE_FULL:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.challengeFull");
                            break;
                        }
                        case FighterRefusedReasonEnum.TEAM_FULL:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.teamFull");
                            break;
                        }
                        case FighterRefusedReasonEnum.WRONG_ALIGNMENT:
                        {
                            _loc_45 = I18n.getUiText("ui.wrongAlignment");
                            break;
                        }
                        case FighterRefusedReasonEnum.WRONG_GUILD:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.wrongGuild");
                            break;
                        }
                        case FighterRefusedReasonEnum.TOO_LATE:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.tooLate");
                            break;
                        }
                        case FighterRefusedReasonEnum.MUTANT_REFUSED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.mutantRefused");
                            break;
                        }
                        case FighterRefusedReasonEnum.WRONG_MAP:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.wrongMap");
                            break;
                        }
                        case FighterRefusedReasonEnum.JUST_RESPAWNED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.justRespawned");
                            break;
                        }
                        case FighterRefusedReasonEnum.IM_OCCUPIED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.imOccupied");
                            break;
                        }
                        case FighterRefusedReasonEnum.OPPONENT_OCCUPIED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.opponentOccupied");
                            break;
                        }
                        case FighterRefusedReasonEnum.MULTIACCOUNT_NOT_ALLOWED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.onlyOneAllowedAccount");
                            break;
                        }
                        case FighterRefusedReasonEnum.INSUFFICIENT_RIGHTS:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.insufficientRights");
                            break;
                        }
                        case FighterRefusedReasonEnum.MEMBER_ACCOUNT_NEEDED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.memberAccountNeeded");
                            break;
                        }
                        case FighterRefusedReasonEnum.OPPONENT_NOT_MEMBER:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.opponentNotMember");
                            break;
                        }
                        case FighterRefusedReasonEnum.TEAM_LIMITED_BY_MAINCHARACTER:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.teamLimitedByMainCharacter");
                            break;
                        }
                        case FighterRefusedReasonEnum.GHOST_REFUSED:
                        {
                            _loc_45 = I18n.getUiText("ui.fight.ghostRefused");
                            break;
                        }
                        default:
                        {
                            return true;
                            break;
                        }
                    }
                    if (_loc_45 != null)
                    {
                        KernelEventsManager.getInstance().processCallback(ChatHookList.TextInformation, _loc_45, ChatActivableChannelsEnum.PSEUDO_CHANNEL_INFO, TimeManager.getInstance().getTimestamp());
                    }
                    return true;
                }
                case param1 is SpellForgottenMessage:
                {
                    _loc_82 = param1 as SpellForgottenMessage;
                    return true;
                }
                case param1 is ExchangeCraftResultMessage:
                {
                    _loc_83 = param1 as ExchangeCraftResultMessage;
                    _loc_84 = _loc_83.getMessageId();
                    if (_loc_84 != ExchangeCraftInformationObjectMessage.protocolId)
                    {
                        return false;
                    }
                    _loc_85 = param1 as ExchangeCraftInformationObjectMessage;
                    switch(_loc_85.craftResult)
                    {
                        case CraftResultEnum.CRAFT_SUCCESS:
                        case CraftResultEnum.CRAFT_FAILED:
                        {
                            _loc_119 = Item.getItemById(_loc_85.objectGenericId);
                            _loc_120 = _loc_119.iconId;
                            _loc_86 = new CraftSmileyItem(_loc_85.playerId, _loc_120, _loc_85.craftResult);
                            break;
                        }
                        case CraftResultEnum.CRAFT_IMPOSSIBLE:
                        {
                            _loc_86 = new CraftSmileyItem(_loc_85.playerId, -1, _loc_85.craftResult);
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    if (DofusEntities.getEntity(_loc_85.playerId) as IDisplayable)
                    {
                        _loc_121 = (DofusEntities.getEntity(_loc_85.playerId) as IDisplayable).absoluteBounds;
                        TooltipManager.show(_loc_86, _loc_121, UiModuleManager.getInstance().getModule("Ankama_Tooltips"), true, "craftSmiley" + _loc_85.playerId, LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 0, true, null, null, null, null, false, -1);
                    }
                    return true;
                }
                case param1 is DocumentReadingBeginMessage:
                {
                    _loc_87 = param1 as DocumentReadingBeginMessage;
                    TooltipManager.hideAll();
                    if (!Kernel.getWorker().contains(DocumentFrame))
                    {
                        Kernel.getWorker().addFrame(this._documentFrame);
                    }
                    KernelEventsManager.getInstance().processCallback(RoleplayHookList.DocumentReadingBegin, _loc_87.documentId);
                    return true;
                }
                case param1 is ZaapListMessage || param1 is TeleportDestinationsListMessage:
                {
                    if (!Kernel.getWorker().contains(ZaapFrame))
                    {
                        Kernel.getWorker().addFrame(this._zaapFrame);
                        Kernel.getWorker().process(param1);
                    }
                    return false;
                }
                case param1 is PaddockSellBuyDialogMessage:
                {
                    _loc_88 = param1 as PaddockSellBuyDialogMessage;
                    TooltipManager.hideAll();
                    if (!Kernel.getWorker().contains(PaddockFrame))
                    {
                        Kernel.getWorker().addFrame(this._paddockFrame);
                    }
                    Kernel.getWorker().process(ChangeWorldInteractionAction.create(false));
                    KernelEventsManager.getInstance().processCallback(MountHookList.PaddockSellBuyDialog, _loc_88.bsell, _loc_88.ownerId, _loc_88.price);
                    return true;
                }
                case param1 is LeaveExchangeMountAction:
                {
                    _loc_89 = new LeaveDialogRequestMessage();
                    _loc_89.initLeaveDialogRequestMessage();
                    ConnectionsHandler.getConnection().send(_loc_89);
                    return true;
                }
                case param1 is PaddockPropertiesMessage:
                {
                    this._currentPaddock = PaddockWrapper.create(PaddockPropertiesMessage(param1).properties);
                    return true;
                }
                case param1 is GameRolePlaySpellAnimMessage:
                {
                    _loc_90 = param1 as GameRolePlaySpellAnimMessage;
                    _loc_91 = new RoleplaySpellCastProvider();
                    _loc_91.castingSpell.casterId = _loc_90.casterId;
                    _loc_91.castingSpell.spell = Spell.getSpellById(_loc_90.spellId);
                    _loc_91.castingSpell.spellRank = _loc_91.castingSpell.spell.getSpellLevel(_loc_90.spellLevel);
                    _loc_91.castingSpell.targetedCell = MapPoint.fromCellId(_loc_90.targetCellId);
                    _loc_92 = new Uri(XmlConfig.getInstance().getEntry("config.script.spellFx") + _loc_91.castingSpell.spell.getScriptId(_loc_91.castingSpell.isCriticalHit) + ".dx");
                    _log.debug("GameRolePlaySpellAnimMessage de " + _loc_91.castingSpell.casterId + " sur " + _loc_91.castingSpell.targetedCell.cellId + "     uri : " + XmlConfig.getInstance().getEntry("config.script.spellFx") + _loc_91.castingSpell.spell.getScriptId(_loc_91.castingSpell.isCriticalHit) + ".dx");
                    _loc_93 = new SpellFxRunner(_loc_91);
                    ScriptExec.exec(_loc_92, _loc_93, false, new Callback(this.executeSpellBuffer, null, true, true, _loc_91), new Callback(this.executeSpellBuffer, null, true, false, _loc_91));
                    return true;
                }
                case param1 is CinematicMessage:
                {
                    _loc_94 = param1 as CinematicMessage;
                    KernelEventsManager.getInstance().processCallback(HookList.Cinematic, _loc_94.cinematicId);
                    return true;
                }
                case param1 is BasicSwitchModeAction:
                {
                    _loc_95 = param1 as BasicSwitchModeAction;
                    if (_loc_95.type != currentStatus)
                    {
                        _loc_122 = new BasicSetAwayModeRequestMessage();
                        switch(_loc_95.type)
                        {
                            case -1:
                            {
                                _loc_122.initBasicSetAwayModeRequestMessage(false, currentStatus == 0);
                                break;
                            }
                            case 0:
                            {
                                _loc_122.initBasicSetAwayModeRequestMessage(true, true);
                                break;
                            }
                            case 1:
                            {
                                _loc_122.initBasicSetAwayModeRequestMessage(true, false);
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        currentStatus = _loc_95.type;
                        ConnectionsHandler.getConnection().send(_loc_122);
                    }
                    return true;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        public function pulled() : Boolean
        {
            var _loc_1:* = Kernel.getWorker().getFrame(PrismFrame) as PrismFrame;
            _loc_1.pullRoleplay();
            this._interactivesFrame.clear();
            Kernel.getWorker().removeFrame(this._entitiesFrame);
            Kernel.getWorker().removeFrame(this._worldFrame);
            Kernel.getWorker().removeFrame(this._movementFrame);
            Kernel.getWorker().removeFrame(this._interactivesFrame);
            Kernel.getWorker().removeFrame(this._spectatorManagementFrame);
            Kernel.getWorker().removeFrame(this._npcDialogFrame);
            Kernel.getWorker().removeFrame(this._documentFrame);
            Kernel.getWorker().removeFrame(this._zaapFrame);
            Kernel.getWorker().removeFrame(this._paddockFrame);
            return true;
        }// end function

        public function getActorName(param1:int) : String
        {
            var _loc_2:GameRolePlayActorInformations = null;
            var _loc_3:GameRolePlayTaxCollectorInformations = null;
            _loc_2 = this.getActorInfos(param1);
            if (!_loc_2)
            {
                return "Unknown Actor";
            }
            switch(true)
            {
                case _loc_2 is GameRolePlayNamedActorInformations:
                {
                    return (_loc_2 as GameRolePlayNamedActorInformations).name;
                }
                case _loc_2 is GameRolePlayTaxCollectorInformations:
                {
                    _loc_3 = _loc_2 as GameRolePlayTaxCollectorInformations;
                    return TaxCollectorFirstname.getTaxCollectorFirstnameById(_loc_3.firstNameId).firstname + " " + TaxCollectorName.getTaxCollectorNameById(_loc_3.lastNameId).name;
                }
                case _loc_2 is GameRolePlayNpcInformations:
                {
                    return Npc.getNpcById((_loc_2 as GameRolePlayNpcInformations).npcId).name;
                }
                case _loc_2 is GameRolePlayGroupMonsterInformations:
                case _loc_2 is GameRolePlayPrismInformations:
                {
                    _log.error("Fail: getActorName called with an actorId corresponding to a monsters group or a prism (" + _loc_2 + ").");
                    return "<error: cannot get a name>";
                }
                default:
                {
                    break;
                }
            }
            return "Unknown Actor Type";
        }// end function

        private function getActorInfos(param1:int) : GameRolePlayActorInformations
        {
            return this.entitiesFrame.getEntityInfos(param1) as GameRolePlayActorInformations;
        }// end function

        private function executeSpellBuffer(param1:Function, param2:Boolean, param3:Boolean = false, param4:RoleplaySpellCastProvider = null) : void
        {
            var _loc_6:ISequencable = null;
            var _loc_5:* = new SerialSequencer();
            for each (_loc_6 in param4.stepsBuffer)
            {
                
                _loc_5.addStep(_loc_6);
            }
            _loc_5.start();
            return;
        }// end function

        private function addCraftFrame() : void
        {
            if (!Kernel.getWorker().contains(CraftFrame))
            {
                Kernel.getWorker().addFrame(this._craftFrame);
            }
            return;
        }// end function

        private function addCommonExchangeFrame(param1:uint) : void
        {
            if (!Kernel.getWorker().contains(CommonExchangeManagementFrame))
            {
                this._commonExchangeFrame = new CommonExchangeManagementFrame(param1);
                Kernel.getWorker().addFrame(this._commonExchangeFrame);
            }
            return;
        }// end function

        private function onListenOrientation(event:MouseEvent) : void
        {
            var _loc_2:* = this._playerEntity.localToGlobal(new Point(0, 0));
            var _loc_3:* = StageShareManager.stage.mouseY - _loc_2.y;
            var _loc_4:* = StageShareManager.stage.mouseX - _loc_2.x;
            var _loc_5:* = AngleToOrientation.angleToOrientation(Math.atan2(_loc_3, _loc_4));
            var _loc_6:* = this._playerEntity.getAnimation();
            var _loc_7:* = Emoticon.getEmoticonById(this._entitiesFrame.currentEmoticon);
            if (_loc_6.indexOf(AnimationEnum.ANIM_STATIQUE) != -1 || _loc_7 && _loc_7.eight_directions)
            {
                this._playerEntity.setDirection(_loc_5);
            }
            else if (_loc_5 % 2 == 0)
            {
                this._playerEntity.setDirection((_loc_5 + 1));
            }
            else
            {
                this._playerEntity.setDirection(_loc_5);
            }
            return;
        }// end function

        private function onClickOrientation(event:MouseEvent) : void
        {
            Kernel.getWorker().process(ChangeWorldInteractionAction.create(true));
            StageShareManager.stage.removeEventListener(MouseEvent.MOUSE_MOVE, this.onListenOrientation);
            StageShareManager.stage.removeEventListener(MouseEvent.CLICK, this.onClickOrientation);
            var _loc_2:* = this._playerEntity.getAnimation();
            var _loc_3:* = new GameMapChangeOrientationRequestMessage();
            _loc_3.initGameMapChangeOrientationRequestMessage(this._playerEntity.getDirection());
            ConnectionsHandler.getConnection().send(_loc_3);
            return;
        }// end function

        public function getMultiCraftSkills(param1:uint) : Vector.<uint>
        {
            var _loc_2:MultiCraftEnableForPlayer = null;
            for each (_loc_2 in this._playersMultiCraftSkill)
            {
                
                if (_loc_2.playerId == param1)
                {
                    return _loc_2.skills;
                }
            }
            return null;
        }// end function

    }
}

class MultiCraftEnableForPlayer extends Object
{
    public var playerId:uint;
    public var skills:Vector.<uint>;

    function MultiCraftEnableForPlayer()
    {
        return;
    }// end function

}

