package com.ankamagames.dofus.logic.game.roleplay.frames
{
    import com.ankamagames.atouin.*;
    import com.ankamagames.atouin.managers.*;
    import com.ankamagames.atouin.messages.*;
    import com.ankamagames.atouin.types.*;
    import com.ankamagames.atouin.utils.*;
    import com.ankamagames.berilia.components.*;
    import com.ankamagames.berilia.factories.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.berilia.types.*;
    import com.ankamagames.berilia.types.data.*;
    import com.ankamagames.dofus.datacenter.interactives.*;
    import com.ankamagames.dofus.datacenter.jobs.*;
    import com.ankamagames.dofus.datacenter.npcs.*;
    import com.ankamagames.dofus.internalDatacenter.guild.*;
    import com.ankamagames.dofus.internalDatacenter.house.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.kernel.net.*;
    import com.ankamagames.dofus.logic.game.common.actions.guild.*;
    import com.ankamagames.dofus.logic.game.common.frames.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.common.misc.*;
    import com.ankamagames.dofus.logic.game.fight.actions.*;
    import com.ankamagames.dofus.logic.game.roleplay.managers.*;
    import com.ankamagames.dofus.logic.game.roleplay.messages.*;
    import com.ankamagames.dofus.logic.game.roleplay.types.*;
    import com.ankamagames.dofus.misc.lists.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.messages.game.context.fight.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.houses.*;
    import com.ankamagames.dofus.network.messages.game.context.roleplay.party.*;
    import com.ankamagames.dofus.network.messages.game.inventory.exchanges.*;
    import com.ankamagames.dofus.network.types.game.context.*;
    import com.ankamagames.dofus.network.types.game.context.fight.*;
    import com.ankamagames.dofus.network.types.game.context.roleplay.*;
    import com.ankamagames.dofus.network.types.game.interactive.*;
    import com.ankamagames.dofus.types.entities.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.entities.interfaces.*;
    import com.ankamagames.jerakine.entities.messages.*;
    import com.ankamagames.jerakine.handlers.messages.mouse.*;
    import com.ankamagames.jerakine.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.enums.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.jerakine.utils.display.*;
    import com.ankamagames.tiphon.display.*;
    import flash.display.*;
    import flash.geom.*;
    import flash.ui.*;
    import flash.utils.*;

    public class RoleplayWorldFrame extends Object implements Frame
    {
        private const _common:String;
        private var _mouseTop:Texture;
        private var _mouseBottom:Texture;
        private var _mouseRight:Texture;
        private var _mouseLeft:Texture;
        private var _texturesReady:Boolean;
        private var _playerEntity:AnimatedCharacter;
        private var _playerName:String;
        private var _allowOnlyCharacterInteraction:Boolean;
        public var cellClickEnabled:Boolean;
        private var _infoEntitiesFrame:InfoEntitiesFrame;
        static const _log:Logger = Log.getLogger(getQualifiedClassName(RoleplayWorldFrame));
        private static const NO_CURSOR:int = -1;
        private static const FIGHT_CURSOR:int = 3;
        private static const NPC_CURSOR:int = 1;
        private static const INTERACTIVE_CURSOR_OFFSET:Point = new Point(0, 0);

        public function RoleplayWorldFrame()
        {
            this._common = XmlConfig.getInstance().getEntry("config.ui.skin");
            this._infoEntitiesFrame = new InfoEntitiesFrame();
            return;
        }// end function

        public function set allowOnlyCharacterInteraction(param1:Boolean) : void
        {
            this._allowOnlyCharacterInteraction = param1;
            return;
        }// end function

        public function get allowOnlyCharacterInteraction() : Boolean
        {
            return this._allowOnlyCharacterInteraction;
        }// end function

        public function get priority() : int
        {
            return Priority.NORMAL;
        }// end function

        private function get roleplayContextFrame() : RoleplayContextFrame
        {
            return Kernel.getWorker().getFrame(RoleplayContextFrame) as RoleplayContextFrame;
        }// end function

        private function get roleplayMovementFrame() : RoleplayMovementFrame
        {
            return Kernel.getWorker().getFrame(RoleplayMovementFrame) as RoleplayMovementFrame;
        }// end function

        public function pushed() : Boolean
        {
            FrustumManager.getInstance().setBorderInteraction(true);
            this._allowOnlyCharacterInteraction = false;
            this.cellClickEnabled = true;
            if (this._texturesReady)
            {
                return true;
            }
            this._mouseBottom = new Texture();
            this._mouseBottom.uri = new Uri(this._common + "assets.swf|cursorBottom");
            this._mouseBottom.finalize();
            this._mouseTop = new Texture();
            this._mouseTop.uri = new Uri(this._common + "assets.swf|cursorTop");
            this._mouseTop.finalize();
            this._mouseRight = new Texture();
            this._mouseRight.uri = new Uri(this._common + "assets.swf|cursorRight");
            this._mouseRight.finalize();
            this._mouseLeft = new Texture();
            this._mouseLeft.uri = new Uri(this._common + "assets.swf|cursorLeft");
            this._mouseLeft.finalize();
            this._texturesReady = true;
            return true;
        }// end function

        public function process(param1:Message) : Boolean
        {
            var _loc_2:AdjacentMapOverMessage = null;
            var _loc_3:Point = null;
            var _loc_4:GraphicCell = null;
            var _loc_5:LinkedCursorData = null;
            var _loc_6:EntityMouseOverMessage = null;
            var _loc_7:String = null;
            var _loc_8:IInteractive = null;
            var _loc_9:AnimatedCharacter = null;
            var _loc_10:* = undefined;
            var _loc_11:IRectangle = null;
            var _loc_12:String = null;
            var _loc_13:String = null;
            var _loc_14:MouseRightClickMessage = null;
            var _loc_15:Object = null;
            var _loc_16:IInteractive = null;
            var _loc_17:EntityMouseOutMessage = null;
            var _loc_18:EntityClickMessage = null;
            var _loc_19:IInteractive = null;
            var _loc_20:GameContextActorInformations = null;
            var _loc_21:Boolean = false;
            var _loc_22:InteractiveElementActivationMessage = null;
            var _loc_23:RoleplayInteractivesFrame = null;
            var _loc_24:InteractiveElementMouseOverMessage = null;
            var _loc_25:Object = null;
            var _loc_26:String = null;
            var _loc_27:String = null;
            var _loc_28:InteractiveElement = null;
            var _loc_29:InteractiveElementSkill = null;
            var _loc_30:Interactive = null;
            var _loc_31:uint = 0;
            var _loc_32:RoleplayEntitiesFrame = null;
            var _loc_33:HouseWrapper = null;
            var _loc_34:Rectangle = null;
            var _loc_35:InteractiveElementMouseOutMessage = null;
            var _loc_36:CellClickMessage = null;
            var _loc_37:AdjacentMapClickMessage = null;
            var _loc_38:IEntity = null;
            var _loc_39:TiphonSprite = null;
            var _loc_40:TiphonSprite = null;
            var _loc_41:Boolean = false;
            var _loc_42:DisplayObject = null;
            var _loc_43:Rectangle = null;
            var _loc_44:Rectangle2 = null;
            var _loc_45:FightTeam = null;
            var _loc_46:int = 0;
            var _loc_47:GuildInformations = null;
            var _loc_48:GuildWrapper = null;
            var _loc_49:GameRolePlayNpcInformations = null;
            var _loc_50:Npc = null;
            var _loc_51:uint = 0;
            var _loc_52:uint = 0;
            var _loc_53:RoleplayContextFrame = null;
            var _loc_54:GameContextActorInformations = null;
            var _loc_55:GameContextActorInformations = null;
            var _loc_56:Object = null;
            var _loc_57:uint = 0;
            var _loc_58:int = 0;
            var _loc_59:uint = 0;
            var _loc_60:GameFightJoinRequestMessage = null;
            var _loc_61:IEntity = null;
            var _loc_62:int = 0;
            var _loc_63:FightTeam = null;
            var _loc_64:FightTeamMemberInformations = null;
            var _loc_65:GuildWrapper = null;
            var _loc_66:IEntity = null;
            var _loc_67:MapPoint = null;
            var _loc_68:Object = null;
            var _loc_69:String = null;
            var _loc_70:String = null;
            switch(true)
            {
                case param1 is CellClickMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    if (this.cellClickEnabled)
                    {
                        _loc_36 = param1 as CellClickMessage;
                        this.roleplayMovementFrame.resetNextMoveMapChange();
                        _log.debug("Player clicked on cell " + _loc_36.cellId + ".");
                        this.roleplayMovementFrame.setFollowingInteraction(null);
                        this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc_36.cellId));
                    }
                    return true;
                }
                case param1 is AdjacentMapClickMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    if (this.cellClickEnabled)
                    {
                        _loc_37 = param1 as AdjacentMapClickMessage;
                        _loc_38 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                        if (!_loc_38)
                        {
                            _log.warn("The player tried to move before its character was added to the scene. Aborting.");
                            return false;
                        }
                        this.roleplayMovementFrame.setNextMoveMapChange(_loc_37.adjacentMapId);
                        if (!_loc_38.position.equals(MapPoint.fromCellId(_loc_37.cellId)))
                        {
                            this.roleplayMovementFrame.setFollowingInteraction(null);
                            this.roleplayMovementFrame.askMoveTo(MapPoint.fromCellId(_loc_37.cellId));
                        }
                        else
                        {
                            this.roleplayMovementFrame.setFollowingInteraction(null);
                            this.roleplayMovementFrame.askMapChange();
                        }
                    }
                    return true;
                }
                case param1 is AdjacentMapOutMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
                    return true;
                }
                case param1 is AdjacentMapOverMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    _loc_2 = AdjacentMapOverMessage(param1);
                    _loc_3 = CellIdConverter.cellIdToCoord(_loc_2.cellId);
                    _loc_4 = InteractiveCellManager.getInstance().getCell(_loc_2.cellId);
                    _loc_5 = new LinkedCursorData();
                    switch(_loc_2.direction)
                    {
                        case DirectionsEnum.LEFT:
                        {
                            _loc_5.sprite = this._mouseLeft;
                            _loc_5.lockX = true;
                            _loc_5.sprite.x = _loc_2.zone.x + _loc_2.zone.width / 2;
                            _loc_5.offset = new Point(0, 0);
                            _loc_5.lockY = true;
                            _loc_5.sprite.y = _loc_4.y + AtouinConstants.CELL_HEIGHT / 2;
                            break;
                        }
                        case DirectionsEnum.UP:
                        {
                            _loc_5.sprite = this._mouseTop;
                            _loc_5.lockY = true;
                            _loc_5.sprite.y = _loc_2.zone.y + _loc_2.zone.height / 2;
                            _loc_5.offset = new Point(0, 0);
                            _loc_5.lockX = true;
                            _loc_5.sprite.x = _loc_4.x + AtouinConstants.CELL_WIDTH / 2;
                            break;
                        }
                        case DirectionsEnum.DOWN:
                        {
                            _loc_5.sprite = this._mouseBottom;
                            _loc_5.lockY = true;
                            _loc_5.sprite.y = _loc_2.zone.getBounds(_loc_2.zone).top;
                            _loc_5.offset = new Point(0, 0);
                            _loc_5.lockX = true;
                            _loc_5.sprite.x = _loc_4.x + AtouinConstants.CELL_WIDTH / 2;
                            break;
                        }
                        case DirectionsEnum.RIGHT:
                        {
                            _loc_5.sprite = this._mouseRight;
                            _loc_5.lockX = true;
                            _loc_5.sprite.x = _loc_2.zone.getBounds(_loc_2.zone).left + _loc_2.zone.width / 2;
                            _loc_5.offset = new Point(0, 0);
                            _loc_5.lockY = true;
                            _loc_5.sprite.y = _loc_4.y + AtouinConstants.CELL_HEIGHT / 2;
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    LinkedCursorSpriteManager.getInstance().addItem("changeMapCursor", _loc_5);
                    return true;
                }
                case param1 is EntityMouseOverMessage:
                {
                    _loc_6 = param1 as EntityMouseOverMessage;
                    _loc_7 = "entity_" + _loc_6.entity.id;
                    this.displayCursor(NO_CURSOR);
                    _loc_8 = _loc_6.entity as IInteractive;
                    _loc_9 = _loc_8 as AnimatedCharacter;
                    if (_loc_9)
                    {
                        _loc_9 = _loc_9.getRootEntity();
                        _loc_9.highLightCharacterAndFollower(true);
                        _loc_8 = _loc_9;
                    }
                    _loc_10 = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc_8.id) as GameRolePlayActorInformations;
                    if (_loc_8 is TiphonSprite)
                    {
                        _loc_39 = _loc_8 as TiphonSprite;
                        _loc_40 = (_loc_8 as TiphonSprite).getSubEntitySlot(SubEntityBindingPointCategoryEnum.HOOK_POINT_CATEGORY_MOUNT_DRIVER, 0) as TiphonSprite;
                        _loc_41 = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) && RoleplayEntitiesFrame(Kernel.getWorker().getFrame(RoleplayEntitiesFrame)).isCreatureMode;
                        if (_loc_40 && !_loc_41)
                        {
                            _loc_39 = _loc_40;
                        }
                        _loc_42 = _loc_39.getSlot("Tete");
                        if (_loc_42)
                        {
                            _loc_43 = _loc_42.getBounds(StageShareManager.stage);
                            _loc_44 = new Rectangle2(_loc_43.x, _loc_43.y, _loc_43.width, _loc_43.height);
                            _loc_11 = _loc_44;
                        }
                    }
                    if (!_loc_11)
                    {
                        _loc_11 = (_loc_8 as IDisplayable).absoluteBounds;
                    }
                    _loc_12 = null;
                    if (this.roleplayContextFrame.entitiesFrame.isFight(_loc_8.id))
                    {
                        if (this.allowOnlyCharacterInteraction)
                        {
                            return false;
                        }
                        _loc_45 = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc_8.id);
                        _loc_10 = new RoleplayTeamFightersTooltipInformation(_loc_45);
                        _loc_12 = "roleplayFight";
                        this.displayCursor(FIGHT_CURSOR, !PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
                    }
                    else
                    {
                        switch(true)
                        {
                            case _loc_10 is GameRolePlayCharacterInformations:
                            {
                                if (_loc_10.contextualId == PlayedCharacterManager.getInstance().id)
                                {
                                    _loc_46 = 0;
                                }
                                else
                                {
                                    _loc_51 = _loc_10.alignmentInfos.characterPower - _loc_10.contextualId;
                                    _loc_52 = PlayedCharacterManager.getInstance().infos.level;
                                    _loc_46 = PlayedCharacterManager.getInstance().levelDiff(_loc_51);
                                }
                                _loc_10 = new CharacterTooltipInformation(_loc_10 as GameRolePlayCharacterInformations, _loc_46);
                                _loc_13 = "CharacterCache";
                                break;
                            }
                            case _loc_10 is GameRolePlayMutantInformations:
                            {
                                if ((_loc_10 as GameRolePlayMutantInformations).humanoidInfo.restrictions.cantAttack)
                                {
                                    _loc_10 = new CharacterTooltipInformation(_loc_10, 0);
                                }
                                else
                                {
                                    _loc_10 = new MutantTooltipInformation(_loc_10 as GameRolePlayMutantInformations);
                                }
                                break;
                            }
                            case _loc_10 is GameRolePlayTaxCollectorInformations:
                            {
                                if (this.allowOnlyCharacterInteraction)
                                {
                                    return false;
                                }
                                _loc_47 = (_loc_10 as GameRolePlayTaxCollectorInformations).guildIdentity;
                                _loc_48 = GuildWrapper.create(_loc_47.guildId, _loc_47.guildName, _loc_47.guildEmblem, 0, true);
                                _loc_10 = new TaxCollectorTooltipInformation(TaxCollectorName.getTaxCollectorNameById((_loc_10 as GameRolePlayTaxCollectorInformations).lastNameId).name, TaxCollectorFirstname.getTaxCollectorFirstnameById((_loc_10 as GameRolePlayTaxCollectorInformations).firstNameId).firstname, _loc_48, (_loc_10 as GameRolePlayTaxCollectorInformations).taxCollectorAttack);
                                break;
                            }
                            case _loc_10 is GameRolePlayNpcInformations:
                            {
                                if (this.allowOnlyCharacterInteraction)
                                {
                                    return false;
                                }
                                _loc_49 = _loc_10 as GameRolePlayNpcInformations;
                                _loc_50 = Npc.getNpcById(_loc_49.npcId);
                                if (_loc_50.actions.length == 0)
                                {
                                    break;
                                }
                                this.displayCursor(NPC_CURSOR);
                                _loc_10 = new TextTooltipInfo(_loc_50.name, XmlConfig.getInstance().getEntry("config.ui.skin") + "css/tooltip_npc.css", "green", 0);
                                _loc_10.bgCornerRadius = 10;
                                _loc_13 = "NPCCacheName";
                                break;
                            }
                            case _loc_10 is GameRolePlayGroupMonsterInformations:
                            {
                                if (this.allowOnlyCharacterInteraction)
                                {
                                    return false;
                                }
                                this.displayCursor(FIGHT_CURSOR, !PlayedCharacterManager.getInstance().restrictions.cantAttackMonster);
                                _loc_13 = "GroupMonsterCache";
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }
                    if (!_loc_10)
                    {
                        _log.warn("Rolling over a unknown entity (" + _loc_6.entity.id + ").");
                        return false;
                    }
                    TooltipManager.show(_loc_10, _loc_11, UiModuleManager.getInstance().getModule("Ankama_Tooltips"), false, _loc_7, LocationEnum.POINT_BOTTOM, LocationEnum.POINT_TOP, 0, true, _loc_12, null, null, _loc_13);
                    return true;
                }
                case param1 is MouseRightClickMessage:
                {
                    _loc_14 = param1 as MouseRightClickMessage;
                    _loc_15 = UiModuleManager.getInstance().getModule("Ankama_ContextMenu").mainClass;
                    _loc_16 = _loc_14.target as IInteractive;
                    if (_loc_16)
                    {
                        _loc_53 = this.roleplayContextFrame;
                        _loc_54 = _loc_53.entitiesFrame.getEntityInfos(_loc_16.id);
                        if (_loc_54 is GameRolePlayNamedActorInformations)
                        {
                            if (!(_loc_16 is AnimatedCharacter))
                            {
                                _log.error("L\'entity " + _loc_16.id + " est un GameRolePlayNamedActorInformations mais n\'est pas un AnimatedCharacter");
                                return true;
                            }
                            _loc_16 = (_loc_16 as AnimatedCharacter).getRootEntity();
                            _loc_55 = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc_16.id);
                            _loc_56 = MenusFactory.create(_loc_55, "multiplayer", [_loc_16]);
                            if (_loc_56)
                            {
                                _loc_15.createContextMenu(_loc_56);
                            }
                            return true;
                        }
                    }
                    return false;
                }
                case param1 is EntityMouseOutMessage:
                {
                    _loc_17 = param1 as EntityMouseOutMessage;
                    this.displayCursor(NO_CURSOR);
                    TooltipManager.hide("entity_" + _loc_17.entity.id);
                    _loc_9 = _loc_17.entity as AnimatedCharacter;
                    if (_loc_9)
                    {
                        _loc_9 = _loc_9.getRootEntity();
                        _loc_9.highLightCharacterAndFollower(false);
                    }
                    return true;
                }
                case param1 is EntityClickMessage:
                {
                    _loc_18 = param1 as EntityClickMessage;
                    _loc_19 = _loc_18.entity as IInteractive;
                    if (_loc_19 is AnimatedCharacter)
                    {
                        _loc_19 = (_loc_19 as AnimatedCharacter).getRootEntity();
                    }
                    _loc_20 = this.roleplayContextFrame.entitiesFrame.getEntityInfos(_loc_19.id);
                    _loc_21 = RoleplayManager.getInstance().displayContextualMenu(_loc_20, _loc_19);
                    if (this.roleplayContextFrame.entitiesFrame.isFight(_loc_19.id))
                    {
                        _loc_57 = this.roleplayContextFrame.entitiesFrame.getFightId(_loc_19.id);
                        _loc_58 = this.roleplayContextFrame.entitiesFrame.getFightLeaderId(_loc_19.id);
                        _loc_59 = this.roleplayContextFrame.entitiesFrame.getFightTeamType(_loc_19.id);
                        if (_loc_59 == TeamTypeEnum.TEAM_TYPE_TAXCOLLECTOR)
                        {
                            _loc_63 = this.roleplayContextFrame.entitiesFrame.getFightTeam(_loc_19.id) as FightTeam;
                            for each (_loc_64 in _loc_63.teamInfos.teamMembers)
                            {
                                
                                if (_loc_64 is FightTeamMemberTaxCollectorInformations)
                                {
                                    _loc_62 = (_loc_64 as FightTeamMemberTaxCollectorInformations).guildId;
                                }
                            }
                            _loc_65 = (Kernel.getWorker().getFrame(SocialFrame) as SocialFrame).guild;
                            if (_loc_65 && _loc_62 == _loc_65.guildId)
                            {
                                KernelEventsManager.getInstance().processCallback(SocialHookList.OpenSocial, 1, 2);
                                Kernel.getWorker().process(GuildFightJoinRequestAction.create(PlayedCharacterManager.getInstance().currentMap.mapId));
                                return true;
                            }
                        }
                        _loc_60 = new GameFightJoinRequestMessage();
                        _loc_60.initGameFightJoinRequestMessage(_loc_58, _loc_57);
                        _loc_61 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                        if ((_loc_61 as IMovable).isMoving)
                        {
                            this.roleplayMovementFrame.setFollowingMessage(_loc_60);
                            (_loc_61 as IMovable).stop();
                        }
                        else
                        {
                            ConnectionsHandler.getConnection().send(_loc_60);
                        }
                    }
                    else if (_loc_19.id != PlayedCharacterManager.getInstance().id && !_loc_21)
                    {
                        this.roleplayMovementFrame.setFollowingInteraction(null);
                        this.roleplayMovementFrame.askMoveTo(_loc_19.position);
                    }
                    return true;
                }
                case param1 is InteractiveElementActivationMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    _loc_22 = param1 as InteractiveElementActivationMessage;
                    _loc_23 = Kernel.getWorker().getFrame(RoleplayInteractivesFrame) as RoleplayInteractivesFrame;
                    if (_loc_23 && _loc_23.usingInteractive)
                    {
                    }
                    else
                    {
                        _loc_66 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id);
                        _loc_67 = _loc_22.position.getNearestFreeCellInDirection(_loc_22.position.advancedOrientationTo(_loc_66.position), DataMapProvider.getInstance(), true);
                        if (!_loc_67)
                        {
                            _loc_67 = _loc_22.position;
                        }
                        this.roleplayMovementFrame.setFollowingInteraction({ie:_loc_22.interactiveElement, skillInstanceId:_loc_22.skillInstanceId});
                        this.roleplayMovementFrame.askMoveTo(_loc_67);
                    }
                    return true;
                }
                case param1 is InteractiveElementMouseOverMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    _loc_24 = param1 as InteractiveElementMouseOverMessage;
                    _loc_28 = _loc_24.interactiveElement;
                    for each (_loc_29 in _loc_28.enabledSkills)
                    {
                        
                        if (_loc_29.skillId == 175)
                        {
                            _loc_25 = this.roleplayContextFrame.currentPaddock;
                            break;
                        }
                    }
                    _loc_30 = Interactive.getInteractiveById(_loc_28.elementTypeId);
                    _loc_31 = _loc_24.interactiveElement.elementId;
                    _loc_32 = Kernel.getWorker().getFrame(RoleplayEntitiesFrame) as RoleplayEntitiesFrame;
                    _loc_33 = _loc_32.housesInformations[_loc_31];
                    _loc_34 = _loc_24.sprite.getRect(StageShareManager.stage);
                    if (_loc_33)
                    {
                        _loc_25 = _loc_33;
                    }
                    else if (_loc_25 == null && _loc_30)
                    {
                        _loc_68 = new Object();
                        _loc_68.interactive = _loc_30.name;
                        _loc_69 = "";
                        for each (_loc_29 in _loc_28.enabledSkills)
                        {
                            
                            _loc_69 = _loc_69 + (Skill.getSkillById(_loc_29.skillId).name + "\n");
                        }
                        _loc_68.enabledSkills = _loc_69;
                        _loc_70 = "";
                        for each (_loc_29 in _loc_28.disabledSkills)
                        {
                            
                            _loc_70 = _loc_70 + (Skill.getSkillById(_loc_29.skillId).name + "\n");
                        }
                        _loc_68.disabledSkills = _loc_70;
                        _loc_25 = _loc_68;
                        _loc_26 = "interactiveElement";
                        _loc_27 = "InteractiveElementCache";
                    }
                    if (_loc_25)
                    {
                        TooltipManager.show(_loc_25, new Rectangle(_loc_34.right, int(_loc_34.y + _loc_34.height - AtouinConstants.CELL_HEIGHT), 0, 0), UiModuleManager.getInstance().getModule("Ankama_Tooltips"), false, TooltipManager.TOOLTIP_STANDAR_NAME, LocationEnum.POINT_BOTTOMLEFT, LocationEnum.POINT_TOP, 0, true, _loc_26, null, null, _loc_27);
                    }
                    return true;
                }
                case param1 is InteractiveElementMouseOutMessage:
                {
                    if (this.allowOnlyCharacterInteraction)
                    {
                        return false;
                    }
                    _loc_35 = param1 as InteractiveElementMouseOutMessage;
                    TooltipManager.hide();
                    return true;
                }
                case param1 is ShowAllNamesAction:
                {
                    if (Kernel.getWorker().contains(InfoEntitiesFrame))
                    {
                        Kernel.getWorker().removeFrame(this._infoEntitiesFrame);
                    }
                    else
                    {
                        Kernel.getWorker().addFrame(this._infoEntitiesFrame);
                    }
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
            Mouse.show();
            LinkedCursorSpriteManager.getInstance().removeItem("changeMapCursor");
            LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
            FrustumManager.getInstance().setBorderInteraction(false);
            return true;
        }// end function

        private function displayCursor(param1:int, param2:Boolean = true) : void
        {
            if (param1 == -1)
            {
                Mouse.show();
                LinkedCursorSpriteManager.getInstance().removeItem("interactiveCursor");
                return;
            }
            if (PlayedCharacterManager.getInstance().state != PlayerLifeStatusEnum.STATUS_ALIVE_AND_KICKING)
            {
                return;
            }
            var _loc_3:* = new LinkedCursorData();
            _loc_3.sprite = RoleplayInteractivesFrame.getCursor(param1, param2);
            _loc_3.offset = INTERACTIVE_CURSOR_OFFSET;
            Mouse.hide();
            LinkedCursorSpriteManager.getInstance().addItem("interactiveCursor", _loc_3);
            return;
        }// end function

        private function onWisperMessage(param1:String) : void
        {
            KernelEventsManager.getInstance().processCallback(ChatHookList.ChatFocus, param1);
            return;
        }// end function

        private function onMerchantPlayerBuyClick(param1:int, param2:uint) : void
        {
            var _loc_3:* = new ExchangeOnHumanVendorRequestMessage();
            _loc_3.initExchangeOnHumanVendorRequestMessage(param1, param2);
            ConnectionsHandler.getConnection().send(_loc_3);
            return;
        }// end function

        private function onInviteMenuClicked(param1:String) : void
        {
            var _loc_2:* = new PartyInvitationRequestMessage();
            _loc_2.initPartyInvitationRequestMessage(param1);
            ConnectionsHandler.getConnection().send(_loc_2);
            return;
        }// end function

        private function onMerchantHouseKickOff(param1:uint) : void
        {
            var _loc_2:* = new HouseKickIndoorMerchantRequestMessage();
            _loc_2.initHouseKickIndoorMerchantRequestMessage(param1);
            ConnectionsHandler.getConnection().send(_loc_2);
            return;
        }// end function

    }
}
