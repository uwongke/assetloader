package test;

import test.org.assetloader.base.ParamTest;
import test.org.assetloader.parsers.URLParserTest;
//import test.org.assetloader.base.StatsMonitorTest;


class TestRunner {
    var r = new haxe.unit.TestRunner();

    public function new() {
        /** Add Test Cases here.... */
        r.add(new ParamTest());
        r.add(new URLParserTest());

        //r.add(new StatsMonitorTest());

        /** Run the tests*/
        r.run();
    }
}