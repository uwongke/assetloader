package org.assetloader.parsers;

import flash.net.URLVariables;

/** The URLParser is used to check whether URLs are valid or not, also it extracts useful information from the given url.
	URLs are parsed according to three groups; Absolute, Relative and Server.</p>

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
class URLParser {
    public var url(get, never) : String;
    public var protocol(get, never) : String;
    public var login(get, never) : String;
    public var password(get, never) : String;
    public var port(get, never) : Int;
    public var host(get, never) : String;
    public var path(get, never) : String;
    public var fileName(get, never) : String;
    public var fileExtension(get, never) : String;
    public var urlVariables(get, never) : URLVariables;
    public var anchor(get, never) : String;
    public var isValid(get, never) : Bool;

    private var _url : String;
    private var _protocol : String;
    private var _login : String;
    private var _password : String;
    private var _port : Int;
    private var _host : String;
    private var _path : String;
    private var _fileName : String;
    private var _fileExtension : String;
    private var _urlVariables : URLVariables;
    private var _anchor : String;
    private var _isValid : Bool = true;

    /** Parses url and breaks is down into properties and check whether the url is valid. */
    public function new(url : String) {
        _url = url;

        if (_url == null || _url == "") {
            _isValid = false;
            return;
        }

        if (_url.length >= 250) {
            _isValid = false;
            return;
        }

        var urlExp : as3hx.Compat.Regex
                = new as3hx.Compat.Regex('^(?:(?P<scheme>\\w+):\\/\\/)?(?:(?P<login>\\w+):(?P<pass>\\w+)@)?(?P<host>(?:(?P<subdomain>[\\w\\.]+)\\.)?(?P<domain>\\w+\\.(?P<extension>\\w+)))?(?::(?P<port>\\d+))?(?P<path>[\\w\\W]*\\/(?P<file>[^?]+(?:\\.\\w+)?)?)?(?:\\?(?P<arg>[\\w=&]+))?(?:#(?P<anchor>\\w+))?', "");
        var match : Dynamic = urlExp.exec(url);

        if (match != null) {
            _protocol = match.scheme || null;

            _host = match.host || null;

            _login = match.login || null;
            _password = match.pass || null;

            _port = (match.port) ? as3hx.Compat.parseInt(match.port) : 80;

            _path = match.path || null;

            if (match.arg && match.arg != "") {
                _urlVariables = new URLVariables(match.arg);
            }

            _anchor = match.anchor || null;

            if (_protocol == null && _url.indexOf("/") == -1) {
                _path = _host || _url;
                _fileName = _path.substring(-_path.lastIndexOf("/") - 1);
                _host = null;
            }

            if (_path == null || _path == "") {
                _isValid = false;
                return;
            }

            if (_path.charAt(0) != "/") {
                _path = "/" + _path;
            }

            if (_fileName == null) {
                _fileName = match.file || null;
            }

            if (_fileName != null) {
                if (_fileName.indexOf(".") != -1) {
                    _fileExtension = _fileName.substring(_fileName.lastIndexOf(".") + 1);
                }
            }

            if (_fileExtension == null && _protocol == null && _path.charAt(_path.length - 1) != "/") {
                _isValid = false;
            }
        }
        else {
            _isValid = false;
        }
    }

    /** Gets the url passes through constructor. */
    private function get_url() : String {
        return _url;
    }

    /** Gets the protocol of the url. */
    private function get_protocol() : String {
        return _protocol;
    }

    /** Gets the login/username from the url. E.g. ftp://Matan:Password@some.where.com will return Matan. */
    private function get_login() : String {
        return _login;
    }

    /** Gets the password from the url. E.g. ftp://Matan:Password@some.where.com will return Password. */
    private function get_password() : String {
        return _password;
    }

    /** Gets the port of the url. */
    private function get_port() : Int {
        return _port;
    }

    /** Gets the host of the url. E.g. www.matanuberstein.co.za */
    private function get_host() : String {
        return _host;
    }

    /** Gets the path of the url. E.g. some/path/to/file/ */
    private function get_path() : String {
        return _path;
    }

    /** Gets the file name of the url. E.g. someFileName.ext */
    private function get_fileName() : String {
        return _fileName;
    }

    /** Gets the file extension of the url. E.g. txt, php, etc. */
    private function get_fileExtension() : String {
        return _fileExtension;
    }

    /** Gets the url variables from the url. */
    private function get_urlVariables() : URLVariables {
        return _urlVariables;
    }

    /** Gets the file hash anchor of the url. E.g. www.matanuberstein.co.za/#hello will return hello. */
    private function get_anchor() : String {
        return _anchor;
    }

    /** Gets whether the url is valid or not. E.g. if a empty path is passed isValid will be false. */
    private function get_isValid() : Bool {
        return _isValid;
    }
}
