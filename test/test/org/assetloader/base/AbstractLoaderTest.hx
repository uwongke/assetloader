package test.org.assetloader.base;

import org.assetloader.base.AbstractLoader;
import org.assetloader.base.AssetType;
import org.assetloader.core.ILoader;
import org.assetloader.core.ILoadStats;

class AbstractLoaderTest extends haxe.unit.TestCase {

    private var _loaderName : String;
    private var _id : String = "test-id";
    private var _type : String;
    private var _hadRequest : Bool = false;
    private var _loader : ILoader;

    override public function setup() {
        _type = AssetType.IMAGE;
        _loader = new AbstractLoader(_id, _type);
    }

    override public function tearDown() {

    }

    public function test_implementing():Void {
        trace(_loaderName + "\nshould implement ILoader");
        assertTrue(Std.is(_loader, ILoader));
    }

    public function test_idAndTypeMatchValuesPassed():Void {
        trace(_loaderName + "#id must match the id passed via constructor");
        assertEquals(_id, _loader.id);

        trace(_loaderName + "#type must match the type passed via constructor");
        assertEquals(_type, _loader.type);
    }

    public function test_signalsReadyOnConstruction():Void {
        trace(_loaderName + "#onComplete should NOT be null after construction");
        assertTrue(_loader.onComplete != null);

        trace(_loaderName + "#onError should NOT be null after construction");
        assertTrue(_loader.onError != null);

        trace(_loaderName + "#onHttpStatus should NOT be null after construction");
        assertTrue(_loader.onHttpStatus != null);

        trace(_loaderName + "#onOpen should NOT be null after construction");
        assertTrue(_loader.onOpen != null);

        trace(_loaderName + "#onAddedToParent should NOT be null after construction");
        assertTrue(_loader.onAddedToParent != null);

        trace(_loaderName + "#onRemovedFromParent should NOT be null after construction");
        assertTrue(_loader.onRemovedFromParent != null);

        trace(_loaderName + "#onStart should NOT be null after construction");
        assertTrue(_loader.onStart != null);

        trace(_loaderName + "#onStop should NOT be null after construction");
        assertTrue(_loader.onStop != null);

    }

    public function test_statsReadyOnConstruction():Void {
        trace(_loader + "#stats should NOT be null after construction");
        assertTrue(_loader.stats != null);
    }

    public function test_statsImplementILoadStats():Void {
        trace(_loaderName + "#stats should implement ILoadStats");
        assertTrue(Std.is(_loader.stats, ILoadStats));
    }
}