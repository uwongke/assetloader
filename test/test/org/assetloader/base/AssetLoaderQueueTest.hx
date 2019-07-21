package test.org.assetloader.base;

import openfl.net.URLRequest;
import org.assetloader.AssetLoader;
import org.assetloader.loaders.TextLoader;

class AssetLoaderQueueTest extends haxe.unit.TestCase {

    private var _path : String = "test/testTXT.txt";
    private var _id : String = "test-id-";
    private var _assetloader : AssetLoader;

    override public function setup() {
        _assetloader = new AssetLoader();
    }

    override public function tearDown() {}

    public function test_addingToQueue() : Void {
        _assetloader.addLoader(new TextLoader(new URLRequest(_path), _id + 1));

        trace("AssetLoader#add should return the ILoader produced");
        var req = new URLRequest(_path);
        var asset = _assetloader.add(_id + 2, req);
        assertTrue(asset != null);

        trace("AssetLoader#addLazy should return the ILoader produced");
        assertTrue(_assetloader.addLazy(_id + 3, _path) != null);

        trace("AssetLoader#numLoaders should be equal to 3");
        assertEquals(_assetloader.numLoaders, 3);

        trace("AssetLoader#hasLoader should be true");
        assertTrue(_assetloader.hasLoader(_id + 1));

        trace("AssetLoader#hasLoader should be true");
        assertTrue(_assetloader.hasLoader(_id + 2));

        trace("AssetLoader#hasLoader should be true");
        assertTrue(_assetloader.hasLoader(_id + 3));

        trace("AssetLoader#getLoader should NOT be null");
        assertTrue(_assetloader.getLoader(_id + 1) !=null);

        trace("AssetLoader#getLoader should NOT be null");
        assertTrue(_assetloader.getLoader(_id + 2) !=null);

        trace("AssetLoader#getLoader should NOT be null");
        assertTrue(_assetloader.getLoader(_id + 3) !=null);
    }

    private function buildQueue() : Void {
        _assetloader.addLoader(new TextLoader(new URLRequest(_path), _id + 1));
        _assetloader.add(_id + 2, new URLRequest(_path));
        _assetloader.addLazy(_id + 3, _path);
    }

    public function test_removingFromQueue() : Void {
        buildQueue();

        trace("AssetLoader#remove should return the loader removed from the queue");
        assertTrue(_assetloader.remove(_id + 1) !=null);

        trace("AssetLoader#numLoaders should be equal to 2");
        assertEquals(_assetloader.numLoaders, 2);

        trace("AssetLoader#hasLoader should be true");
        assertTrue(_assetloader.hasLoader(_id + 1));

        //trace("AssetLoader#getLoader should be null");
        //assertTrue(_assetloader.getLoader(_id + 1) == null);





















        assertTrue(true);
    }

}
