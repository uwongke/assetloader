package org.assetloader.core;

import org.assetloader.signals.ProgressSignal;
import org.assetloader.signals.HttpStatusSignal;
import org.assetloader.signals.ErrorSignal;
import openfl.net.URLRequest;
import org.assetloader.signals.LoaderSignal;

/** Instances of ILoader will perform the actual loading of an asset.
    They only handle one file at a time. */
interface ILoader {

    /** Gets the parent loader of this loader. */
    var parent(get, never): ILoader;

    /** Gets the current loading stats of loader. */
    var stats(get, never): ILoadStats;

    /** True if the load operation was started. False other wise. */
    var invoked(get, never): Bool;

    /** True if the load operation has been started. */
    var inProgress(get, never): Bool;

    /** True if the load operation has been stopped via stop method. */
    var stopped(get, never): Bool;

    /** True if the loading has completed. False otherwise. */
    var loaded(get, never): Bool;

    /** True if the loader has failed after the set amount of retries. */
    var failed(get, never): Bool;

    /** @return Data that was returned after loading operation completed. */
    var data(get, never): Dynamic;

    /** @return String of ILoader id. */
    var id(get, never): String;

    /** @return URLRequest */
    var request(get, never): URLRequest;

    /** @return String of ILoader type. */
    var type(get, never): String;

    /** Object containing all parameters added to ILoader.
		Modifying this is not recommended as some params requires some work
		to be done once they are added. */
    var params(get, never): Dynamic;

    /** Gets the amount of times the loading operation failed and retried. */
    var retryTally(get, never): Int;

    /** Dispatches when something goes wrong, could be anything.
		Most common causes would be an incorrect url or security error.
		Keep in mind that all error are consolidated into one place, so if
		load an XML file that has mal formed xml, this Signal will fire. */
    var onError(get, never): ErrorSignal;

    /** Dispatches once the server has return a http status.
		Note: not all implemetations of ILoader dispatches this Signal.
		AssetLoader, VideoLoader and SoundLoader. */
    var onHttpStatus(get, never): HttpStatusSignal;

    /** Dispatches when a connection has been opened this means that the
		transfer will start shortly. */
    var onOpen(get, never): LoaderSignal;

    /** Dispatches when loading progress has been made. */
    var onProgress(get, never): ProgressSignal;

    /** Dispatches when the loading operations has completed. */
    var onComplete(get, never): LoaderSignal;

    /** Dispatches when an ILoader is added to an IAssetLoader's queue. */
    var onAddedToParent(get, never): LoaderSignal;

    /** Dispatches when an ILoader is removed from an IAssetLoader's queue. */
    var onRemovedFromParent(get, never): LoaderSignal;

    /** Dispatches when an ILoader's start method is called. NOTE: This is dispatched just BEFORE
		the actual loading operation starts. */
    var onStart(get, never): LoaderSignal;
    public function get_onStart() : LoaderSignal;

    /** Dispatches when an ILoader's stop method is called. */
    var onStop(get, never): LoaderSignal;

    /** Starts/resumes the loading operation. */
    function start(): Void ;

    /** Stops/pauses the loading operation. */
    function stop(): Void ;

    /** Removes all listeners and destroys references. */
    function destroy(): Void ;

    /** Checks if a param with the passed id eyxists. */
    function hasParam(id : String): Bool ;

    /** Sets param value. */
    function setParam(id : String, value: Dynamic) : Void;

    /** Gets param value. */
    function getParam(id : String): Dynamic ;

    /** Adds parameter to ILoader. Same effect as calling setParam.  */
    function addParam(param : IParam): Void ;
}
