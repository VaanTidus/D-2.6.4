﻿package com.ankamagames.dofus.console.debug
{
    import com.ankamagames.dofus.console.debug.frames.*;
    import com.ankamagames.dofus.kernel.*;
    import com.ankamagames.dofus.network.enums.*;
    import com.ankamagames.dofus.network.types.updater.*;
    import com.ankamagames.jerakine.console.*;

    public class UpdaterInstructionHandler extends Object implements ConsoleInstructionHandler
    {
        private var _lastConsole:ConsoleHandler;
        private var _updaterDebugFrame:UpdaterDebugFrame;

        public function UpdaterInstructionHandler()
        {
            return;
        }// end function

        public function get updaterDebugFrame() : UpdaterDebugFrame
        {
            if (!this._updaterDebugFrame)
            {
                this._updaterDebugFrame = Kernel.getWorker().getFrame(UpdaterDebugFrame) as UpdaterDebugFrame;
                if (!this._updaterDebugFrame)
                {
                    this._updaterDebugFrame = new UpdaterDebugFrame();
                    Kernel.getWorker().addFrame(this._updaterDebugFrame);
                }
            }
            return this._updaterDebugFrame;
        }// end function

        public function handle(param1:ConsoleHandler, param2:String, param3:Array) : void
        {
            this._lastConsole = param1;
            switch(param2)
            {
                case "partdebug":
                {
                    break;
                }
                case "partlist":
                {
                    this.updaterDebugFrame.partListRequest(this.onPartInfo);
                    break;
                }
                case "partinfo":
                {
                    if (param3.length == 1)
                    {
                        this.updaterDebugFrame.partInfoRequest(param3[0], this.onPartInfo);
                    }
                    else
                    {
                        param1.output("bad arguments");
                    }
                    break;
                }
                case "updaterspeed":
                {
                    if (param3.length == 1)
                    {
                        this.updaterDebugFrame.setUpdaterSpeedRequest(param3[0], this.onGetUpdaterSpeed);
                    }
                    else if (param3.length == 0)
                    {
                        this.updaterDebugFrame.getUpdaterSpeedRequest(this.onGetUpdaterSpeed);
                    }
                    else
                    {
                        param1.output("bad arguments");
                    }
                    break;
                }
                case "downloadpart":
                {
                    if (param3.length == 1)
                    {
                        this.updaterDebugFrame.downloadPartRequest(param3[0], this.onPartInfo);
                    }
                    else
                    {
                        param1.output("bad arguments");
                    }
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
                case "partdebug":
                {
                    return "enable client part debugging tools. Must be run before any other part debug command";
                }
                case "partlist":
                {
                    return "get client parts list";
                }
                case "partinfo":
                {
                    return "get a client part details by part name";
                }
                case "updaterspeed":
                {
                    return "get or set updater download speed (1 : slower, 10 : faster)";
                }
                case "downloadpart":
                {
                    return "ask for part download by part name";
                }
                default:
                {
                    break;
                }
            }
            return "No help for command \'" + param1 + "\'";
        }// end function

        public function getParamPossibilities(param1:String, param2:uint = 0, param3:Array = null) : Array
        {
            var _loc_4:Array = [];
            switch(param1)
            {
                default:
                {
                    break;
                }
            }
            return _loc_4;
        }// end function

        private function onGetUpdaterSpeed(param1:int) : void
        {
            this._lastConsole.output("updater download speed : " + param1);
            return;
        }// end function

        private function onPartInfo(param1:ContentPart) : void
        {
            if (param1)
            {
                this._lastConsole.output(param1.id + "\t\t\t" + stateToString(param1.state));
            }
            else
            {
                this._lastConsole.output("part not found");
            }
            return;
        }// end function

        private static function stateToString(param1:int) : String
        {
            switch(param1)
            {
                case PartStateEnum.PART_BEING_UPDATER:
                {
                    return "PART_BEING_UPDATER";
                }
                case PartStateEnum.PART_NOT_INSTALLED:
                {
                    return "PART_NOT_INSTALLED";
                }
                case PartStateEnum.PART_UP_TO_DATE:
                {
                    return "PART_UP_TO_DATE";
                }
                default:
                {
                    break;
                }
            }
            return "(unknow state)";
        }// end function

    }
}
