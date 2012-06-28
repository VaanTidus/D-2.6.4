﻿package com.ankamagames.dofus.logic.game.common.frames
{
    import __AS3__.vec.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.dofus.datacenter.items.criterion.*;
    import com.ankamagames.dofus.datacenter.npcs.*;
    import com.ankamagames.dofus.internalDatacenter.items.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.kernel.net.*;
    import com.ankamagames.dofus.logic.common.actions.*;
    import com.ankamagames.dofus.logic.game.common.actions.*;
    import com.ankamagames.dofus.logic.game.common.actions.exchange.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.roleplay.actions.*;
    import com.ankamagames.dofus.logic.game.roleplay.frames.*;
    import com.ankamagames.dofus.misc.*;
    import com.ankamagames.dofus.misc.lists.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.messages.game.dialog.*;
    import com.ankamagames.dofus.network.messages.game.inventory.exchanges.*;
    import com.ankamagames.dofus.network.messages.game.inventory.storage.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.*;
    import com.ankamagames.dofus.network.types.game.data.items.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.network.*;
    import com.ankamagames.tiphon.types.look.*;
    import flash.utils.*;

    public class ExchangeManagementFrame extends Object implements Frame
    {
        private var _priority:int = 0;
        private var _sourceInformations:GameRolePlayNamedActorInformations;
        private var _targetInformations:GameRolePlayNamedActorInformations;
        private var _meReady:Boolean = false;
        private var _youReady:Boolean = false;
        private var _exchangeInventory:Array;
        private var _success:Boolean;
        static const _log:Logger = Log.getLogger(getQualifiedClassName(ExchangeManagementFrame));

        public function ExchangeManagementFrame()
        {
            return;
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

        private function get roleplayContextFrame() : RoleplayContextFrame
        {
            return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
        }// end function

        private function get roleplayEntitiesFrame() : RoleplayEntitiesFrame
        {
            return Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
        }// end function

        private function get roleplayMovementFrame() : RoleplayMovementFrame
        {
            return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
        }// end function

        public function initMountStock(param1:Vector.<ObjectItem>) : void
        {
            InventoryManager.getInstance().bankInventory.initializeFromObjectItems(param1);
            InventoryManager.getInstance().bankInventory.releaseHooks();
            return;
        }// end function

        public function processExchangeRequestedTradeMessage(param1:ExchangeRequestedTradeMessage) : void
        {
            var _loc_4:SocialFrame = null;
            var _loc_5:LeaveDialogAction = null;
            if (param1.exchangeType != ExchangeTypeEnum.PLAYER_TRADE)
            {
                return;
            }
            this._sourceInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.source) as GameRolePlayNamedActorInformations;
            this._targetInformations = this.roleplayEntitiesFrame.getEntityInfos(param1.target) as GameRolePlayNamedActorInformations;
            var _loc_2:* = this._sourceInformations.name;
            var _loc_3:* = this._targetInformations.name;
            if (param1.source == PlayedCharacterManager.getInstance().id)
            {
                this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterFromMe, _loc_2, _loc_3);
            }
            else
            {
                _loc_4 = Kernel.getWorker().getFrame(SocialFrame) as SocialFrame;
                if (_loc_4 && _loc_4.isIgnored(_loc_2))
                {
                    _loc_5 = new LeaveDialogAction();
                    Kernel.getWorker().process(_loc_5);
                    return;
                }
                this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeRequestCharacterToMe, _loc_3, _loc_2);
            }
            return;
        }// end function

        public function processExchangeStartOkNpcTradeMessage(param1:ExchangeStartOkNpcTradeMessage) : void
        {
            var _loc_2:* = PlayedCharacterManager.getInstance().infos.name;
            var _loc_3:* = this.roleplayEntitiesFrame.getEntityInfos(param1.npcId).contextualId;
            var _loc_4:* = Npc.getNpcById(_loc_3);
            var _loc_5:* = Npc.getNpcById((this.roleplayEntitiesFrame.getEntityInfos(param1.npcId) as GameRolePlayNpcInformations).npcId).name;
            var _loc_6:* = EntityLookAdapter.getRiderLook(PlayedCharacterManager.getInstance().infos.entityLook);
            var _loc_7:* = EntityLookAdapter.getRiderLook(this.roleplayContextFrame.entitiesFrame.getEntityInfos(param1.npcId).look);
            var _loc_8:* = param1 as ExchangeStartOkNpcTradeMessage;
            PlayedCharacterManager.getInstance().isInExchange = true;
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcTrade, _loc_8.npcId, _loc_2, _loc_5, _loc_6, _loc_7);
            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType, ExchangeTypeEnum.NPC_TRADE);
            return;
        }// end function

        public function process(param1:Message) : Boolean
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:ExchangeStartedWithStorageMessage = null;
            var _loc_5:int = 0;
            var _loc_6:ExchangeStartedMessage = null;
            var _loc_7:StorageInventoryContentMessage = null;
            var _loc_8:ExchangeStartOkTaxCollectorMessage = null;
            var _loc_9:StorageObjectUpdateMessage = null;
            var _loc_10:ObjectItem = null;
            var _loc_11:ItemWrapper = null;
            var _loc_12:StorageObjectRemoveMessage = null;
            var _loc_13:StorageObjectsUpdateMessage = null;
            var _loc_14:StorageObjectsRemoveMessage = null;
            var _loc_15:StorageKamasUpdateMessage = null;
            var _loc_16:ExchangeObjectMoveKamaAction = null;
            var _loc_17:ExchangeObjectMoveKamaMessage = null;
            var _loc_18:ExchangeObjectTransfertAllToInvAction = null;
            var _loc_19:ExchangeObjectTransfertAllToInvMessage = null;
            var _loc_20:ExchangeObjectTransfertListToInvAction = null;
            var _loc_21:ExchangeObjectTransfertExistingToInvAction = null;
            var _loc_22:ExchangeObjectTransfertExistingToInvMessage = null;
            var _loc_23:ExchangeObjectTransfertAllFromInvAction = null;
            var _loc_24:ExchangeObjectTransfertAllFromInvMessage = null;
            var _loc_25:ExchangeObjectTransfertListFromInvAction = null;
            var _loc_26:ExchangeObjectTransfertExistingFromInvAction = null;
            var _loc_27:ExchangeObjectTransfertExistingFromInvMessage = null;
            var _loc_28:ExchangeStartOkNpcShopMessage = null;
            var _loc_29:GameContextActorInformations = null;
            var _loc_30:TiphonEntityLook = null;
            var _loc_31:Array = null;
            var _loc_32:String = null;
            var _loc_33:String = null;
            var _loc_34:TiphonEntityLook = null;
            var _loc_35:TiphonEntityLook = null;
            var _loc_36:ExchangeStartedWithPodsMessage = null;
            var _loc_37:int = 0;
            var _loc_38:int = 0;
            var _loc_39:int = 0;
            var _loc_40:int = 0;
            var _loc_41:int = 0;
            var _loc_42:ObjectItem = null;
            var _loc_43:ObjectItem = null;
            var _loc_44:ItemWrapper = null;
            var _loc_45:uint = 0;
            var _loc_46:ExchangeObjectTransfertListToInvMessage = null;
            var _loc_47:ExchangeObjectTransfertListFromInvMessage = null;
            var _loc_48:ObjectItemToSellInNpcShop = null;
            var _loc_49:ItemWrapper = null;
            switch(true)
            {
                case param1 is ExchangeStartedWithStorageMessage:
                {
                    _loc_4 = param1 as ExchangeStartedWithStorageMessage;
                    PlayedCharacterManager.getInstance().isInExchange = true;
                    _loc_5 = _loc_4.storageMaxSlot;
                    this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeBankStartedWithStorage, ExchangeTypeEnum.STORAGE, _loc_5);
                    return true;
                }
                case param1 is ExchangeStartedMessage:
                {
                    _loc_6 = param1 as ExchangeStartedMessage;
                    PlayedCharacterManager.getInstance().isInExchange = true;
                    switch(_loc_6.exchangeType)
                    {
                        case ExchangeTypeEnum.PLAYER_TRADE:
                        {
                            _loc_32 = this._sourceInformations.name;
                            _loc_33 = this._targetInformations.name;
                            _loc_34 = EntityLookAdapter.getRiderLook(this._sourceInformations.look);
                            _loc_35 = EntityLookAdapter.getRiderLook(this._targetInformations.look);
                            if (_loc_6.getMessageId() == ExchangeStartedWithPodsMessage.protocolId)
                            {
                                _loc_36 = param1 as ExchangeStartedWithPodsMessage;
                            }
                            _loc_37 = -1;
                            _loc_38 = -1;
                            _loc_39 = -1;
                            _loc_40 = -1;
                            if (_loc_36 != null)
                            {
                                if (_loc_36.firstCharacterId == this._sourceInformations.contextualId)
                                {
                                    _loc_37 = _loc_36.firstCharacterCurrentWeight;
                                    _loc_38 = _loc_36.secondCharacterCurrentWeight;
                                    _loc_39 = _loc_36.firstCharacterMaxWeight;
                                    _loc_40 = _loc_36.secondCharacterMaxWeight;
                                }
                                else
                                {
                                    _loc_38 = _loc_36.firstCharacterCurrentWeight;
                                    _loc_37 = _loc_36.secondCharacterCurrentWeight;
                                    _loc_40 = _loc_36.firstCharacterMaxWeight;
                                    _loc_39 = _loc_36.secondCharacterMaxWeight;
                                }
                            }
                            if (PlayedCharacterManager.getInstance().id == _loc_36.firstCharacterId)
                            {
                                _loc_41 = _loc_36.secondCharacterId;
                            }
                            else
                            {
                                _loc_41 = _loc_36.firstCharacterId;
                            }
                            _log.debug("look : " + _loc_34.toString() + "    " + _loc_35.toString());
                            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStarted, _loc_32, _loc_33, _loc_34, _loc_35, _loc_37, _loc_38, _loc_39, _loc_40, _loc_41);
                            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType, _loc_6.exchangeType);
                            return true;
                        }
                        case ExchangeTypeEnum.STORAGE:
                        {
                            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType, _loc_6.exchangeType);
                            return true;
                        }
                        case ExchangeTypeEnum.TAXCOLLECTOR:
                        {
                            this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartedType, _loc_6.exchangeType);
                            return true;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    return false;
                }
                case param1 is StorageInventoryContentMessage:
                {
                    _loc_7 = param1 as StorageInventoryContentMessage;
                    InventoryManager.getInstance().bankInventory.kamas = _loc_7.kamas;
                    InventoryManager.getInstance().bankInventory.initializeFromObjectItems(_loc_7.objects);
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is ExchangeStartOkTaxCollectorMessage:
                {
                    _loc_8 = param1 as ExchangeStartOkTaxCollectorMessage;
                    InventoryManager.getInstance().bankInventory.kamas = _loc_8.goldInfo;
                    InventoryManager.getInstance().bankInventory.initializeFromObjectItems(_loc_8.objectsInfos);
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is StorageObjectUpdateMessage:
                {
                    _loc_9 = param1 as StorageObjectUpdateMessage;
                    _loc_10 = _loc_9.object;
                    _loc_11 = ItemWrapper.create(_loc_10.position, _loc_10.objectUID, _loc_10.objectGID, _loc_10.quantity, _loc_10.effects);
                    InventoryManager.getInstance().bankInventory.modifyItem(_loc_11);
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is StorageObjectRemoveMessage:
                {
                    _loc_12 = param1 as StorageObjectRemoveMessage;
                    InventoryManager.getInstance().bankInventory.removeItem(_loc_12.objectUID);
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is StorageObjectsUpdateMessage:
                {
                    _loc_13 = param1 as StorageObjectsUpdateMessage;
                    for each (_loc_42 in _loc_13.objectList)
                    {
                        
                        _loc_43 = _loc_42;
                        _loc_44 = ItemWrapper.create(_loc_43.position, _loc_43.objectUID, _loc_43.objectGID, _loc_43.quantity, _loc_43.effects);
                        InventoryManager.getInstance().bankInventory.modifyItem(_loc_44);
                    }
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is StorageObjectsRemoveMessage:
                {
                    _loc_14 = param1 as StorageObjectsRemoveMessage;
                    for each (_loc_45 in _loc_14.objectUIDList)
                    {
                        
                        InventoryManager.getInstance().bankInventory.removeItem(_loc_45);
                    }
                    InventoryManager.getInstance().bankInventory.releaseHooks();
                    return false;
                }
                case param1 is StorageKamasUpdateMessage:
                {
                    _loc_15 = param1 as StorageKamasUpdateMessage;
                    InventoryManager.getInstance().bankInventory.kamas = _loc_15.kamasTotal;
                    KernelEventsManager.getInstance().processCallback(InventoryHookList.StorageKamasUpdate, _loc_15.kamasTotal);
                    return false;
                }
                case param1 is ExchangeObjectMoveKamaAction:
                {
                    _loc_16 = param1 as ExchangeObjectMoveKamaAction;
                    _loc_17 = new ExchangeObjectMoveKamaMessage();
                    _loc_17.initExchangeObjectMoveKamaMessage(_loc_16.kamas);
                    this._serverConnection.send(_loc_17);
                    return true;
                }
                case param1 is ExchangeObjectTransfertAllToInvAction:
                {
                    _loc_18 = param1 as ExchangeObjectTransfertAllToInvAction;
                    _loc_19 = new ExchangeObjectTransfertAllToInvMessage();
                    _loc_19.initExchangeObjectTransfertAllToInvMessage();
                    this._serverConnection.send(_loc_19);
                    return true;
                }
                case param1 is ExchangeObjectTransfertListToInvAction:
                {
                    _loc_20 = param1 as ExchangeObjectTransfertListToInvAction;
                    if (_loc_20.ids.length != 0)
                    {
                        _loc_46 = new ExchangeObjectTransfertListToInvMessage();
                        _loc_46.initExchangeObjectTransfertListToInvMessage(_loc_20.ids);
                        this._serverConnection.send(_loc_46);
                    }
                    return true;
                }
                case param1 is ExchangeObjectTransfertExistingToInvAction:
                {
                    _loc_21 = param1 as ExchangeObjectTransfertExistingToInvAction;
                    _loc_22 = new ExchangeObjectTransfertExistingToInvMessage();
                    _loc_22.initExchangeObjectTransfertExistingToInvMessage();
                    this._serverConnection.send(_loc_22);
                    return true;
                }
                case param1 is ExchangeObjectTransfertAllFromInvAction:
                {
                    _loc_23 = param1 as ExchangeObjectTransfertAllFromInvAction;
                    _loc_24 = new ExchangeObjectTransfertAllFromInvMessage();
                    _loc_24.initExchangeObjectTransfertAllFromInvMessage();
                    this._serverConnection.send(_loc_24);
                    return true;
                }
                case param1 is ExchangeObjectTransfertListFromInvAction:
                {
                    _loc_25 = param1 as ExchangeObjectTransfertListFromInvAction;
                    if (_loc_25.ids.length != 0)
                    {
                        _loc_47 = new ExchangeObjectTransfertListFromInvMessage();
                        _loc_47.initExchangeObjectTransfertListFromInvMessage(_loc_25.ids.slice(0, 1000));
                        this._serverConnection.send(_loc_47);
                    }
                    return true;
                }
                case param1 is ExchangeObjectTransfertExistingFromInvAction:
                {
                    _loc_26 = param1 as ExchangeObjectTransfertExistingFromInvAction;
                    _loc_27 = new ExchangeObjectTransfertExistingFromInvMessage();
                    _loc_27.initExchangeObjectTransfertExistingFromInvMessage();
                    this._serverConnection.send(_loc_27);
                    return true;
                }
                case param1 is ExchangeStartOkNpcShopMessage:
                {
                    _loc_28 = param1 as ExchangeStartOkNpcShopMessage;
                    PlayedCharacterManager.getInstance().isInExchange = true;
                    Kernel.getWorker().process(ChangeWorldInteractionAction.create(false, true));
                    _loc_29 = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc_28.npcSellerId);
                    _loc_30 = EntityLookAdapter.fromNetwork(_loc_29.look);
                    _loc_31 = new Array();
                    for each (_loc_48 in _loc_28.objectsInfos)
                    {
                        
                        _loc_49 = ItemWrapper.create(63, 0, _loc_48.objectGID, 0, _loc_48.effects, false);
                        _loc_31.push({item:_loc_49, price:_loc_48.objectPrice, criterion:new GroupItemCriterion(_loc_48.buyCriterion)});
                    }
                    this._kernelEventsManager.processCallback(ExchangeHookList.ExchangeStartOkNpcShop, _loc_28.npcSellerId, _loc_31, _loc_30, _loc_28.tokenId);
                    return true;
                }
                case param1 is LeaveDialogRequestAction:
                {
                    ConnectionsHandler.getConnection().send(new LeaveDialogRequestMessage());
                    return true;
                }
                case param1 is ExchangeLeaveMessage:
                {
                    PlayedCharacterManager.getInstance().isInExchange = false;
                    this._success = ExchangeLeaveMessage(param1).success;
                    Kernel.getWorker().removeFrame(this);
                    return true;
                }
                default:
                {
                    break;
                }
            }
            return false;
        }// end function

        private function proceedExchange() : void
        {
            return;
        }// end function

        public function pushed() : Boolean
        {
            this._success = false;
            return true;
        }// end function

        public function pulled() : Boolean
        {
            if (Kernel.getWorker().contains(CommonExchangeManagementFrame))
            {
                Kernel.getWorker().removeFrame(Kernel.getWorker().getFrame(CommonExchangeManagementFrame));
            }
            KernelEventsManager.getInstance().processCallback(ExchangeHookList.ExchangeLeave, this._success);
            this._exchangeInventory = null;
            return true;
        }// end function

        private function get _kernelEventsManager() : KernelEventsManager
        {
            return KernelEventsManager.getInstance();
        }// end function

        private function get _serverConnection() : IServerConnection
        {
            return ConnectionsHandler.getConnection();
        }// end function

    }
}
