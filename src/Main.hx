
import js.Browser;

class Main {
    public function new(valueClasses: Array<Dynamic> = null) {
        valueClasses = switch(valueClasses) {
            case null: new Array<Dynamic>();
            default: valueClasses;
        }

        Browser.console.log(valueClasses);
    }

    static public function main() {
        trace("assetloader init!");
        new Main(["one"]);
        new Main(["one", "two"]);
        new Main();
    }
}
