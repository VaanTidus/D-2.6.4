﻿package com.ankamagames.jerakine.types
{
    import com.ankamagames.jerakine.enum.*;
    import com.ankamagames.jerakine.utils.crypto.*;
    import com.ankamagames.jerakine.utils.system.*;
    import flash.errors.*;
    import flash.filesystem.*;
    import flash.system.*;
    import flash.utils.*;

    public class Uri extends Object
    {
        private var _protocol:String;
        private var _path:String;
        private var _subpath:String;
        private var _tag:Object;
        private var _sum:String;
        private var _loaderContext:LoaderContext;
        private var _secureMode:Boolean;
        public static var MEMORY_LOG:Dictionary = new Dictionary(true);
        private static const URI_SYNTAX:RegExp = /^(?:(?P<protocol>[a-z0-9]+)\:\/\/)?(?P<path>[^\|]*)(?|\|)?(?|\/)?(?P<subpath>.*)?$""^(?:(?P<protocol>[a-z0-9]+)\:\/\/)?(?P<path>[^\|]*)(?|\|)?(?|\/)?(?P<subpath>.*)?$/i;
        private static var _useSecureURI:Boolean = false;
        public static var _os:String = SystemManager.getSingleton().os;

        public function Uri(param1:String = null, param2:Boolean = true)
        {
            this._secureMode = param2;
            if (param1 && param1.length > 0)
            {
                this.parseUri(param1);
            }
            MEMORY_LOG[this] = 1;
            return;
        }// end function

        public function get protocol() : String
        {
            return this._protocol;
        }// end function

        public function set protocol(param1:String) : void
        {
            this._protocol = param1;
            this._sum = "";
            return;
        }// end function

        public function get path() : String
        {
            var _loc_1:String = null;
            if (_os == OperatingSystem.WINDOWS)
            {
                return this._path;
            }
            if (this._path.charAt(0) == "/" && this._path.charAt(1) != "/")
            {
                return "/" + this._path;
            }
            return this._path;
        }// end function

        public function set path(param1:String) : void
        {
            this._path = param1.replace(/\\\"""\\/g, "/");
            if (_os == OperatingSystem.WINDOWS)
            {
                this._path = this._path.replace(/^\/(\/*)""^\/(\/*)/, "\\\\");
            }
            this._sum = "";
            return;
        }// end function

        public function get subPath() : String
        {
            return this._subpath;
        }// end function

        public function set subPath(param1:String) : void
        {
            this._subpath = param1.substr(0, 1) == "/" ? (param1.substr(1)) : (param1);
            this._sum = "";
            return;
        }// end function

        public function get uri() : String
        {
            return this.toString();
        }// end function

        public function set uri(param1:String) : void
        {
            this.parseUri(param1);
            return;
        }// end function

        public function get tag()
        {
            return this._tag;
        }// end function

        public function set tag(param1) : void
        {
            this._tag = param1;
            return;
        }// end function

        public function get loaderContext() : LoaderContext
        {
            return this._loaderContext;
        }// end function

        public function set loaderContext(param1:LoaderContext) : void
        {
            this._loaderContext = param1;
            return;
        }// end function

        public function get fileType() : String
        {
            if (!this._subpath || this._subpath.length == 0 || this._subpath.indexOf(".") == -1)
            {
                return this._path.substr((this._path.lastIndexOf(".") + 1));
            }
            return this._subpath.substr((this._subpath.lastIndexOf(".") + 1));
        }// end function

        public function get fileName() : String
        {
            if (!this._subpath || this._subpath.length == 0)
            {
                return this._path.substr((this._path.lastIndexOf("/") + 1));
            }
            return this._subpath.substr((this._subpath.lastIndexOf("/") + 1));
        }// end function

        public function get normalizedUri() : String
        {
            switch(this._protocol)
            {
                case "http":
                case "file":
                case "zip":
                case "upd":
                case "mod":
                case "d2p":
                case "d2pOld":
                case "pak":
                case "pak2":
                {
                    return this.replaceChar(this.uri, "\\", "/");
                }
                default:
                {
                    break;
                }
            }
            throw new IllegalOperationError("Unsupported protocol " + this._protocol + " for normalization.");
        }// end function

        public function get normalizedUriWithoutSubPath() : String
        {
            switch(this._protocol)
            {
                case "http":
                case "file":
                case "zip":
                case "upd":
                case "mod":
                case "d2p":
                case "d2pOld":
                case "pak":
                case "pak2":
                {
                    return this.replaceChar(this.toString(false), "\\", "/");
                }
                default:
                {
                    break;
                }
            }
            throw new IllegalOperationError("Unsupported protocol " + this._protocol + " for normalization.");
        }// end function

        public function isSecure() : Boolean
        {
            var dofusNativePath:String;
            var currentFile:File;
            try
            {
                dofusNativePath = File.applicationDirectory.nativePath;
                currentFile = File.applicationDirectory.resolvePath(unescape(this._path));
                while (true)
                {
                    
                    if (currentFile.nativePath == dofusNativePath)
                    {
                        return true;
                    }
                    currentFile = currentFile.parent;
                    if (!currentFile)
                    {
                        break;
                    }
                }
            }
            catch (e:Error)
            {
            }
            return false;
        }// end function

        public function toString(param1:Boolean = true) : String
        {
            return this._protocol + "://" + this.path + (param1 && this._subpath && this._subpath.length > 0 ? ("|" + this._subpath) : (""));
        }// end function

        public function toSum() : String
        {
            if (this._sum.length > 0)
            {
                return this._sum;
            }
            var _loc_1:* = new CRC32();
            var _loc_2:* = new ByteArray();
            _loc_2.writeUTF(this.normalizedUri);
            _loc_1.update(_loc_2);
            var _loc_3:* = _loc_1.getValue().toString(16);
            this._sum = _loc_1.getValue().toString(16);
            return _loc_3;
        }// end function

        public function toFile() : File
        {
            var _loc_1:* = unescape(this._path);
            if (SystemManager.getSingleton().os == OperatingSystem.WINDOWS && (_loc_1.indexOf("\\\\") == 0 || _loc_1.charAt(1) == ":"))
            {
                return new File(_loc_1);
            }
            if (SystemManager.getSingleton().os != OperatingSystem.WINDOWS && _loc_1.charAt(0) == "/")
            {
                return new File("/" + _loc_1);
            }
            return new File(File.applicationDirectory.nativePath + File.separator + _loc_1);
        }// end function

        private function parseUri(param1:String) : void
        {
            var _loc_2:* = param1.match(URI_SYNTAX);
            if (!_loc_2)
            {
                throw new ArgumentError("\'" + param1 + "\' is a misformated URI.");
            }
            this._protocol = _loc_2["protocol"];
            if (this._protocol.length == 0)
            {
                this._protocol = "file";
            }
            if (SystemManager.getSingleton().os == OperatingSystem.WINDOWS)
            {
                this.path = _loc_2["path"].replace(/^\/*""^\/*/, "");
                this.path = this.path.replace("//", "/");
            }
            else
            {
                this.path = _loc_2["path"];
            }
            if (this._secureMode && _useSecureURI && this._protocol == "file")
            {
                if (!this.isSecure() && this._path.indexOf("\\\\") != 0 && this._path.indexOf("Dofus 2 Local") == -1 && this._path.indexOf("core-resources") == -1)
                {
                    throw new ArgumentError("\'" + param1 + "\' is a unsecure URI.");
                }
            }
            this._subpath = _loc_2["subpath"];
            this._sum = "";
            return;
        }// end function

        private function replaceChar(param1:String, param2:String, param3:String) : String
        {
            return param1.split(param2).join(param3);
        }// end function

        public static function enableSecureURI() : void
        {
            _useSecureURI = true;
            return;
        }// end function

    }
}
