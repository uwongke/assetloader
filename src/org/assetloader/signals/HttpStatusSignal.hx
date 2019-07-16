package org.assetloader.signals;

/** @author Matan Uberstein */
class HttpStatusSignal extends LoaderSignal {
    public var status(get, never) : Int;

    private var _status : Int;

    public function new(valueClasses : Array<Dynamic> = null) {
        valueClasses = switch(valueClasses) {
            case null: new Array<Dynamic>();
            default: valueClasses;
        }

        _signalType = HttpStatusSignal;
        super(valueClasses);
    }

    /** Dispatches Signal. */
    override public function dispatch(args : Array<Dynamic> = null) : Void {
        args = switch(args) {
            case null: new Array<Dynamic>();
            default: args;
        }

        _status = args.splice(1, 1)[0];
        //Reflect.setField(super.dispatch, args);
        //super.dispatch.apply(null, args);
        super.dispatch([null, args]);
    }

    /** Gets the http status code. */
    private function get_status() : Int {
        return _status;
    }
}