import test.TestRunner;
import js.Browser;

class Main {
    public function new(valueClasses: Array<Dynamic> = null) {
        new TestRunner();
    }

    static public function main() {
        trace("assetloader init!");
        new Main();
    }
}