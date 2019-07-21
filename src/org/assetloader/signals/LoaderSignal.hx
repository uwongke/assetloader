package org.assetloader.signals;

import js.Browser;
import org.assetloader.core.ILoader;
import org.osflash.signals.Signal;

class LoaderSignal extends Signal {

    private var _loader:ILoader;
    public var loader(get, never):ILoader;

    private var _signalType:Class<Dynamic>;

    public function new(valueClasses:Array<Dynamic> = null) {
        super();
        valueClasses = switch(valueClasses) {
            case null: new Array<Dynamic>();
            default: valueClasses;
        }

        _signalType = (_signalType != null) ? _signalType : LoaderSignal;

        if (valueClasses.length == 1 && Std.is(valueClasses[0], Array)) {
            valueClasses = valueClasses[0];
        }

        this.valueClasses = [_signalType, null, valueClasses];

        //this.valueClasses = [_signalType].concat.apply(null, valueClasses);
    }

    /** First argument must be the loader to which this signal belongs. */
    override public function dispatch(args:Array<Dynamic> = null) : Void {

        _loader = args.shift();

        var newArgs = [this];
        for(a in args){ newArgs.push(a); }

        super.dispatch(newArgs);
    }

    /** Gets the loader that dispatched this signal. */
    private function get_loader() : ILoader {
        return _loader;
    }
}
