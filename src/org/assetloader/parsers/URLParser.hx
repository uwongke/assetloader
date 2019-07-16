package org.assetloader.parsers;

/** The URLParser is used to check whether URLs are valid or not, also it extracts useful information from the given url.
	URLs are parsed according to three groups; Absolute, Relative and Server.

	- Absolute
	  Recognized by having a protocol. E.g. starts with "http://"
	  Looks for a file extension. E.g. somefile.jpg

	- Relative
	  Recognized by NOT having a protocol. E.g. doesn't start with "http://"
	  Looks for a file extension. E.g. somefile.jpg

	- Server
	  Recognized by NOT having a file extension.
	  Can be Absolute or Relative.
	  If Absolute no trailing slash required. E.g. http://www.matan.co.za/getGalleryXML
	  If Relative trailing slash IS required. E.g. getGalleryXML/
	  Note: if relative with multiple pathings the trailing slash isn't required. E.g. scripts/getGalleryXML */
import openfl.net.URLVariables;
class URLParser {

    /** Gets the url passes through constructor. */
    private var _url : String;
    public var url(get, never) : String;
    private function get_url() : String {
        return _url;
    }

    /** Gets the protocol of the url. */
    private var _protocol : String;
    public var protocol(get, never) : String;
    private function get_protocol() : String {
        return _protocol;
    }

    /** Gets the login/username from the url. E.g. ftp://Matan:Password@some.where.com will return Matan. */
    private var _login : String;
    public var login(get, never) : String;
    private function get_login() : String {
        return _login;
    }

    /** Gets the password from the url. E.g. ftp://Matan:Password@some.where.com will return Password. */
    private var _password : String;
    public var password(get, never) : String;
    private function get_password() : String {
        return _password;
    }

    /** Gets the port of the url. */
    private var _port : Int = 80;
    public var port(get, never) : Int;
    private function get_port() : Int {
        return _port;
    }

    /** Gets the host of the url. E.g. www.matanuberstein.co.za */
    private var _host : String;
    public var host(get, never) : String;
    private function get_host() : String {
        return _host;
    }

    /** Gets the path of the url. E.g. some/path/to/file/ */
    private var _path : String;
    public var path(get, never) : String;
    private function get_path() : String {
        return _path;
    }

    private var _fileName : String;
    public var fileName(get, never) : String;
    /** Gets the file name of the url. E.g. someFileName.ext */
    private function get_fileName() : String {
        return _fileName;
    }

    /** Gets the file extension of the url. E.g. txt, php, etc. */
    private var _fileExtension : String = "";
    public var fileExtension(get, never) : String;
    private function get_fileExtension() : String {
        return _fileExtension;
    }

    /** Gets the url variables from the url. */
    private var _urlVariables : URLVariables;
    public var urlVariables(get, never) : URLVariables;
    private function get_urlVariables() : URLVariables {
        return _urlVariables;
    }

    /** Gets the file hash anchor of the url. E.g. www.matanuberstein.co.za/#hello will return hello. */
    private var _anchor : String;
    public var anchor(get, never) : String;
    private function get_anchor() : String {
        return _anchor;
    }

    /** Gets whether the url is valid or not. E.g. if a empty path is passed isValid will be false. */
    private var _isValid : Bool = true;
    public var isValid(get, never) : Bool;
    private function get_isValid() : Bool {
        return _isValid;
    }

    /** The following parser has been borrowed from: http://old.haxe.org/doc/snip/uri_parser to replace
        the AS3 parser which did not convert to haxe corectly.  The regex provided from the above source
        is exhaustive however we do not need all of the fields and ideally, I'd rather not modify this
        complext regex.  The _parts are provided to map regex(s) in order of appearance of the combined
        expression so I've simply used empty string literals in place of unused fields.  Haxe reflection
        is employed to populate the exiting fields as appropriate.  Wolfie. */
    static private var _parts : Array<String> = [
        "",
        "protocol",
        "",
        "",
        "login",
        "password",
        "host",
        "port",
        "",
        "path",
        "",
        "fileName",
        "urlVariables",
        "anchor"
    ];

    /** Parses url and breaks is down into properties and check whether the url is valid. */
    public function new(url : String) {
        _url = url;

        /** Check that a URL has been provided */
        switch(_url){
            case null: _isValid = false;
            case "": _isValid = false;
        }

        /** Check the validity of the URL */
        if(_isValid){ if (_url.length >= 250) { _isValid = false; } }

        if(_isValid){
            /** The regexp (courtesy of http://blog.stevenlevithan.com/archives/parseuri) */
            var urlExp : EReg = ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*)(?::([^:@]*))?)?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/;

            /** Match the regexp to the url */
            urlExp.match(url);
            for (i in 0..._parts.length) {
                if(_parts[i] != ""){
                    if(urlExp.matched(i) !=null){
                        Reflect.setField(this, "_"+_parts[i],  urlExp.matched(i));
                    }
                }
            }

            /** Handle urlVariables */
            if(_urlVariables != null){
                _urlVariables = new URLVariables(_urlVariables);
            }

            /** Corner cases */

            if(_host.indexOf(".") == -1){
                _isValid = false;
                _path = "/"+_host+path;
                _host = null;
            }

            /** duplicate '/' */
            _path = StringTools.replace(_path, "//", "/");

            /** fileName */
            if(_fileName == ""){
                _fileName = path.substr(path.lastIndexOf("/") + 1);
            }

            /** fileExtension */
            if(_fileName != null){
                if(_fileName.indexOf(".") != -1){
                    _fileExtension = _fileName.substr(_fileName.lastIndexOf(".") + 1);
                }
            }
        }
    }
}