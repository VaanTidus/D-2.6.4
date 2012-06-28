package com.ankamagames.dofus.console.debug
{
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.logic.common.frames.*;
    import com.ankamagames.dofus.logic.game.common.managers.*;
    import com.ankamagames.dofus.logic.game.common.misc.*;
    import com.ankamagames.dofus.logic.game.fight.managers.*;
    import com.ankamagames.dofus.logic.game.roleplay.managers.*;
    import com.ankamagames.dofus.misc.*;
    import com.ankamagames.dofus.types.entities.*;
    import com.ankamagames.jerakine.console.*;
    import com.ankamagames.jerakine.entities.interfaces.*;
    import com.ankamagames.jerakine.logger.*;
    import com.ankamagames.jerakine.types.positions.*;
    import com.ankamagames.jerakine.utils.benchmark.monitoring.*;
    import com.ankamagames.jerakine.utils.display.*;
    import com.ankamagames.tiphon.engine.*;
    import com.ankamagames.tiphon.types.look.*;
    import flash.utils.*;

    public class BenchmarkInstructionHandler extends Object implements ConsoleInstructionHandler
    {
        protected var _log:Logger;
        private static var id:uint = 50000;

        public function BenchmarkInstructionHandler()
        {
            this._log = Log.getLogger(getQualifiedClassName(BenchmarkInstructionHandler));
            return;
        }// end function

        public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
        {
            var _loc_4:IAnimated = null;
            var _loc_5:IAnimated = null;
            var _loc_6:FpsManager = null;
            var _loc_7:String = null;
            var _loc_8:BenchmarkCharacter = null;
            var _loc_9:Boolean = false;
            var _loc_10:Boolean = false;
            var _loc_11:int = 0;
            var _loc_12:String = null;
            switch(param2)
            {
                case "addmovingcharacter":
                {
                    if (param3.length > 0)
                    {
                        _loc_8 = new BenchmarkCharacter(id++, TiphonEntityLook.fromString(param3[0]));
                        _loc_8.position = MapPoint.fromCellId(int(Math.random() * 300));
                        _loc_8.display();
                        _loc_8.move(BenchmarkMovementBehavior.getRandomPath(_loc_8));
                    }
                    break;
                }
                case "setanimation":
                {
                    _loc_4 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
                    _loc_4.setAnimation(param3[0]);
                    break;
                }
                case "setdirection":
                {
                    _loc_5 = DofusEntities.getEntity(PlayedCharacterManager.getInstance().id) as IAnimated;
                    _loc_5.setDirection(param3[0]);
                    break;
                }
                case "tiphon-error":
                {
                    TiphonDebugManager.disable();
                    break;
                }
                case "bot-spectator":
                {
                    if (Kernel.getWorker().contains(DebugBotFrame))
                    {
                        Kernel.getWorker().removeFrame(DebugBotFrame.getInstance());
                        param1.output("Arret du bot-spectator, " + DebugBotFrame.getInstance().fightCount + " combat(s) vu");
                    }
                    else
                    {
                        Kernel.getWorker().addFrame(DebugBotFrame.getInstance());
                        param1.output("Démarrage du bot-spectator ");
                    }
                    break;
                }
                case "bot-fight":
                {
                    if (Kernel.getWorker().contains(FightBotFrame))
                    {
                        Kernel.getWorker().removeFrame(FightBotFrame.getInstance());
                        param1.output("Arret du bot-fight, " + FightBotFrame.getInstance().fightCount + " combat(s) effectué");
                    }
                    else
                    {
                        Kernel.getWorker().addFrame(FightBotFrame.getInstance());
                        param1.output("Démarrage du bot-fight ");
                    }
                    break;
                }
                case "fpsmanager":
                {
                    _loc_6 = FpsManager.getInstance(false);
                    if (StageShareManager.stage.contains(_loc_6))
                    {
                        _loc_6.hide();
                    }
                    else
                    {
                        _loc_6.display();
                    }
                    break;
                }
                case "fastanimfun":
                {
                    param1.output((AnimFunManager.getInstance().fastDelay ? ("Désactivation") : ("Activation")) + " de l\'exécution rapide des anims-funs");
                    AnimFunManager.getInstance().fastDelay = !AnimFunManager.getInstance().fastDelay;
                    break;
                }
                case "tacticmode":
                {
                    if (TacticModeManager.getInstance().tacticModeActivated)
                    {
                        TacticModeManager.getInstance().hide();
                        _loc_7 = "Désactivation";
                    }
                    else
                    {
                        _loc_9 = false;
                        _loc_10 = true;
                        _loc_11 = 1;
                        for each (_loc_12 in param3)
                        {
                            
                            if (_loc_12.search("debug") != -1)
                            {
                                _loc_9 = true;
                                continue;
                            }
                            if (_loc_12.search("clearcache") != -1)
                            {
                                _loc_10 = false;
                            }
                        }
                        TacticModeManager.getInstance().setDebugMode(_loc_9, _loc_10);
                        TacticModeManager.getInstance().show(PlayedCharacterManager.getInstance().currentMap, true);
                        _loc_7 = "Activation";
                    }
                    _loc_7 = _loc_7 + " du mode tactique.";
                    param1.output(_loc_7);
                    break;
                }
                default:
                {
                    break;
                }
            }
            return;
        }// end function

        public function getHelp(param1:String) : String
        {
            switch(param1)
            {
                case "addmovingcharacter":
                {
                    return "Add a new mobile character on scene.";
                }
                case "fpsmanager":
                {
                    return "Displays the performance of the client.";
                }
                case "bot-spectator":
                {
                    return "Start/Stop the auto join fight spectator bot";
                }
                case "tiphon-error":
                {
                    return "Désactive l\'affichage des erreurs du moteur d\'animation.";
                }
                case "fastanimfun":
                {
                    return "Active/Désactive l\'exécution rapide des anims funs.";
                }
                case "tacticmode":
                {
                    return "Active/Désactive le mode tactique <debug> (opt) <clearcache> (opt)";
                }
                default:
                {
                    break;
                }
            }
            return "Unknow command";
        }// end function

        public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
        {
            return [];
        }// end function

    }
}
