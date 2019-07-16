package org.assetloader.signals;

class ProgressSignal extends LoaderSignal {
    public var latency(get, never) : Float;
    public var speed(get, never) : Float;
    public var averageSpeed(get, never) : Float;
    public var progress(get, never) : Float;
    public var bytesLoaded(get, never) : Int;
    public var bytesTotal(get, never) : Int;

    private var _latency : Float = 0;
    private var _speed : Float = 0;
    private var _averageSpeed : Float = 0;
    private var _progress : Float = 0;
    private var _bytesLoaded : Int = 0;
    private var _bytesTotal : Int = 0;

    public function new(valueClasses : Array<Dynamic> = null) {
        _signalType = ProgressSignal;
        super(valueClasses);
    }

    /** Dispatches Signal. */
    override public function dispatch(args : Array<Dynamic> = null) : Void {
        _latency = args[1];
        _speed = args[2];
        _averageSpeed = args[3];
        _progress = args[4];
        _bytesLoaded = args[5];
        _bytesTotal = args[6];

        args.splice(1, 6);

        //super.dispatch.apply(null, args);
        super.dispatch([null, args]);
    }

    /** Gets the latency in milliseconds. */
    private function get_latency() : Float {
        return _latency;
    }

    /** Gets speed in kilobytes per second. */
    private function get_speed() : Float {
        return _speed;
    }

    /** Gets the average speed in kilobytes per second. */
    private function get_averageSpeed() : Float {
        return _averageSpeed;
    }

    /** Gets the progress in percentage value. */
    private function get_progress() : Float {
        return _progress;
    }

    /** Gets the bytes loaded. */
    private function get_bytesLoaded() : Int {
        return _bytesLoaded;
    }

    /** Gets the total bytes. */
    private function get_bytesTotal() : Int {
        return _bytesTotal;
    }
}
