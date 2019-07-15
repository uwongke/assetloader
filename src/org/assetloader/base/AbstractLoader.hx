package org.assetloader.base;

import org.assetloader.core.IParam;
import org.assetloader.core.IAssetLoader;
import haxe.Constraints.Function;
import org.assetloader.signals.ProgressSignal;
import org.assetloader.signals.HttpStatusSignal;
import org.assetloader.signals.LoaderSignal;
import org.assetloader.signals.ErrorSignal;
import openfl.net.URLRequest;
import org.assetloader.core.ILoadStats;
import org.assetloader.core.ILoader;

class AbstractLoader implements ILoader {
    public var parent(get, never) : ILoader;
    public var stats(get, never) : ILoadStats;
    public var invoked(get, never) : Bool;
    public var inProgress(get, never) : Bool;
    public var stopped(get, never) : Bool;
    public var loaded(get, never) : Bool;
    public var data(get, never) : Dynamic;
    public var id(get, never) : String;
    public var request(get, never) : URLRequest;
    public var type(get, never) : String;
    public var params(get, never) : Dynamic;
    public var retryTally(get, never) : Int;
    public var failed(get, never) : Bool;
    public var onError(get, never) : ErrorSignal;
    public var onHttpStatus(get, never) : HttpStatusSignal;
    public var onOpen(get, never) : LoaderSignal;
    public var onProgress(get, never) : ProgressSignal;
    public var onComplete(get, never) : LoaderSignal;
    public var onAddedToParent(get, never) : LoaderSignal;
    public var onRemovedFromParent(get, never) : LoaderSignal;
    public var onStart(get, never) : LoaderSignal;
    public var onStop(get, never) : LoaderSignal;

    public var callback : Function;
    public var callbackArgs : Array<Dynamic>;
    public var fallbackPrefix : String;
    public var cache : Bool;

    private var _onError : ErrorSignal;

    private var _onHttpStatus : HttpStatusSignal;

    private var _onOpen : LoaderSignal;

    private var _onProgress : ProgressSignal;

    private var _onComplete : LoaderSignal;

    private var _onAddedToParent : LoaderSignal;

    private var _onRemovedFromParent : LoaderSignal;

    private var _onStart : LoaderSignal;

    private var _onStop : LoaderSignal;

    private var _id : String;

    private var _type : String;

    private var _parent : ILoader;

    private var _request : URLRequest;

    private var _stats : ILoadStats;

    private var _params : Dynamic;

    private var _retryTally : Int;

    private var _invoked : Bool;

    private var _inProgress : Bool;

    private var _stopped : Bool;

    private var _loaded : Bool;

    private var _failed : Bool;

    private var _data : Dynamic;

    public function new(id : String, type : String, request : URLRequest = null) {
        _id = id;
        _type = type;
        _request = request;

        _stats = new LoaderStats();

        initParams();
        initSignals();
    }

    private function initParams() : Void {
        _params = { };

        setParam(Param.PRIORITY, 0);
        setParam(Param.RETRIES, 3);
        setParam(Param.ON_DEMAND, false);
        setParam(Param.WEIGHT, 0);
    }

    private function initSignals() : Void {
        _onError = new ErrorSignal();
        _onHttpStatus = new HttpStatusSignal();

        _onOpen = new LoaderSignal();
        _onProgress = new ProgressSignal();
        _onComplete = new LoaderSignal();

        _onAddedToParent = new LoaderSignal(IAssetLoader);
        _onRemovedFromParent = new LoaderSignal(IAssetLoader);

        _onAddedToParent.add(addedToParent_handler);
        _onRemovedFromParent.add(removedFromParent_handler);

        _onStart = new LoaderSignal();
        _onStop = new LoaderSignal();
    }

    public function start() : Void {
        _stats.start();
        _onStart.dispatch(this);
    }

    public function stop() : Void {
        _stopped = true;
        _inProgress = false;
        _onStop.dispatch(this);
    }

    public function destroy() : Void {
        stop();

        _stats.reset();

        _data = null;

        _invoked = false;
        _inProgress = false;
        _stopped = false;
        _loaded = false;
    }

    private function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader) : Void {
        if (_parent != null) {
            throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINED_BY_OTHER(_id, _parent.id));
        }

        _parent = parent;

        /** Inherit prevent cache from parent if undefined */
        if (Reflect.field(_params, Std.string(Param.PREVENT_CACHE)) == null) {
            setParam(Param.PREVENT_CACHE, _parent.getParam(Param.PREVENT_CACHE));
        }

        /** Inherit base from parent if undefined */
        if (Reflect.field(_params, Std.string(Param.BASE)) == null
            || Reflect.field(_params, Std.string(Param.BASE)) == null) {

            setParam(Param.BASE, _parent.getParam(Param.BASE));
        }
    }

    private function removedFromParent_handler(signal : LoaderSignal, parent : IAssetLoader) : Void {
        _parent = null;
    }

    private function get_parent() : ILoader {
        return _parent;
    }

    private function get_stats() : ILoadStats {
        return _stats;
    }

    private function get_invoked() : Bool {
        return _invoked;
    }

    private function get_inProgress() : Bool {
        return _inProgress;
    }

    private function get_stopped() : Bool {
        return _stopped;
    }

    private function get_loaded() : Bool {
        return _loaded;
    }

    private function get_data() : Dynamic {
        return _data;
    }

    public function hasParam(id : String) : Bool {
        if (_parent != null) {
            return (Reflect.field(_params, id) != null) || parent.hasParam(id);
        }
        return (Reflect.field(_params, id) != null);
    }

    public function setParam(id : String, value : Dynamic) : Void {
        Reflect.setField(_params, id, value);

        switch (id) {
            case Param.WEIGHT:
                _stats.bytesTotal = value;
        }
    }

    public function getParam(id : String) : Dynamic {
        if (_parent != null && Reflect.field(_params, id) == null) {
            return parent.getParam(id);
        }
        return Reflect.field(_params, id);
    }

    public function addParam(param : IParam) : Void {
        setParam(param.id, param.value);
    }

    private function get_id() : String {
        return _id;
    }

    private function get_request() : URLRequest {
        return _request;
    }

    private function get_type() : String {
        return _type;
    }

    private function get_params() : Dynamic {
        return _params;
    }

    private function get_retryTally() : Int {
        return _retryTally;
    }

    private function get_failed() : Bool {
        return _failed;
    }

    private function get_onError() : ErrorSignal {
        return _onError;
    }

    private function get_onHttpStatus() : HttpStatusSignal {
        return _onHttpStatus;
    }

    private function get_onOpen() : LoaderSignal {
        return _onOpen;
    }

    private function get_onProgress() : ProgressSignal {
        return _onProgress;
    }

    private function get_onComplete() : LoaderSignal {
        return _onComplete;
    }

    private function get_onAddedToParent() : LoaderSignal {
        return _onAddedToParent;
    }

    private function get_onRemovedFromParent() : LoaderSignal {
        return _onRemovedFromParent;
    }

    private function get_onStart() : LoaderSignal {
        return _onStart;
    }

    private function get_onStop() : LoaderSignal {
        return _onStop;
    }
}