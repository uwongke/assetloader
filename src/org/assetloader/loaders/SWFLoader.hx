package org.assetloader.loaders;

import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.IEventDispatcher;
import openfl.net.URLRequest;
import openfl.system.LoaderContext;
import openfl.system.SecurityDomain;
import org.assetloader.base.AssetType;
import org.assetloader.base.Param;
import org.assetloader.signals.LoaderSignal;

class SWFLoader extends DisplayObjectLoader {
    public var swf(get, never):Sprite;
    public var onInit(get, never):LoaderSignal;

    private var _swf : Sprite;

    private var _onInit : LoaderSignal;

    public function new(request : URLRequest, id : String = null) {
        super(request, id);
        _type = AssetType.SWF;
        addParam(new Param(Param.LOADER_CONTEXT, new LoaderContext(false, null, SecurityDomain.currentDomain)));
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onInit = new LoaderSignal();
        _onComplete = new LoaderSignal([Sprite]);
    }

    private function init_handler(event : Event) : Void {
        _data = _displayObject = _loader.content;

        _onInit.dispatch([this, _data]);
    }

    override private function addListeners(dispatcher : IEventDispatcher) : Void {
        super.addListeners(dispatcher);
        if (dispatcher != null) {
            dispatcher.addEventListener(Event.INIT, init_handler);
        }
    }

    override private function removeListeners(dispatcher : IEventDispatcher) : Void {
        super.removeListeners(dispatcher);
        if (dispatcher != null) {
            dispatcher.removeEventListener(Event.INIT, init_handler);
        }
    }

    override public function destroy():Void {
        super.destroy();
        _swf = null;
    }

    override private function testData(data : DisplayObject) : String {
        var errMsg : String = "";
        try {
            _data = _swf = cast((data), Sprite);
        } catch (error : Error) {
            errMsg = error.message;
        }
        return errMsg;
    }

    /** Gets the resulting Sprite after loading is complete. */
    private function get_swf() : Sprite {
        return _swf;
    }

    /** Dispatched when the properties and methods of a loaded SWF file are accessible and ready for use. */
    private function get_onInit() : LoaderSignal {
        return _onInit;
    }
}
