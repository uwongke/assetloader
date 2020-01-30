package org.assetloader.loaders;

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

    public var swf(get, never):Sprite;

    private var _swf:Sprite;

    //////////////////////////////////////////////////////////////////////
    private var _origURl:String = null;

    public function new(request:URLRequest, id:String = null) {
        _origURl = request.url;
        var newReq = new URLRequest(StringTools.replace(request.url, '.swf', '.zip'));
        super(newReq, AssetType.SWF, id);
        setPreventCache(true);
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
        gb.init(bytes).onComplete(onCompleteGafBundle);
    }

    /**
     *  Error while loading .zip
    **/
    override function error_handler(event:ErrorEvent):Void {
        trace(" Error loading gaf .zip: " + event);
        var swfLoader:SWFBundleLoader = new SWFBundleLoader(new URLRequest(StringTools.replace(request.url, '.zip', '.bundle')), id);
        swfLoader.onComplete.addOnce(swfCompleteHandler);
        swfLoader.onError.addOnce(swfErrorHandler);
        swfLoader.start();
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
        trace("gf.zip loading complete: " + request.url);

        var gf:GafFactory = new GafFactory();
        gf.intiFromZipBundle(gb);
        var spr = gf.getSprite("rootTimeline", false, 30, true);
        spr.gotoAndStop(1);
        _data = spr;
        super.complete_handler(null);
    }

    private function get_swf():Sprite {
        return _swf;
    }
}
