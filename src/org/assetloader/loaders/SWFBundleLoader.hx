package org.assetloader.loaders;

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

class SWFBundleLoader extends BaseLoader {
    public var onInit(get, never):LoaderSignal;

    private var _onInit:LoaderSignal;

    private function get_onInit():LoaderSignal {
        return _onInit;
    }

    public var swf(get, never):DisplayObject;

    private var _swf:DisplayObject;

    function get_swf():DisplayObject {
        return _swf;
    }

    private var _loader:Loader;

    public function new(request:URLRequest, id:String = null) {
        super(new URLRequest(StringTools.replace(request.url, '.swf', '.bundle')), AssetType.SWF, id);
    }

    override private function constructLoader():IEventDispatcher {
        _loader = new Loader();
        return _loader.contentLoaderInfo;
    }

    override private function invokeLoading():Void {
        _loader.load(request, getParam(Param.LOADER_CONTEXT));
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

    override private function initSignals():Void {
        super.initSignals();
        _onInit = new LoaderSignal();
        _onComplete = new LoaderSignal([DisplayObject]);
    }

    override private function complete_handler(event:Event):Void {
        _swf = _loader.content;
        super.complete_handler(event);
    }
}
