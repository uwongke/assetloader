package org.assetloader.core;

/** Calulates download stats. */
interface ILoadStats {

    /** Time between start and open.  */
    var latency(get, never) : Float;

    /** Current speed of download. */
    var speed(get, never) : Float;

    /** Average speed of download. */
    var averageSpeed(get, never) : Float;

    /** Current progress percentage of download. */
    var progress(get, never) : Float;
    /** Total time taken. */

    var totalTime(get, never) : Float;

    /** @return Amount of bytes loaded. */
    var bytesLoaded(get, never) : Int;

    /** @param value The total amount of bytes for a loading operation. */

    /** @return Total amount of bytes to load. */
    var bytesTotal(get, set) : Int;

    /** Records time when invoked. This should be called when you init a loading operation. */
    function start() : Void;

    /** Records time difference between start and now to calculated latency. */
    function open() : Void;

    /** Invoke when loading is complete. */
    function done() : Void;

    /** Invoke when loading progress is made. This will updated the stats. */
    function update(bytesLoaded : Int, bytesTotal : Int) : Void ;

    /** Resets all the values. */
    function reset() : Void ;
}