package org.assetloader;

import openfl.errors.Error;
import openfl.net.URLRequest;

import com.poptropica.interfaces.IPlatform;

import org.assetloader.base.*;
import org.assetloader.parsers.URLParser;
import org.assetloader.core.*;
import org.assetloader.signals.*;

class AssetLoader extends AssetLoaderBase implements IAssetLoader {

    private var _onChildOpen:LoaderSignal;
    private var _onChildError:ErrorSignal;
    private var _onChildComplete:LoaderSignal;

    public function new(platform:IPlatform, id : String = "") {
        super(platform, id);
    }

    override function initSignals():Void {
        super.initSignals();
        _onChildOpen = new LoaderSignal([ILoader]);
        _onChildError = new ErrorSignal([ILoader]);
        _onChildComplete = new LoaderSignal([ILoader]);
    }

    override public function start():Void {
        _data = _assets;
        _invoked = true;
        _stopped = false;

        //sortIdsByPriority();

        if(numConnections == 0)
            numConnections = _numLoaders;

        super.start();

        for (k in 0...numConnections){
            startNextLoader();
        }
    }

    public function startLoader(id : String):Void {
        var loader:ILoader = getLoader(id);
        if(loader != null){
            loader.start();
        }
        updateTotalBytes();
    }

    override public function stop():Void {
        var loader : ILoader;

        for (i in 0..._numLoaders){
            loader = getLoader(_ids[i]);

            if(!loader.loaded){
                loader.stop();
            }
        }

        super.stop();
    }

    private function startNextLoader():Void {
        if(_invoked) {
            var loader : ILoader;
            var ON_DEMAND : String = Param.ON_DEMAND;

            for (i in 0..._numLoaders){
                loader = getLoader(_ids[i]);
                if(!loader.loaded && !loader.failed && !loader.getParam(ON_DEMAND)) {
                    if(!loader.invoked || (loader.invoked && loader.stopped)) {
                        startLoader(loader.id);
                        return;
                    }
                }
            }
        }
    }

    private function checkForComplete(signal:LoaderSignal):Void {
        var sum:Int = _failOnError ? _numLoaded : _numLoaded + _numFailed;
        if(sum == _numLoaders){
            super.complete_handler(signal, _assets);
        }
        else {
            startNextLoader();
        }
    }

    override function open_handler(signal:LoaderSignal):Void {
        _inProgress = true;
        _onChildOpen.dispatch([this, signal.loader]);
        super.open_handler(signal);
    }

    override function error_handler(signal : ErrorSignal):Void {
        var loader : ILoader = signal.loader;

        _failedIds.push(loader.id);
        _numFailed = _failedIds.length;

        _onChildError.dispatch([this, signal.type, signal.message, loader]);
        super.error_handler(signal);

        if(!_failOnError){
            checkForComplete(signal);
        }
        else {
            startNextLoader();
        }
    }

    override function complete_handler(signal:LoaderSignal, data:Dynamic = null):Void {
        var loader : ILoader = signal.loader;

        removeListeners(loader);

        _assets[loader.id] = loader.data;
        _loadedIds.push(loader.id);
        _numLoaded = _loadedIds.length;

        _onChildComplete.dispatch([this, signal.loader]);

        checkForComplete(signal);
    }

    public var onChildOpen(get, never): LoaderSignal;
    public function get_onChildOpen() : LoaderSignal {
        return _onChildOpen;
    }

    public var onChildError(get, never): ErrorSignal;
    public function get_onChildError() : ErrorSignal {
        return _onChildError;
    }

    public var onChildComplete(get, never): LoaderSignal;
    public function get_onChildComplete() : LoaderSignal {
        return _onChildComplete;
    }

    private function configLoader_complete_handler(signal: LoaderSignal, data: Dynamic) : Void {
        var loader : ILoader = signal.loader;
        loader.onComplete.remove(configLoader_complete_handler);
        loader.onError.remove(error_handler);

        if(!configParser.isValid(loader.data))
            _onError.dispatch([this, "config-error", "Could not parse config after it has been loaded."]);
        else {
            addConfig(loader.data);
            _onConfigLoaded.dispatch([this]);
        }

        loader.destroy();
    }

    public function addConfig(config : String):Void {
        var urlParser : URLParser = new URLParser(config);
        if(urlParser.isValid) {
            var loader : ILoader = _loaderFactory.produce("config", AssetType.TEXT, new URLRequest(config));
            loader.setParam(Param.PREVENT_CACHE, true);

            loader.onError.add(error_handler);
            loader.onComplete.add(configLoader_complete_handler);
            loader.start();
        }
        else {
            try {
                configParser.parse(this, config);
            }
            catch(error : Error) {
                throw new AssetLoaderError(AssetLoaderError.COULD_NOT_PARSE_CONFIG(_id, error.message), error.errorID);
            }
        }
    }
}

//    private function sortIdsByPriority():Void {
//        var priorities : Array<Dynamic> = [];
//
//        for (i in 0..._numLoaders){
//            var loader : ILoader = getLoader(_ids[i]);
//            priorities.push(loader.getParam(Param.PRIORITY));
//        }
//
//        //var sortedIndexs = priorities.sort((c)->{
//        //    c == Float;
//        //    return 0;
//        //});
//
//        //TODO@Wolfie -> overkill for unit testing..
//        var sortedIndexs = priorities;
//
//        var idsCopy: Array<Dynamic> = _ids.concat();
//
//        for (j in 0..._numLoaders){
//            _ids[j] = idsCopy[sortedIndexs[j]];
//        }
//    }