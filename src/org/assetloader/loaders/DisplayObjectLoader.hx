package org.assetloader.loaders;

import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.errors.Error;
import org.assetloader.base.Param;
import openfl.events.IEventDispatcher;
import org.assetloader.signals.LoaderSignal;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
import openfl.display.Loader;
import openfl.display.LoaderInfo;
import openfl.display.DisplayObject;

class DisplayObjectLoader extends BaseLoader {
    public var displayObject(get, never): DisplayObject;
    public var contentLoaderInfo(get, never): LoaderInfo;
    private var _displayObject : DisplayObject;

    private var _loader : Loader;

    public function new(request : URLRequest, id : String = null) {
        super(request, AssetType.DISPLAY_OBJECT, id);
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onComplete = new LoaderSignal(DisplayObject);
    }

    override private function constructLoader() : IEventDispatcher {
        _loader = new Loader();
        return _loader.contentLoaderInfo;
    }

    override private function invokeLoading() : Void {
        _loader.load(request, getParam(Param.LOADER_CONTEXT));
    }

    override public function stop() : Void {
        if (_invoked) {
            try {
                _loader.close();
            } catch (error : Error) {
            }
        }
        super.stop();
    }

    override public function destroy() : Void {
        super.destroy();
        _loader = null;
        _displayObject = null;
        _data = null;
    }

    override private function complete_handler(event : Event) : Void {
        _data = _displayObject = _loader.content;

        var testResult : String = testData(_data);

        if (testResult != "") {
            _onError.dispatch(this, ErrorEvent.ERROR, testResult);
            return;
        }

        super.complete_handler(event);
    }

    /** Error message, empty String if no error occurred. */
    private function testData(data : DisplayObject) : String {
        return !(data != null) ? "Data is not a DisplayObject." : "";
    }

    /** Gets the resulting DisplayObject after loading is complete. */
    private function get_displayObject() : DisplayObject {
        return _displayObject;
    }

    /** Gets the current content's LoaderInfo. */
    private function get_contentLoaderInfo() : LoaderInfo {
        return (_loader != null) ? _loader.contentLoaderInfo : null;
    }
}

