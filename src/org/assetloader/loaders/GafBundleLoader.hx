package org.assetloader.loaders;

import engine.ShellApi;
import org.assetloader.signals.ErrorSignal;
import openfl.display.Sprite;
import openfl.events.ErrorEvent;
import openfl.gafplayer.GafFactory;
import openfl.gafplayer.GafZipBundle;
import openfl.utils.ByteArray;
import openfl.net.URLStream;
import openfl.display.DisplayObject;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.net.URLRequest;
import org.assetloader.base.AssetType;
import org.assetloader.base.Param;
import org.assetloader.signals.LoaderSignal;

using org.assetloader.loaders.LoaderUtil;

class GafBundleLoader extends BaseLoader {
    private var _loader:URLStream;
	private var _largeAsset:Bool = false;

    public var swf(get, never):Sprite;

    private var _swf:Sprite;
    private var _shellApi:ShellApi;
    ///////////////TODO: remove temporary caching. Global cache system must work///////////
    private static var temp_cache:Map<String, GafFactory> = new Map<String, GafFactory>();
    private static var items_to_cache:Array<String> = [
        //        "game/assets/ui/toolTip/navigationArrow.swf",
        //        "game/assets/ui/toolTip/exitPointer3D.swf",
        //        "game/assets/entity/character/mouth/1.swf",
        //        "game/assets/entity/character/mouth/ooh.swf",
        //        "game/assets/ui/toolTip/clickPointer.swf"
    ];

    //////////////////////////////////////////////////////////////////////
    private var _origURl:String = null;

    public function new(request:URLRequest, id:String = null,shell:ShellApi=null) {
        _origURl = request.url;
        _shellApi = shell;
        if(shell != null) {
            if(shell.useLargeAssets && request.url.indexOf("eyes") == -1)
            {
                if(request.url.indexOf("/character/") != -1 || request.url.indexOf("/pet_babyquad/") != -1){
                    request.url = request.url.substring(0, request.url.length - 4) + "_gaflarge" + request.url.substring(request.url.length - 4, request.url.length);
					_largeAsset = true;
                    //trace("REQUEST: " + request.url);
                }

            }
     }
        // temp_cache = new Map<String, Sprite>();
        var newReq = new URLRequest(StringTools.replace(request.url, '.swf', '.zip'));
        super(newReq, AssetType.SWF, id);
        // RLH: disable cache busting
        setPreventCache(false);
    }

    override private function initSignals():Void {
        super.initSignals();
        _onComplete = new LoaderSignal([String]);
    }

    override private function constructLoader():IEventDispatcher {
        _loader = new URLStream();
        return _loader;
    }

    override private function invokeLoading():Void {
         _loader.load(request);
        // error_handler(null);
    }

    override public function stop():Void {
        if (_invoked) {
            try {
                _loader.close();
            } catch (error:Error) {}
        }
        super.stop();
    }

    override public function destroy():Void {
        super.destroy();
        _loader = null;
    }

    override private function complete_handler(event:Event):Void {
        var bytes:ByteArray = new ByteArray();
        _loader.readBytes(bytes);
        if (bytes.length == 0) {
            _onError.dispatch([this, ErrorEvent.ERROR, null]);
            return;
        }
        var gb:GafZipBundle = new GafZipBundle();
        gb.name = _origURl;
		if ( _largeAsset ) gb.name += "_large";
        gb.init(bytes).onComplete(onCompleteGafBundle);
    }

    /**
     *  Error while loading .zip
    **/
    // don't load bundle if zip not found
    /*
    override function error_handler(event:ErrorEvent):Void {
        trace(" Error loading gaf .zip: " + event);
        var swfLoader:SWFBundleLoader = new SWFBundleLoader(new URLRequest(StringTools.replace(request.url, '.zip', '.bundle')), id);
        swfLoader.onComplete.addOnce(swfCompleteHandler);
        swfLoader.onError.addOnce(swfErrorHandler);
        swfLoader.start();
    }
    */

    override function error_handler(event:ErrorEvent):Void {
        trace(" Error loading gaf .zip: " + event);
        super.complete_handler(null);
    }

    function swfErrorHandler(signal:ErrorSignal):Void {
        trace("Error loading .swf: " + signal.loader.request.url);
        super.error_handler(new ErrorEvent(signal.type, false, false, signal.message));
    }

    function swfCompleteHandler(signal:LoaderSignal, data:Dynamic = null):Void {
        trace("swf loading complete: " + signal.loader.request.url);
        _data = data;
        super.complete_handler(null);
    }

    private function onCompleteGafBundle(gb:GafZipBundle):Void {
        //trace("gf.zip loading complete: " + request.url);
        var gf:GafFactory = new GafFactory();
        gf.intiFromZipBundle(gb, _largeAsset);
        _data = gf;
        /*
        var spr = gf.getSprite("rootTimeline", false, 30, true);
        spr.gotoAndStop(1);
        _data = spr;
        gf.destroy();
        //trace("BUNDLELOADER: data: " + _data);
        if (true || items_to_cache.indexOf(_origURl) >= 0) {
            // temp_cache[_origURl] = gf;
            // temp_cache[_origURl] = _data;
        }
        */
        super.complete_handler(null);
    }

    private function get_swf():Sprite {
        return _swf;
    }
}
