﻿package com.ankamagames.atouin.types
{
    import com.ankamagames.jerakine.managers.*;
    import com.ankamagames.jerakine.messages.*;
    import flash.display.*;

    dynamic public class AtouinOptions extends OptionManager
    {
        private var _container:DisplayObjectContainer;
        private var _handler:MessageHandler;

        public function AtouinOptions(param1:DisplayObjectContainer, param2:MessageHandler)
        {
            super("atouin");
            add("groundCacheMode", 1);
            add("useInsideAutoZoom", false);
            add("useCacheAsBitmap", true);
            add("useSmooth", true);
            add("frustum", new Frustum(), false);
            add("useMapScrolling", false);
            add("alwaysShowGrid", false);
            add("debugLayer", false);
            add("showCellIdOnOver", false);
            add("tweentInterMap", false);
            add("virtualPlayerJump", false);
            add("reloadLoadedMap", false);
            add("hideForeground", false);
            add("allowAnimatedGfx", true);
            add("allowParticlesFx", true);
            add("elementsPath");
            add("pngSubPath");
            add("jpgSubPath");
            add("mapsPath");
            add("elementsIndexPath");
            add("particlesScriptsPath");
            add("transparentOverlayMode", false);
            add("groundOnly", false);
            add("showTransitions", false);
            add("useLowDefSkin", true);
            this._container = param1;
            this._handler = param2;
            return;
        }// end function

        public function get container() : DisplayObjectContainer
        {
            return this._container;
        }// end function

        public function get handler() : MessageHandler
        {
            return this._handler;
        }// end function

    }
}
