package org.assetloader.base;

import js.Browser;

import org.assetloader.core.*;
import org.assetloader.parsers.XmlConfigParser;
import openfl.net.URLRequest;
import openfl.utils.Dictionary;
import org.assetloader.signals.*;

using Lambda;

class AssetLoaderBase extends AbstractLoader {

    /** configParser Property */
    private var configParser(get, never):IConfigParser;
    private function get_configParser():IConfigParser {
        if (_configParser != null) {
            return _configParser;
        }

        _configParser = new XmlConfigParser();
        return _configParser;
    }

    /** numConnections Property */
    private var _numConnections : Int = 3;
    public var numConnections(get, set):Int;
    private function get_numConnections() : Int {
        return _numConnections;
    }
    private function set_numConnections(value : Int) : Int {
        _numConnections = value;
        return value;
    }

    /** ids Property */
    private var _ids : Array<Dynamic>;
    public var ids(get, never):Array<Dynamic>;
    private function get_ids() : Array<Dynamic> {
        return _ids;
    }

    /** numLoaders Property */
    private var _numLoaders : Int;
    public var numLoaders(get, never):Int;
    private function get_numLoaders() : Int {
        return _numLoaders;
    }

    /** loadedIds Property */
    private var _loadedIds : Array<Dynamic>;
    public var loadedIds(get, never):Array<Dynamic>;
    private function get_loadedIds() : Array<Dynamic> {
        return _loadedIds;
    }

    /** numLoaded Property */
    private var _numLoaded : Int;
    public var numLoaded(get, never):Int;
    private function get_numLoaded() : Int {
        return _numLoaded;
    }

    /** failedIds Property */
    private var _failedIds : Array<Dynamic>;
    public var failedIds(get, never):Array<Dynamic>;
    private function get_failedIds() : Array<Dynamic> {
        return _failedIds;
    }

    /** numFailed Property */
    private var _numFailed : Int;
    public var numFailed(get, never):Int;
    private function get_numFailed() : Int {
        return _numFailed;
    }

    /** failOnError Property */
    private var _failOnError : Bool = true;
    public var failOnError(get, set):Bool;
    private function get_failOnError() : Bool {
        return _failOnError;
    }

    private function set_failOnError(value : Bool) : Bool {
        _failOnError = value;
        return value;
    }

    /** onConfigLoaded Property */
    private var _onConfigLoaded : LoaderSignal;
    public var onConfigLoaded(get, never):LoaderSignal;
    private function get_onConfigLoaded() : LoaderSignal {
        return _onConfigLoaded;
    }

    private var _loaders : Dictionary<String, Dynamic>;

    private var _assets : Dictionary<String, Dynamic>;

    private var _loaderFactory: LoaderFactory;

    private var _configParser : IConfigParser;

    public function new(id : String) {
        _loaders = new Dictionary(true);
        _data = _assets = new Dictionary(true);
        _loaderFactory = new LoaderFactory();
        _ids = [];
        _loadedIds = [];
        _failedIds = [];
        super(id, AssetType.GROUP);
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onConfigLoaded = new LoaderSignal();
    }

    public function addLazy(id : String, url : String, type : String = "AUTO", params : Array<Dynamic> = null) : ILoader {
        return add(id, new URLRequest(url), type, params);
    }

    public function add(id : String, request : URLRequest, type : String = "AUTO", params : Array<Dynamic> = null) : ILoader {
        var loader : ILoader = _loaderFactory.produce(id, type, request, params);
        addLoader(loader);
        return loader;
    }

    public function addLoader(loader:ILoader):Void {
        if (hasLoader(loader.id)) {
            throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER_WITH_ID(_id, loader.id));
        }

        _loaders.set(loader.id, loader);
        _ids.push(loader.id);
        _numLoaders = _ids.length;

        if (loader.loaded) {
            _loadedIds.push(loader.id);
            _numLoaded = _loadedIds.length;
            _assets[loader.id] = loader.data;
        }
        else if (loader.failed) {
            _failedIds.push(loader.id);
            _numFailed = _failedIds.length;
        }

        _failed = (_numFailed > 0);
        _loaded = (_numLoaders == _numLoaded);

        if (loader.getParam(Param.PRIORITY) == 0) {
            loader.setParam(Param.PRIORITY, -(_numLoaders - 1));
        }

        loader.onStart.add(start_handler);
        updateTotalBytes();
        loader.onAddedToParent.dispatch([loader, this]);
    }

    public function remove(id : String) : ILoader {
        var loader : ILoader = getLoader(id);
        if (loader != null) {
            _ids.splice(Lambda.indexOf(_ids, id), 1);
            //This is an intentional compilation error. See the README for handling the delete keyword
            //delete _loaders[id];
            //This is an intentional compilation error. See the README for handling the delete keyword
            //delete _assets[id];

            if (loader.loaded) {
                _loadedIds.splice(Lambda.indexOf(_loadedIds, id), 1);
            }
            _numLoaded = _loadedIds.length;

            if (loader.failed) {
                _failedIds.splice(Lambda.indexOf(_failedIds, id), 1);
            }
            _numFailed = _failedIds.length;

            loader.onStart.remove(start_handler);
            removeListeners(loader);

            _numLoaders = _ids.length;
        }

        updateTotalBytes();

        loader.onRemovedFromParent.dispatch([loader, this]);

        return loader;
    }

    override public function destroy() : Void {
        var idsCopy : Array<Dynamic> = _ids.copy();
        var loader : ILoader;

        for (id in idsCopy) {
            loader = remove(id);
            loader.destroy();
        }

        super.destroy();
    }

    private function updateTotalBytes() : Void {
        var bytesTotal:Int = 0;

        _loaders.foreach((it->{
            if (!it.getParam(Param.ON_DEMAND)) {
                bytesTotal += it._stats.bytesTotal;
            }
            return true;
        }));

        _stats.bytesTotal = bytesTotal;
    }

    private function addListeners(loader : ILoader) : Void {
        if (loader != null) {
            loader.onError.add(error_handler);
            loader.onOpen.add(open_handler);
            loader.onProgress.add(progress_handler);
            loader.onComplete.add(complete_handler);
        }
    }

    private function removeListeners(loader:ILoader):Void {
        if (loader != null) {
            loader.onError.remove(error_handler);
            loader.onOpen.remove(open_handler);
            loader.onProgress.remove(progress_handler);
            loader.onComplete.remove(complete_handler);
        }
    }

    private function hasCircularReference(id:String):Bool {
        _loaders.foreach((it->{
            if (Std.is(it, AssetLoaderBase)) {
                var assetloader : AssetLoaderBase = cast((it), AssetLoaderBase);
                if (assetloader.hasLoader(id) || assetloader.hasCircularReference(id)) {
                    return true;
                }
            }
            return true;
        }));

        return false;
    }

    override private function addedToParent_handler(signal : LoaderSignal, parent : IAssetLoader) : Void {
        if (hasCircularReference(_id)) {
            throw new AssetLoaderError(AssetLoaderError.CIRCULAR_REFERENCE_FOUND(_id));
        }

        super.addedToParent_handler(signal, parent);
    }

    private function start_handler(signal : LoaderSignal) : Void {
        var loader : ILoader = signal.loader;

        loader.onStart.remove(start_handler);
        loader.onStop.add(stop_handler);

        addListeners(loader);
    }

    private function stop_handler(signal : LoaderSignal) : Void {
        var loader : ILoader = signal.loader;

        loader.onStart.add(start_handler);
        loader.onStop.remove(stop_handler);

        removeListeners(loader);
    }

    private function error_handler(signal : ErrorSignal) : Void {
        _failed = true;
        _onError.dispatch([this, signal.type, signal.message]);
    }

    private function open_handler(signal : LoaderSignal) : Void {
        _stats.open();
        _onOpen.dispatch([this]);
    }

    private function progress_handler(signal : LoaderSignal) : Void {
        _inProgress = true;

        var bytesLoaded:Int = 0;
        var bytesTotal:Int = 0;

        _loaders.foreach((it->{
            bytesLoaded += it._stats.bytesLoaded;
            bytesTotal += it._stats.bytesTotal;
            return true;
        }));

        _stats.update(bytesLoaded, bytesTotal);

        _onProgress.dispatch([this, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress,
        _stats.bytesLoaded, _stats.bytesTotal]);
    }

    private function complete_handler(signal : LoaderSignal, data : Dynamic = null) : Void {
        _loaded = (_numLoaders == _numLoaded);
        _inProgress = false;
        _stats.done();

        _onComplete.dispatch([this, data]);
    }

    public function getLoader(id : String):ILoader {
        if (hasLoader(id)) {
            return _loaders.get(id);
        }
        return null;
    }

    public function getAssetLoader(id : String) : IAssetLoader {
        if (hasAssetLoader(id)) {
            return Reflect.field(_loaders, id);
        }
        return null;
    }

    public function getAsset(id : String) : Dynamic {
        return Reflect.field(_assets, id);
    }

    override private function get_data() : Dynamic {
        return _data;
    }

    public function hasLoader(id : String) : Bool {
        return _loaders.exists(id);
    }

    public function hasAssetLoader(id : String) : Bool {
        return (_loaders.exists(id) && Std.is(Reflect.field(_loaders, id), IAssetLoader));
    }

    public function hasAsset(id : String) : Bool {
        return _assets.exists(id);
    }
}