package org.assetloader.signals;

class ErrorSignal extends LoaderSignal {
    public var type(get, never):String;
    public var message(get, never):String;

    private var _type:String;

    private var _message:String;

    public function new(valueClasses : Array<Dynamic> = null) {
        valueClasses = switch(valueClasses) {
            case null: new Array<Dynamic>();
            default: valueClasses;
        }

        _signalType = ErrorSignal;
        super(valueClasses);
    }

    /** Dispatches Signal. */
    override public function dispatch(args : Array<Dynamic> = null) : Void {
        _type = args[1];
        _message = args[2];

        args.splice(1, 2);

        super.dispatch(args);
    }

    /** Gets the error type. */
    private function get_type() : String {
        return _type;
    }

    /** Gets the error message. */
    private function get_message() : String {
        return _message;
    }
}
