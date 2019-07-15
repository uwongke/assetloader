package org.assetloader.signals;

class NetStatusSignal extends LoaderSignal {
    public var info(get, never): Dynamic;

    private var _info: Dynamic;

    public function new(valueClasses: Array<Dynamic> = null) {
        valueClasses = switch(valueClasses) {
            case null: new Array<Dynamic>();
            default: valueClasses;
        }
        _signalType = NetStatusSignal;
        super(valueClasses);
    }

    /** Dispatches Signal. */
    override public function dispatch(args: Array<Dynamic> = null) : Void {
        args = switch(args) {
            case null: new Array<Dynamic>();
            default: args;
        }

        _info = args.splice(1, 1)[0];
        //super.dispatch.apply(null, args);
        super.dispatch.apply(null, args);
    }

    /** Gets the NetStatus info object. */
    private function get_info() : Dynamic {
        return _info;
    }
}