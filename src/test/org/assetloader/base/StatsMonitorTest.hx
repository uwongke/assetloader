package test.org.assetloader.base;

import openfl.net.URLRequest;
import org.assetloader.loaders.TextLoader;
import org.assetloader.core.ILoader;
import org.assetloader.base.StatsMonitor;

class StatsMonitorTest extends haxe.unit.TestCase {

    private var _monitor : StatsMonitor;
    private var _className : String = "StatsMonitor";
    private var _path : String = "assets/test/";

    override public function setup() {
        _monitor = new StatsMonitor();
    }

    override public function tearDown() {
        _monitor.destroy();
        _monitor = null;
    }

    public function test_signalsReadyOnConstruction() : Void {
        assertTrue(_monitor.onOpen != null);  /** null */
        assertTrue(_monitor.onProgress != null);  /** null */
        assertTrue(_monitor.onComplete != null);  /** null */
    }

    public function test_adding() : Void {
        var l1 : ILoader = new TextLoader(new URLRequest(_path + "testTXT.txt"));
        //_monitor.add(l1);
        //Assert.areEqual(1, _monitor.numLoaders);  // null
        //Assert.areEqual(0, _monitor.numComplete);  // null

        //var l2 : ILoader = new ImageLoader(new URLRequest(_path + "testIMAGE.png"));
        //_monitor.add(l2);
        //Assert.areEqual(2, _monitor.numLoaders);  // null
        //Assert.areEqual(0, _monitor.numComplete);  // null
    }

}