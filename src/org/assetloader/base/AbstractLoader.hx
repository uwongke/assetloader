package org.assetloader.base;

import org.assetloader.core.IAssetLoader;
import org.assetloader.signals.HttpStatusSignal;
import org.assetloader.signals.ProgressSignal;
import org.assetloader.signals.LoaderSignal;
import org.assetloader.signals.ErrorSignal;
import org.assetloader.core.IParam;
import haxe.Constraints.Function;

//import org.assetloader.core.IParam;
//import org.assetloader.core.IAssetLoader;
//import org.assetloader.signals.ProgressSignal;
//import org.assetloader.signals.HttpStatusSignal;
//import org.assetloader.signals.LoaderSignal;
//import org.assetloader.signals.ErrorSignal;
import org.assetloader.core.ILoadStats;
import org.assetloader.core.ILoader;

import openfl.net.URLRequest;

class AbstractLoader implements ILoader {

    /** parent Property */
    public var parent(get, never):ILoader;
    private function get_parent():ILoader {
        return _parent;
    }

    /** stats Property */
    public var stats(get, never):ILoadStats;
    private function get_stats():ILoadStats {
        return _stats;
    }

    /** invoked Property */
    public var invoked(get, never):Bool;
    private function get_invoked():Bool {
        return _invoked;
    }

    /** inProgress Property */
    public var inProgress(get, never):Bool;
    private function get_inProgress():Bool {
        return _inProgress;
    }

    /** stopped Property */
    public var stopped(get, never):Bool;
    private function get_stopped():Bool {
        return _stopped;
    }

    /** loaded Property */
    public var loaded(get, never):Bool;
    private function get_loaded():Bool {
        return _loaded;
    }

    /** data Property */
    public var data(get, never):Dynamic;
    private function get_data():Dynamic {
        return _data;
    }

    /** id Property */
    public var id(get, never):String;
    private function get_id():String {
        return _id;
    }

    /** request Property */
    public var request(get, never):URLRequest;
    private function get_request():URLRequest {
        return _request;
    }

    /** type Property */
    public var type(get, never):String;
    private function get_type():String {
        return _type;
    }

    /** params Property */
    public var params(get, never):Dynamic;
    private function get_params():Dynamic {
        return _params;
    }

    /** retryTally Property */
    public var retryTally(get, never):Int;
    private function get_retryTally():Int {
        return _retryTally;
    }

    /** failed Property */
    public var failed(get, never):Bool;
    private function get_failed():Bool {
        return _failed;
    }

    /** onError Property */
    public var onError(get, never):ErrorSignal;
    private function get_onError():ErrorSignal {
        return _onError;
    }

    /** onHttpStatus Property */
    public var onHttpStatus(get, never):HttpStatusSignal;
    private function get_onHttpStatus():HttpStatusSignal {
        return _onHttpStatus;
    }

    /** onOpen Property */
    public var onOpen(get, never):LoaderSignal;
    private function get_onOpen():LoaderSignal {
        return _onOpen;
    }

    /** onProgress Property */
    public var onProgress(get, never):ProgressSignal;
    private function get_onProgress():ProgressSignal {
        return _onProgress;
    }

    /** onComplete Property */
    public var onComplete(get, never):LoaderSignal;
    private function get_onComplete() : LoaderSignal {
        return _onComplete;
    }

    /** onAddedToParent Property */
    public var onAddedToParent(get, never):LoaderSignal;
    private function get_onAddedToParent() : LoaderSignal {
        return _onAddedToParent;
    }

    /** onRemovedFromParent Property */
    public var onRemovedFromParent(get, never) : LoaderSignal;
    private function get_onRemovedFromParent() : LoaderSignal {
        return _onRemovedFromParent;
    }

    /** onStart Property */
    public var onStart(get, never) : LoaderSignal;
    private function get_onStart() : LoaderSignal {
        return _onStart;
    }

    /** onStop Property */
    public var onStop(get, never) : LoaderSignal;
    private function get_onStop() : LoaderSignal {
        return _onStop;
    }

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

        //initParams();
        //initSignals();
    }

    private function initParams():Void {
    //    _params = { };

    //    setParam(Param.PRIORITY, 0);
    //    setParam(Param.RETRIES, 3);
    //    setParam(Param.ON_DEMAND, false);
    //    setParam(Param.WEIGHT, 0);
    }

    private function initSignals():Void {
    //    _onError = new ErrorSignal();
    //    _onHttpStatus = new HttpStatusSignal();

    //    _onOpen = new LoaderSignal();
    //    _onProgress = new ProgressSignal();
    //    _onComplete = new LoaderSignal();

    //    _onAddedToParent = new LoaderSignal([IAssetLoader]);
    //    _onRemovedFromParent = new LoaderSignal([IAssetLoader]);

    //    _onAddedToParent.add(addedToParent_handler);
    //    _onRemovedFromParent.add(removedFromParent_handler);

    //    _onStart = new LoaderSignal();
    //    _onStop = new LoaderSignal();
    }

    public function start():Void {
    //    _stats.start();
    //    _onStart.dispatch(this);
    }

    public function stop() : Void {
    //    _stopped = true;
    //    _inProgress = false;
    //    _onStop.dispatch(this);
    }

    public function destroy():Void {
    //    stop();

    //    _stats.reset();

    //    _data = null;

    //    _invoked = false;
    //    _inProgress = false;
    //    _stopped = false;
    //    _loaded = false;
    }

    private function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader):Void {
    //    if (_parent != null) {
    //        throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINED_BY_OTHER(_id, _parent.id));
    //    }

    //    _parent = parent;

        /** Inherit prevent cache from parent if undefined */
    //    if (Reflect.field(_params, Std.string(Param.PREVENT_CACHE)) == null) {
    //        setParam(Param.PREVENT_CACHE, _parent.getParam(Param.PREVENT_CACHE));
    //    }

        /** Inherit base from parent if undefined */
    //    if (Reflect.field(_params, Std.string(Param.BASE)) == null
    //        || Reflect.field(_params, Std.string(Param.BASE)) == null) {

    //        setParam(Param.BASE, _parent.getParam(Param.BASE));
    //    }
    }

    private function removedFromParent_handler(signal : LoaderSignal, parent : IAssetLoader) : Void {
    //    _parent = null;
    }


    public function hasParam(id: String):Bool {
    //    if (_parent != null) {
    //        return (Reflect.field(_params, id) != null) || parent.hasParam(id);
    //    }
    //    return (Reflect.field(_params, id) != null);
        return true;
    }

    public function setParam(id: String, value: Dynamic): Void {
    //    Reflect.setField(_params, id, value);

    //    switch (id) {
    //        case Param.WEIGHT:
    //            _stats.bytesTotal = value;
    //    }
    }

    public function getParam(id : String):Dynamic {
    //    if (_parent != null && Reflect.field(_params, id) == null) {
    //        return parent.getParam(id);
    //    }
    //    return Reflect.field(_params, id);
        return null;
    }

    public function addParam(param : IParam):Void {
        //setParam(param.id, param.value);
    }
}