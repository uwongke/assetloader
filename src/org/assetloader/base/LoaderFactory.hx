package org.assetloader.base;

/** LoaderFactory purely generates ILoader instances. */

/** Hosted in this Library for now.  TODO@WOlfie -> Discuss with @Michael */

import org.assetloader.core.IParam;
import org.assetloader.loaders.XMLLoader;
import org.assetloader.core.ILoader;
import org.assetloader.parsers.URLParser;

import com.poptropica.interfaces.IPlatform;
import openfl.net.URLRequest;

import js.Browser;

using Lambda;

class LoaderFactory {

    /** Loader Property */
    private var _loader: AbstractLoader;
    @:isvar public var loader(get, set):AbstractLoader;
    public function get_loader(): AbstractLoader {
        return _loader;
    }
    public function set_loader(value: AbstractLoader):AbstractLoader {
        return _loader = value;
    }

    private var _platform : IPlatform;

    public function new(platform : IPlatform) {
        _platform = platform;
    }

    /** Produces an ILoader instance according to parameters passed. */
    public function produce(id: String = null, type : String = "AUTO", request : URLRequest = null,
                            params: Array<Dynamic> = null): ILoader {

        params = switch(params) {
            case null: new Array<Dynamic>();
            default: params;
        }

        if (request != null) {
            var urlParser : URLParser = new URLParser(request.url);
            if (urlParser.isValid) {
                if (type == AssetType.AUTO) {
                    type = getTypeFromExtension(urlParser.fileExtension);
                }
            }
            else {
                trace("invalid URL: " + request.url);
                throw new AssetLoaderError(AssetLoaderError.INVALID_URL);
            }
        }
        else if (type == AssetType.AUTO) {
            type = AssetType.GROUP;
        }

        constructLoader(type, id, request);


        if (params != null) {
            processParams(params);
        }

        return loader;
    }

    private function processParams(assetParams : Array<Dynamic>) : Void {
        Browser.console.log("/////////////////////processParams");
        var pL: Int = assetParams.length;
       // Browser.console.log(pL);
        //var i: Int = 0;

        Browser.console.log(loader);

        assetParams.foreach((item)->{
            if (Std.is(item, IParam)) {
                var param : IParam = item;
                //_loader.setParam(param.id, param.value);

                Browser.console.log(item);
            }
            return true;
        });

        //for (i in 0...pL) {
            //Browser.console.log(assetParams[i]);
        //    if (Std.is(assetParams[i], IParam)) {
        //        var param : IParam = assetParams[i];
        //        _loader.setParam(param.id, param.value);
        //    }
        //    else if (Std.is(assetParams[i], Array)) {
        //        processParams(assetParams[i]);
        //    }
        //}
    }

    private function getTypeFromExtension(extension : String) : String {
        extension = extension == null ? "" : extension.toLowerCase();
        //if (extension == null || extension == "") {
        //    extension = "xml";
        //}

        extension = extension.toLowerCase();

        //Browser.console.log("===================");
        //Browser.console.log(extension);

        var textExt: Array<Dynamic> = ["txt", "js", "html", "htm", "php", "asp", "aspx", "jsp", "cfm"];
        var imageExt: Array<Dynamic> = ["jpg", "jpeg", "png", "gif"];
        var videoExt: Array<Dynamic> = ["flv", "f4v", "f4p", "mp4", "mov"];

        switch(extension){
            case "json": return AssetType.JSON;
            case "xml":  return AssetType.XML;
            case "css":  return AssetType.CSS;
            case "zip":  return AssetType.BINARY;
            case "swf": return AssetType.SWF;
            case "mp3": return AssetType.SOUND;
            case "": return AssetType.GROUP;
            default: {
                if (testExtenstion(textExt, extension)) {
                    return AssetType.TEXT;
                }

                if (testExtenstion(imageExt, extension)) {
                    return AssetType.IMAGE;
                }

                if (testExtenstion(videoExt, extension)) {
                    return AssetType.VIDEO;
                }
            }
        }

        throw new AssetLoaderError(AssetLoaderError.ASSET_AUTO_TYPE_NOT_FOUND);

        return "";
    }

    private function testExtenstion(extensions : Array<Dynamic>, extension : String) : Bool {
        if (Lambda.indexOf(extensions, extension) != -1) {
            return true;
        }
        return false;
    }

    private function constructLoader(type : String, id : String, request : URLRequest) : Void {
        Browser.console.log("=========constructLoader===============");
        Browser.console.log(type);
        switch (type) {
            case AssetType.XML:
                loader = new XMLLoader(request, id);
            case AssetType.GROUP:
                _loader = new AssetLoader(null, id);

            //case AssetType.SWF:
                /** rlh temp for Haxe */
            //    _loader = new SWFLoader(request, id);

            //case AssetType.SOUND:
            //    _loader = new SoundLoader(request, id);
            //default:
            //    throw new AssetLoaderError(AssetLoaderError.ASSET_TYPE_NOT_RECOGNIZED);
        }
        //Browser.console.log(_loader);
    }
}
