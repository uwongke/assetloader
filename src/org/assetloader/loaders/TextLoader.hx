package org.assetloader.loaders;

import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.utils.ByteArray;
import openfl.errors.Error;
import openfl.events.IEventDispatcher;
import openfl.net.URLRequest;
import openfl.net.URLStream;

import org.assetloader.signals.LoaderSignal;
import org.assetloader.base.AssetType;

class TextLoader extends BaseLoader {

    private var _loader : URLStream;

    public function new(request : URLRequest, id : String = null) {
        super(request, AssetType.TEXT, id);
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onComplete = new LoaderSignal([String]);
    }

    override private function constructLoader() : IEventDispatcher {
        _loader = new URLStream();
        return _loader;
    }

    override private function invokeLoading() : Void {
        _loader.load(request);
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
    }

    override private function complete_handler(event : Event) : Void {
        var bytes : ByteArray = new ByteArray();
        _loader.readBytes(bytes);

        _data = Std.string(bytes);

        var testResult : String = testData(_data);

        if (testResult != "") {
            _onError.dispatch([this, ErrorEvent.ERROR, testResult]);
            return;
        }

        super.complete_handler(event);
    }

    /** @return Error message, empty string if no error occurred. */
    private function testData(data : String) : String {
        return (data == null) ? "Data loaded is null." : "";
    }
}

