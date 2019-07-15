package org.assetloader.base;

import org.assetloader.core.ILoader;
import org.assetloader.signals.ProgressSignal;
import org.assetloader.signals.LoaderSignal;
import org.assetloader.core.ILoadStats;
class StatsMonitor {
    public var ids(get, never) : Array<Dynamic>;
    public var stats(get, never) : ILoadStats;
    public var onOpen(get, never) : LoaderSignal;
    public var onProgress(get, never) : ProgressSignal;
    public var onComplete(get, never) : LoaderSignal;
    public var numLoaders(get, never) : Int;
    public var numComplete(get, never) : Int;


    private var _loaders : Array<Dynamic>;

    private var _stats : ILoadStats;

    private var _numLoaders : Int;

    private var _numComplete : Int;

    private var _ids : Array<Dynamic> = [];

    private var _onOpen : LoaderSignal;

    private var _onProgress : ProgressSignal;

    private var _onComplete : LoaderSignal;

    public function new() {
        _loaders = [];
        _stats = new LoaderStats();

        _onOpen = new LoaderSignal();
        _onProgress = new ProgressSignal();
        _onComplete = new LoaderSignal(ILoadStats);
    }

    /** Adds ILoader for monitoring. */
    public function add(loader : ILoader) : Void {
        if (Lambda.indexOf(_loaders, loader) == -1) {
            loader.onStart.add(start_handler);

            _loaders.push(loader);
            _ids.push(loader.id);
            _numLoaders = _loaders.length;
            if (loader.loaded) {
                _numComplete++;
            }
        }
        else {
            throw new AssetLoaderError(AssetLoaderError.ALREADY_CONTAINS_LOADER);
        }
    }

    /** Removes ILoader from monitoring. */
    public function remove(loader : ILoader) : Void {
        var index : Int = Lambda.indexOf(_loaders, loader);
        if (index != -1) {
            loader.onStart.remove(start_handler);
            removeListeners(loader);

            if (loader.loaded) {
                _numComplete--;
            }

            _loaders.splice(index, 1);
            _ids.splice(index, 1);
            _numLoaders = _loaders.length;
        }
        else {
            throw new AssetLoaderError(AssetLoaderError.DOESNT_CONTAIN_LOADER);
        }
    }

    /** Removes all internal listeners and clears the monitoring list.
		Note: After calling destroy, this instance of StatsMonitor is still usable.
		Simply rebuild your monitor list via the add() method.</p> */
    public function destroy() : Void {
        for (loader in _loaders) {
            loader.onStart.remove(start_handler);
            removeListeners(loader);
        }

        _loaders = [];
        _numLoaders = 0;
        _numComplete = 0;

        _onOpen.removeAll();
        _onProgress.removeAll();
        _onComplete.removeAll();
    }

    private function addListeners(loader : ILoader) : Void {
        loader.onOpen.add(open_handler);
        loader.onProgress.add(progress_handler);
        loader.onComplete.add(complete_handler);
    }

    private function removeListeners(loader : ILoader) : Void {
        loader.onOpen.remove(open_handler);
        loader.onProgress.remove(progress_handler);
        loader.onComplete.remove(complete_handler);
    }

    private function start_handler(signal : LoaderSignal) : Void {
        for (loader in _loaders) {
            loader.onStart.remove(start_handler);
            addListeners(loader);
        }
        _stats.start();
    }

    private function open_handler(signal : LoaderSignal) : Void {
        _stats.open();
        _onOpen.dispatch(signal.loader);
    }

    private function progress_handler(signal : ProgressSignal) : Void {
        var bytesLoaded : Int;
        var bytesTotal : Int;
        for (loader in _loaders) {
            bytesLoaded += loader.stats.bytesLoaded;
            bytesTotal += loader.stats.bytesTotal;
        }
        _stats.update(bytesLoaded, bytesTotal);

        _onProgress.dispatch(signal.loader, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress,
        _stats.bytesLoaded, _stats.bytesTotal);
    }

    private function complete_handler(signal : LoaderSignal, payload : Dynamic) : Void {
        _numComplete++;
        if (_numComplete == _numLoaders) {
            _stats.done();
            _onComplete.dispatch(null, _stats);
        }
    }

    /** Checks whether the StatsMonitor contains an ILoader with id passed. */
    public function hasLoader(id : String) : Bool {
        return (Lambda.indexOf(_ids, id) != -1);
    }

    /** Gets the load with id passed. */
    public function getLoader(id : String) : ILoader {
        if (hasLoader(id)) {
            return _loaders[Lambda.indexOf(_ids, id)];
        }
        return null;
    }

    /** All the ids of the ILoaders added to this StatsMonitor. */
    private function get_ids() : Array<Dynamic> {
        return _ids;
    }

    /** Get the overall stats of all the ILoaders in the monitoring list. */
    private function get_stats() : ILoadStats {
        return _stats;
    }

    /** Dispatches each time a connection has been opend. */
    private function get_onOpen() : LoaderSignal {
        return _onOpen;
    }

    /** Dispatches when loading progress has been made. */
    private function get_onProgress() : ProgressSignal {
        return _onProgress;
    }

    /** Dispatches when the loading operations has completed. */
    private function get_onComplete() : LoaderSignal {
        return _onComplete;
    }

    /** Gets the amount of loaders added to the monitoring queue. */
    private function get_numLoaders() : Int {
        return _numLoaders;
    }

    /** Gets the amount of loaders that have finished loading. */
    private function get_numComplete() : Int {
        return _numComplete;
    }
}