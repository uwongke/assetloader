package org.assetloader.core;

import openfl.net.URLRequest;
import org.assetloader.signals.ErrorSignal;
import org.assetloader.signals.LoaderSignal;

/** Instances of IAssetLoader can contain ILoader. Itself being an ILoader, the IAssetLoader can
	also be contained by other IAssetLoaders. */
interface IAssetLoader extends ILoader {

    /** All the ids of the ILoaders in queue. */
    var ids(get, never) : Array<Dynamic>;

    /** All the ids of the ILoaders that have been loaded. */
    var loadedIds(get, never) : Array<Dynamic>;

    /** All the ids of the ILoaders that have failed. */
    var failedIds(get, never) : Array<Dynamic>;

    /** The amount of ILoaders in queue. */
    var numLoaders(get, never) : Int;

    /** The amount of ILoaders loaded. */
    var numLoaded(get, never) : Int;

    /** The amount of ILoaders that have failed. */

    var numFailed(get, never) : Int;
    /** Sets the failOnError flag. If true the IAssetLoader will not dispatch
		onComplete if one or more of the child loaders have failed/errored. If
		false, the onComplete signal will dispatch regardless of child failures. */

    /** Gets the failOnError flag. If true the IAssetLoader will not dispatch
		onComplete if one or more of the child loaders have failed/errored. If
		false, the onComplete signal will dispatch regardless of child failures. */

    var failOnError(get, set) : Bool;
    /** Sets the amount of connections to make. Value must be set before start is called,
		otherwise it has no effect.
		Setting numConnections to 0 (zero) will cause the group to start all assets at the same time. */

    /** Gets the number of connections this IAssetLoader will make.
		Setting numConnections to 0 (zero) will cause the group to start all assets at the same time. */
    var numConnections(get, set) : Int;

    /** Dispatches when a child ILoader in the loading queue dispatches onOpen. */
    var onChildOpen(get, never) : LoaderSignal;

    /** Dispatches when a child ILoader in the loading queue dispatches onError. */
    var onChildError(get, never) : ErrorSignal;

    /** Dispatches when a child ILoader in the loading queue dispatches <code>onComplete. */
    var onChildComplete(get, never) : LoaderSignal;

    /** Dispatches only if a URL is passed to the <code>addConfig</code> method and the config
		file has finished loading. */
    var onConfigLoaded(get, never) : LoaderSignal;

    /** Lazy adds asset to loading queue.
		Recommendation: Create a class with static constants of the asset ids. */
    function addLazy(id : String, url : String, type : String = "AUTO", params : Array<Dynamic> = null) : ILoader;

    /** Adds asset to loading queue. */
    function add(id : String, request : URLRequest, type : String = "AUTO", params : Array<Dynamic> = null) : ILoader;

    /** Adds loader to loading queue. */
    function addLoader(loader : ILoader) : Void
    ;
    /** Adds multiple assets to the loading queue. */
    function addConfig(data : String): Void;

    /** Removes ILoader from queue. */
    function remove(id : String) : ILoader;

    /** Starts the ILoader with id passed. */

    function startLoader(id : String) : Void;

    /** Checks if ILoader with id exists. */
    function hasLoader(id : String) : Bool;

    /** Gets the ILoader. */
    function getLoader(id : String) : ILoader;

    /** Checks if IAssetLoader with id exists. */

    function hasAssetLoader(id : String) : Bool;

    /** Gets the IAssetLoader. */
    function getAssetLoader(id : String) : IAssetLoader;

    /** Checks if the ILoader with given id has returned data. */
    function hasAsset(id : String) : Bool;

    /** Gets the data that was loaded by the ILoader. Data will only be available after
        the ILoader instance has finished loading. */
    function getAsset(id : String) : Dynamic ;
}
