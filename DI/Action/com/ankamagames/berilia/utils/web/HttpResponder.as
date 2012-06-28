package com.ankamagames.berilia.utils.web
{
    import flash.events.*;
    import flash.filesystem.*;
    import flash.net.*;
    import flash.utils.*;

    public class HttpResponder extends Object
    {
        private var _socket:Socket;
        private var _responseBytes:ByteArray;
        private var _contentBytes:ByteArray;
        private var _stream:FileStream;
        private var _mimeHeader:String;
        private var _statusHeader:String;
        private var _dateHeader:String;
        private var _contentLengthHeader:String;
        private var _includeContent:Boolean = true;
        private const HEADER_SEPERATOR:String = "\n";
        private const HEADER_END_SEPERATOR:String = "\n\n";
        private static const HTTP_VERB_GET:String = "GET";
        private static const HTTP_VERB_HEAD:String = "HEAD";
        private static const HTTP_VERB_POST:String = "POST";

        public function HttpResponder(param1:Socket, param2:String, param3:String, param4:String)
        {
            var _loc_6:File = null;
            var _loc_7:Date = null;
            this._socket = param1;
            if (param2 != HttpResponder.HTTP_VERB_GET && param2 != HttpResponder.HTTP_VERB_HEAD)
            {
                this.throw501();
            }
            if (param2 == HttpResponder.HTTP_VERB_HEAD)
            {
                this._includeContent = false;
            }
            this._responseBytes = new ByteArray();
            if (param3.indexOf("?") != -1)
            {
                param3 = param3.substring(0, param3.indexOf("?"));
            }
            param3 = decodeURI(param3);
            if (param3.indexOf("../") != -1 || param3.indexOf("..\\") != -1)
            {
                this.throw403();
            }
            while (param3.charAt(0) == ".")
            {
                
                param3 = param3.substr(1);
            }
            while (param3.charAt(0) == "/")
            {
                
                param3 = param3.substr(1);
            }
            var _loc_5:* = new File(param4);
            if (new File(param4).exists)
            {
                _loc_6 = _loc_5.resolvePath(param3);
                if (_loc_6.exists)
                {
                    if (_loc_6.isDirectory)
                    {
                        this.throw403();
                    }
                    else
                    {
                        trace(_loc_6.nativePath);
                        _loc_7 = _loc_6.modificationDate;
                        this._dateHeader = "Date: " + this.toRFC802(_loc_7);
                        this._mimeHeader = this.getMimeHeader(_loc_6);
                        this._stream = new FileStream();
                        this._stream.addEventListener(Event.COMPLETE, this.onFileReadDone);
                        this._stream.addEventListener(IOErrorEvent.IO_ERROR, this.onFileIoError);
                        this._stream.openAsync(_loc_6, FileMode.READ);
                    }
                }
                else
                {
                    this.throw404();
                }
            }
            else
            {
                this.throw404();
            }
            return;
        }// end function

        private function onFileIoError(event:Event) : void
        {
            this._stream.removeEventListener(IOErrorEvent.IO_ERROR, this.onFileIoError);
            this._stream.close();
            this._dateHeader = null;
            this.throw404();
            return;
        }// end function

        private function onFileReadDone(event:Event) : void
        {
            this._stream.removeEventListener(Event.COMPLETE, this.onFileReadDone);
            this._contentBytes = new ByteArray();
            this._stream.readBytes(this._contentBytes, 0, this._stream.bytesAvailable);
            this._stream.close();
            this._statusHeader = "HTTP/1.0 200 OK";
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function sendResponse() : void
        {
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            if (this._dateHeader)
            {
                this._responseBytes.writeUTFBytes(this._dateHeader);
                this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            }
            this._responseBytes.writeUTFBytes(this._mimeHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_SEPERATOR);
            if (this._includeContent)
            {
                this._responseBytes.writeUTFBytes(this._contentLengthHeader);
            }
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            if (this._includeContent)
            {
                this._responseBytes.writeBytes(this._contentBytes);
            }
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            this._socket.flush();
            return;
        }// end function

        private function throw404() : void
        {
            this._statusHeader = "HTTP/1.0 404 Not Found";
            this._mimeHeader = "Content-Type: text/html";
            var _loc_1:String = "<HTML><HEAD><TITLE>404 Not Found</TITLE></HEAD><BODY>404 Not Found</BODY></HTML>";
            this._contentBytes = new ByteArray();
            this._contentBytes.writeUTFBytes(_loc_1);
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function throw403() : void
        {
            this._statusHeader = "HTTP/1.0 403 Forbidden";
            this._mimeHeader = "Content-Type: text/html";
            var _loc_1:String = "<HTML><HEAD><TITLE>403 Forbidden</TITLE></HEAD><BODY>403 Forbidden</BODY></HTML>";
            this._contentBytes = new ByteArray();
            this._contentBytes.writeUTFBytes(_loc_1);
            this._contentBytes.position = 0;
            this._contentLengthHeader = "Content-Length: " + this._contentBytes.bytesAvailable;
            this.sendResponse();
            return;
        }// end function

        private function throw501() : void
        {
            this._statusHeader = "HTTP/1.0 501 Not Implemented";
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            return;
        }// end function

        private function throw500() : void
        {
            this._statusHeader = "HTTP/1.0 500 Internal Server Error";
            this._responseBytes = new ByteArray();
            this._responseBytes.writeUTFBytes(this._statusHeader);
            this._responseBytes.writeUTFBytes(this.HEADER_END_SEPERATOR);
            this._responseBytes.position = 0;
            this._socket.writeBytes(this._responseBytes, 0, this._responseBytes.bytesAvailable);
            return;
        }// end function

        private function getMimeHeader(param1:File) : String
        {
            var _loc_2:* = param1.extension;
            return "Content-Type: " + MimeTypeHelper.getMimeType(_loc_2);
        }// end function

        private function toRFC802(param1:Date) : String
        {
            var _loc_2:String = "";
            switch(param1.dayUTC)
            {
                case 0:
                {
                    _loc_2 = _loc_2 + "Sun";
                    break;
                }
                case 1:
                {
                    _loc_2 = _loc_2 + "Mon";
                    break;
                }
                case 2:
                {
                    _loc_2 = _loc_2 + "Tue";
                    break;
                }
                case 3:
                {
                    _loc_2 = _loc_2 + "Wed";
                    break;
                }
                case 4:
                {
                    _loc_2 = _loc_2 + "Thu";
                    break;
                }
                case 5:
                {
                    _loc_2 = _loc_2 + "Fri";
                    break;
                }
                case 6:
                {
                    _loc_2 = _loc_2 + "Sat";
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_2 = _loc_2 + ", ";
            if (param1.dateUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.dateUTC + " ");
            switch(param1.month)
            {
                case 0:
                {
                    _loc_2 = _loc_2 + "Jan";
                    break;
                }
                case 1:
                {
                    _loc_2 = _loc_2 + "Feb";
                    break;
                }
                case 2:
                {
                    _loc_2 = _loc_2 + "Mar";
                    break;
                }
                case 3:
                {
                    _loc_2 = _loc_2 + "Apr";
                    break;
                }
                case 4:
                {
                    _loc_2 = _loc_2 + "May";
                    break;
                }
                case 5:
                {
                    _loc_2 = _loc_2 + "Jun";
                    break;
                }
                case 6:
                {
                    _loc_2 = _loc_2 + "Jul";
                    break;
                }
                case 7:
                {
                    _loc_2 = _loc_2 + "Aug";
                    break;
                }
                case 8:
                {
                    _loc_2 = _loc_2 + "Sep";
                    break;
                }
                case 9:
                {
                    _loc_2 = _loc_2 + "Oct";
                    break;
                }
                case 10:
                {
                    _loc_2 = _loc_2 + "Nov";
                    break;
                }
                case 11:
                {
                    _loc_2 = _loc_2 + "Dec";
                    break;
                }
                default:
                {
                    break;
                }
            }
            _loc_2 = _loc_2 + " ";
            _loc_2 = _loc_2 + (param1.fullYearUTC + " ");
            if (param1.hoursUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.hoursUTC + ":");
            if (param1.minutesUTC < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.minutesUTC + ":");
            if (param1.seconds < 10)
            {
                _loc_2 = _loc_2 + "0";
            }
            _loc_2 = _loc_2 + (param1.secondsUTC + " GMT");
            return _loc_2;
        }// end function

    }
}
