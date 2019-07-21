package test;

import test.org.assetloader.base.AbstractLoaderTest;
import test.org.assetloader.base.AssetLoaderQueueTest;
import test.org.assetloader.base.ParamTest;
import test.org.assetloader.loaders.BaseLoaderTest;
import test.org.assetloader.parsers.URLParserTest;
import test.org.assetloader.parsers.XmlConfigParserTest;
//import test.org.assetloader.base.StatsMonitorTest;


class TestRunner {
    var r = new haxe.unit.TestRunner();

    public function new() {
        /** Add Test Cases here.... */
        r.add(new ParamTest());
        r.add(new URLParserTest());
        r.add(new XmlConfigParserTest());
        r.add(new AbstractLoaderTest());
        r.add(new AssetLoaderQueueTest());
        r.add(new BaseLoaderTest());

        //r.add(new StatsMonitorTest());

        /** Run the tests*/
        r.run();
    }
}