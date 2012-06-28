package com.ankamagames.dofus.logic.connection.frames
{
    import com.ankamagames.berilia.*;
    import com.ankamagames.berilia.managers.*;
    import com.ankamagames.dofus.*;
    import com.ankamagames.dofus.internalDatacenter.connection.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.kernel.net.*;
    import com.ankamagames.dofus.logic.common.frames.*;
    import com.ankamagames.dofus.logic.common.managers.*;
    import com.ankamagames.dofus.logic.connection.actions.*;
    import com.ankamagames.dofus.logic.connection.managers.*;
    import com.ankamagames.dofus.logic.game.approach.actions.*;
    import com.ankamagames.dofus.logic.game.approach.managers.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.misc.lists.*;
    import com.ankamagames.dofus.network.messages.connection.*;
    import com.ankamagames.dofus.network.messages.connection.register.*;
    import com.ankamagames.jerakine.data.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.managers.*;
    import com.ankamagames.jerakine.messages.*;
    import com.ankamagames.jerakine.network.*;
    import com.ankamagames.jerakine.network.messages.*;
    import com.ankamagames.jerakine.resources.events.*;
    import com.ankamagames.jerakine.resources.loaders.*;
    import com.ankamagames.jerakine.types.*;
    import com.ankamagames.jerakine.types.enums.*;
    import com.ankamagames.jerakine.utils.crypto.*;
    import flash.system.*;
    import flash.utils.*;

    public class AuthentificationFrame extends Object implements Frame
    {
        private var _loader:IResourceLoader;
        private var _contextLoader:LoaderContext;
        private var _dispatchModuleHook:Boolean;
        private var _connexionSequence:Array;
        private var commonMod:Object;
        static const _log:Logger = Log.getLogger(getQualifiedClassName(AuthentificationFrame));
        private static var _lastTicket:String;

        public function AuthentificationFrame(param1:Boolean = true)
        {
            this.commonMod = UiModuleManager.getInstance().getModule("Ankama_Common").mainClass;
            this._dispatchModuleHook = param1;
            this._contextLoader = new LoaderContext();
            this._contextLoader.checkPolicyFile = true;
            this._loader = ResourceLoaderFactory.getLoader(ResourceLoaderType.SERIAL_LOADER);
            this._loader.addEventListener(ResourceErrorEvent.ERROR, this.onLoadError);
            this._loader.addEventListener(ResourceLoadedEvent.LOADED, this.onLoad);
            return;
        }// end function

        public function get priority() : int
        {
            return Priority.NORMAL;
        }// end function

        public function pushed() : Boolean
        {
            var _loc_1:String = null;
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_5:Array = null;
            this.processInvokeArgs();
            if (this._dispatchModuleHook)
            {
                _loc_1 = OptionManager.getOptionManager("dofus")["legalAgreementEula"];
                _loc_2 = OptionManager.getOptionManager("dofus")["legalAgreementTou"];
                _loc_3 = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + I18n.getUiText("ui.legal.eula").length;
                _loc_4 = XmlConfig.getInstance().getEntry("config.lang.current") + "#" + (I18n.getUiText("ui.legal.tou1") + I18n.getUiText("ui.legal.tou2")).length;
                _loc_5 = new Array();
                if (_loc_1 != _loc_3)
                {
                    _loc_5.push("eula");
                }
                if (_loc_2 != _loc_4)
                {
                    _loc_5.push("tou");
                }
                if (_loc_5.length > 0)
                {
                    KernelEventsManager.getInstance().processCallback(HookList.AgreementsRequired, _loc_5);
                }
                KernelEventsManager.getInstance().processCallback(HookList.AuthentificationStart);
            }
            return true;
        }// end function

        public function process(param1:Message) : Boolean
        {
            var _loc_2:LoginValidationAction = null;
            var _loc_3:Array = null;
            var _loc_4:String = null;
            var _loc_5:Array = null;
            var _loc_6:Array = null;
            var _loc_7:DataStoreType = null;
            var _loc_8:uint = 0;
            var _loc_9:Array = null;
            var _loc_10:Object = null;
            var _loc_11:ServerConnectionFailedMessage = null;
            var _loc_12:HelloConnectMessage = null;
            var _loc_13:IdentificationSuccessMessage = null;
            var _loc_14:IdentificationFailedForBadVersionMessage = null;
            var _loc_15:IdentificationFailedBannedMessage = null;
            var _loc_16:IdentificationFailedMessage = null;
            var _loc_17:NicknameRegistrationMessage = null;
            var _loc_18:NicknameRefusedMessage = null;
            var _loc_19:NicknameAcceptedMessage = null;
            var _loc_20:NicknameChoiceRequestAction = null;
            var _loc_21:NicknameChoiceRequestMessage = null;
            var _loc_22:SubscribersGiftListRequestAction = null;
            var _loc_23:Uri = null;
            var _loc_24:String = null;
            var _loc_25:NewsLoginRequestAction = null;
            var _loc_26:Uri = null;
            var _loc_27:String = null;
            var _loc_28:String = null;
            var _loc_29:String = null;
            var _loc_30:Object = null;
            var _loc_31:String = null;
            var _loc_32:uint = 0;
            var _loc_33:String = null;
            var _loc_34:Array = null;
            var _loc_35:Array = null;
            var _loc_36:String = null;
            var _loc_37:Array = null;
            var _loc_38:uint = 0;
            var _loc_39:Object = null;
            switch(true)
            {
                case param1 is LoginValidationAction:
                {
                    _loc_2 = LoginValidationAction(param1);
                    _loc_3 = new Array();
                    _loc_4 = XmlConfig.getInstance().getEntry("config.connection.port");
                    for each (_loc_28 in _loc_4.split(","))
                    {
                        
                        _loc_3.push(int(_loc_28));
                    }
                    _loc_5 = XmlConfig.getInstance().getEntry("config.connection.host").split(",");
                    _loc_6 = [];
                    for each (_loc_29 in _loc_5)
                    {
                        
                        _loc_6.push({host:_loc_29, random:Math.random()});
                    }
                    _loc_6.sortOn("random", Array.NUMERIC);
                    _loc_5 = [];
                    for each (_loc_30 in _loc_6)
                    {
                        
                        _loc_5.push(_loc_30.host);
                    }
                    _loc_7 = new DataStoreType("Dofus_ComputerOptions", true, DataStoreEnum.LOCATION_LOCAL, DataStoreEnum.BIND_ACCOUNT);
                    _loc_8 = uint(StoreDataManager.getInstance().getData(_loc_7, "connectionPortDefault"));
                    this._connexionSequence = [];
                    _loc_9 = [];
                    for each (_loc_31 in _loc_5)
                    {
                        
                        for each (_loc_32 in _loc_3)
                        {
                            
                            if (_loc_8 == _loc_32)
                            {
                                _loc_9.push({host:_loc_31, port:_loc_32});
                                continue;
                            }
                            this._connexionSequence.push({host:_loc_31, port:_loc_32});
                        }
                    }
                    this._connexionSequence = _loc_9.concat(this._connexionSequence);
                    if (Constants.EVENT_MODE)
                    {
                        _loc_33 = Constants.EVENT_MODE_PARAM;
                        if (_loc_33 && _loc_33.charAt(0) != "!")
                        {
                            _loc_33 = Base64.decode(_loc_33);
                            _loc_34 = [];
                            _loc_35 = _loc_33.split(",");
                            for each (_loc_36 in _loc_35)
                            {
                                
                                _loc_37 = _loc_36.split(":");
                                _loc_34[_loc_37[0]] = _loc_37[1];
                            }
                            if (_loc_34["login"])
                            {
                                _loc_2.username = _loc_34["login"];
                            }
                            if (_loc_34["password"])
                            {
                                _loc_2.password = _loc_34["password"];
                            }
                        }
                    }
                    AuthentificationManager.getInstance().setValidationAction(_loc_2);
                    _loc_10 = this._connexionSequence.shift();
                    ConnectionsHandler.connectToLoginServer(_loc_10.host, _loc_10.port);
                    return true;
                }
                case param1 is ServerConnectionFailedMessage:
                {
                    _loc_11 = ServerConnectionFailedMessage(param1);
                    if (_loc_11.failedConnection == ConnectionsHandler.getConnection())
                    {
                        PlayerManager.getInstance().destroy();
                        (ConnectionsHandler.getConnection() as ServerConnection).stopConnectionTimeout();
                        _loc_38 = _loc_11.failedConnection.port;
                        if (this._connexionSequence)
                        {
                            _loc_39 = this._connexionSequence.shift();
                            if (_loc_39)
                            {
                                ConnectionsHandler.connectToLoginServer(_loc_39.host, _loc_39.port);
                            }
                            else
                            {
                                KernelEventsManager.getInstance().processCallback(HookList.ServerConnectionFailed, DisconnectionReasonEnum.UNEXPECTED);
                            }
                        }
                    }
                    return true;
                }
                case param1 is HelloConnectMessage:
                {
                    _loc_12 = HelloConnectMessage(param1);
                    AuthentificationManager.getInstance().setPublicKey(_loc_12.key);
                    AuthentificationManager.getInstance().setSalt(_loc_12.salt);
                    ConnectionsHandler.getConnection().send(AuthentificationManager.getInstance().getIdentificationMessage());
                    KernelEventsManager.getInstance().processCallback(HookList.ConnectionTimerStart);
                    TimeManager.getInstance().reset();
                    return true;
                }
                case param1 is IdentificationSuccessMessage:
                {
                    _loc_13 = IdentificationSuccessMessage(param1);
                    if (_loc_13 is IdentificationSuccessWithLoginTokenMessage)
                    {
                        AuthentificationManager.getInstance().nextToken = IdentificationSuccessWithLoginTokenMessage(_loc_13).loginToken;
                    }
                    if (_loc_13.login)
                    {
                        AuthentificationManager.getInstance().username = _loc_13.login;
                    }
                    PlayerManager.getInstance().accountId = _loc_13.accountId;
                    PlayerManager.getInstance().communityId = _loc_13.communityId;
                    PlayerManager.getInstance().hasRights = _loc_13.hasRights;
                    PlayerManager.getInstance().nickname = _loc_13.nickname;
                    PlayerManager.getInstance().subscriptionEndDate = _loc_13.subscriptionEndDate;
                    PlayerManager.getInstance().secretQuestion = _loc_13.secretQuestion;
                    PlayerManager.getInstance().accountCreation = _loc_13.accountCreation;
                    AuthorizedFrame(Kernel.getWorker().getFrame(AuthorizedFrame)).hasRights = _loc_13.hasRights;
                    if (PlayerManager.getInstance().subscriptionEndDate > 0 || PlayerManager.getInstance().hasRights)
                    {
                        PartManager.getInstance().checkAndDownload("all");
                        PartManager.getInstance().checkAndDownload("subscribed");
                    }
                    StoreUserDataManager.getInstance().savePlayerData();
                    Kernel.getWorker().removeFrame(this);
                    Kernel.getWorker().addFrame(new ChangeCharacterFrame());
                    Kernel.getWorker().addFrame(new ServerSelectionFrame());
                    KernelEventsManager.getInstance().processCallback(HookList.IdentificationSuccess);
                    return true;
                }
                case param1 is IdentificationFailedForBadVersionMessage:
                {
                    _loc_14 = IdentificationFailedForBadVersionMessage(param1);
                    PlayerManager.getInstance().destroy();
                    ConnectionsHandler.closeConnection();
                    KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedForBadVersion, _loc_14.reason, _loc_14.requiredVersion);
                    if (!this._dispatchModuleHook)
                    {
                        this._dispatchModuleHook = true;
                        this.pushed();
                    }
                    return true;
                }
                case param1 is IdentificationFailedBannedMessage:
                {
                    _loc_15 = IdentificationFailedBannedMessage(param1);
                    PlayerManager.getInstance().destroy();
                    ConnectionsHandler.closeConnection();
                    KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailedWithDuration, _loc_15.reason, _loc_15.banEndDate);
                    if (!this._dispatchModuleHook)
                    {
                        this._dispatchModuleHook = true;
                        this.pushed();
                    }
                    return true;
                }
                case param1 is IdentificationFailedMessage:
                {
                    _loc_16 = IdentificationFailedMessage(param1);
                    PlayerManager.getInstance().destroy();
                    ConnectionsHandler.closeConnection();
                    KernelEventsManager.getInstance().processCallback(HookList.IdentificationFailed, _loc_16.reason);
                    if (!this._dispatchModuleHook)
                    {
                        this._dispatchModuleHook = true;
                        this.pushed();
                    }
                    return true;
                }
                case param1 is NicknameRegistrationMessage:
                {
                    _loc_17 = NicknameRegistrationMessage(param1);
                    KernelEventsManager.getInstance().processCallback(HookList.NicknameRegistration);
                    return true;
                }
                case param1 is NicknameRefusedMessage:
                {
                    _loc_18 = NicknameRefusedMessage(param1);
                    KernelEventsManager.getInstance().processCallback(HookList.NicknameRefused, _loc_18.reason);
                    return true;
                }
                case param1 is NicknameAcceptedMessage:
                {
                    _loc_19 = NicknameAcceptedMessage(param1);
                    KernelEventsManager.getInstance().processCallback(HookList.NicknameAccepted);
                    return true;
                }
                case param1 is NicknameChoiceRequestAction:
                {
                    _loc_20 = NicknameChoiceRequestAction(param1);
                    _loc_21 = new NicknameChoiceRequestMessage();
                    _loc_21.initNicknameChoiceRequestMessage(_loc_20.nickname);
                    ConnectionsHandler.getConnection().send(_loc_21);
                    return true;
                }
                case param1 is SubscribersGiftListRequestAction:
                {
                    _loc_22 = SubscribersGiftListRequestAction(param1);
                    _loc_24 = XmlConfig.getInstance().getEntry("config.lang.current");
                    if (_loc_24 == "de" || _loc_24 == "en" || _loc_24 == "es" || _loc_24 == "pt" || _loc_24 == "fr" || _loc_24 == "uk" || _loc_24 == "ru")
                    {
                        _loc_23 = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_" + _loc_24 + ".xml");
                    }
                    else
                    {
                        _loc_23 = new Uri(XmlConfig.getInstance().getEntry("config.subscribersGift") + "subscriberGifts_en.xml");
                    }
                    _loc_23.loaderContext = this._contextLoader;
                    this._loader.load(_loc_23);
                    return true;
                }
                case param1 is NewsLoginRequestAction:
                {
                    _loc_25 = NewsLoginRequestAction(param1);
                    _loc_27 = XmlConfig.getInstance().getEntry("config.lang.current");
                    if (_loc_27 == "de" || _loc_27 == "en" || _loc_27 == "es" || _loc_27 == "pt" || _loc_27 == "fr" || _loc_27 == "uk" || _loc_27 == "it" || _loc_27 == "ru")
                    {
                        _loc_26 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_" + _loc_27 + ".xml");
                    }
                    else
                    {
                        _loc_26 = new Uri(XmlConfig.getInstance().getEntry("config.loginNews") + "news_en.xml");
                    }
                    _loc_26.loaderContext = this._contextLoader;
                    this._loader.load(_loc_26);
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
            Berilia.getInstance().unloadUi("Login");
            this._loader.removeEventListener(ResourceErrorEvent.ERROR, this.onLoadError);
            this._loader.removeEventListener(ResourceLoadedEvent.LOADED, this.onLoad);
            return true;
        }// end function

        private function processInvokeArgs() : void
        {
            var _loc_1:String = null;
            var _loc_2:int = 0;
            var _loc_3:String = null;
            var _loc_4:LoginValidationWithTicketAction = null;
            _log.error("Parse launch param\'s");
            for each (_loc_3 in Dofus.getInstance().invokeArgs)
            {
                
                if (_loc_3.charAt(0) == "-")
                {
                    _loc_3 = _loc_3.substr(1);
                }
                _loc_2 = _loc_3.indexOf("=");
                if (_loc_2 == -1)
                {
                    _loc_1 = null;
                }
                else
                {
                    _loc_1 = _loc_3.substr((_loc_2 + 1));
                    _loc_3 = _loc_3.substr(0, _loc_2);
                }
                _log.trace("Param [" + _loc_3 + "] = [" + _loc_1 + "]");
                switch(_loc_3)
                {
                    case "ticket":
                    {
                        if (_lastTicket == _loc_1)
                        {
                            break;
                        }
                        _lastTicket = _loc_1;
                        _loc_4 = LoginValidationWithTicketAction.create(_loc_1, true);
                        this.process(_loc_4);
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
            }
            return;
        }// end function

        private function onLoad(event:ResourceLoadedEvent) : void
        {
            var _loc_5:int = 0;
            var _loc_6:XML = null;
            var _loc_7:SubscriberGift = null;
            var _loc_8:String = null;
            var _loc_9:String = null;
            var _loc_10:uint = 0;
            var _loc_11:XML = null;
            var _loc_2:* = new Array();
            var _loc_3:* = event.resource;
            var _loc_4:* = _loc_3.toXMLString();
            if (_loc_3.toXMLString().substring(1, 17) == "subscribersGifts")
            {
                _loc_5 = 0;
                for each (_loc_6 in _loc_3..gift)
                {
                    
                    _loc_5++;
                    _loc_7 = new SubscriberGift(_loc_5, _loc_6.description, _loc_6.uri, _loc_6.link);
                    _loc_2.push(_loc_7);
                }
                KernelEventsManager.getInstance().processCallback(HookList.SubscribersList, _loc_2);
            }
            else if (_loc_4.substring(1, 9) == "newsList")
            {
                _loc_10 = 0;
                for each (_loc_11 in _loc_3..news)
                {
                    
                    if (_loc_11.@id > _loc_10)
                    {
                        _loc_8 = _loc_11.text;
                        _loc_9 = _loc_11.link;
                        _loc_10 = _loc_11.@id;
                    }
                }
                KernelEventsManager.getInstance().processCallback(HookList.NewsLogin, _loc_8, _loc_9);
            }
            return;
        }// end function

        private function onLoadError(event:ResourceErrorEvent) : void
        {
            _log.error("Cannot load xml " + event.uri + "(" + event.errorMsg + ")");
            return;
        }// end function

    }
}
