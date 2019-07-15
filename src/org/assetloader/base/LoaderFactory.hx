package org.assetloader.base;

/** LoaderFactory purely generates ILoader instances. */
import com.poptropica.interfaces.IPlatform; /** Hosted in this Library for now.  TODO@WOlfie -> Discuss with @Michael */

import org.assetloader.core.ILoader;
import org.assetloader.parsers.URLParser;
import org.assetloader.loaders.SoundLoader;
import org.assetloader.loaders.SWFLoader;
import org.assetloader.loaders.XMLLoader;
import openfl.net.URLRequest;
import org.assetloader.core.IParam;

class LoaderFactory {
    private var _loader : AbstractLoader;
    private var _platform : IPlatform;

    public function new(platform : IPlatform) {
        _platform = platform;
    }

    /** Produces an ILoader instance according to parameters passed. */
    public function produce(id : String = null, type : String = "AUTO", request : URLRequest = null,
                            params : Array<Dynamic> = null) : ILoader {
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

        return _loader;
    }

    private function processParams(assetParams : Array<Dynamic>) : Void {
        var pL : Int = assetParams.length;
        for (i in 0...pL) {
            if (Std.is(assetParams[i], IParam)) {
                var param : IParam = assetParams[i];
                _loader.setParam(param.id, param.value);
            }
            else if (Std.is(assetParams[i], Array)) {
                processParams(assetParams[i]);
            }
        }
    }

    private function getTypeFromExtension(extension : String) : String {
        if (extension == null) {
            extension = "";
        }

        extension = extension.toLowerCase();

        var textExt : Array<Dynamic> = ["txt", "js", "html", "htm", "php", "asp", "aspx", "jsp", "cfm"];
        var imageExt : Array<Dynamic> = ["jpg", "jpeg", "png", "gif"];
        var videoExt : Array<Dynamic> = ["flv", "f4v", "f4p", "mp4", "mov"];

        if (testExtenstion(textExt, extension)) {
            return AssetType.TEXT;
        }

        if (extension == "json") {
            return AssetType.JSON;
        }

        if (extension == "xml") {
            return AssetType.XML;
        }

        if (extension == "css") {
            return AssetType.CSS;
        }

        if (extension == "zip") {
            return AssetType.BINARY;
        }

        if (extension == "swf") {
            return AssetType.SWF;
        }

        if (testExtenstion(imageExt, extension)) {
            return AssetType.IMAGE;
        }

        if (extension == "mp3") {
            return AssetType.SOUND;
        }

        if (testExtenstion(videoExt, extension)) {
            return AssetType.VIDEO;
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
        switch (type) {
            case AssetType.XML:
                _loader = new XMLLoader(request, id);

            case AssetType.SWF:
                /** rlh temp for Haxe */
                _loader = new SWFLoader(request, id);

            case AssetType.SOUND:
                _loader = new SoundLoader(request, id);
            default:
                throw new AssetLoaderError(AssetLoaderError.ASSET_TYPE_NOT_RECOGNIZED);
        }
    }
}
