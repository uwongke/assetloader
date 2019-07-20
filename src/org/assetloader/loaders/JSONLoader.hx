package org.assetloader.loaders;

import haxe.Json;
import openfl.errors.Error;

import org.assetloader.signals.LoaderSignal;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
import openfl.utils.Object;

class JSONLoader extends TextLoader {
    private var _jsonObject : Object;


    public function new(request:URLRequest, id:String = null) {
        super(request, id);
        _type = AssetType.JSON;
    }

    override private function initSignals(): Void {
        super.initSignals();
        _onComplete = new LoaderSignal([Object]);
    }

    override public function destroy():Void {
        super.destroy();
        _jsonObject = null;
    }

    override private function testData(data : String) : String {
        var errMsg : String = "";
        try {
            _data = _jsonObject = Json.parse(data);
        }
        catch(err : Error) {
            errMsg = err.message;
        }

        return errMsg;
    }

    public var jsonObject(get, never): Object;
    public function get_jsonObject(): Object {
        return _jsonObject;
    }
}