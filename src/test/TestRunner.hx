package test;

import test.org.assetloader.parsers.URLParserTest;
//import test.org.assetloader.base.StatsMonitorTest;

//import test.org.assetloader.base.ParamTest;

class TestRunner {
    var r = new haxe.unit.TestRunner();

    public function new() {
        /** Add Test Cases here.... */
        //r.add(new ParamTest());
        //r.add(new StatsMonitorTest());
        r.add(new URLParserTest());


        /** Run the tests*/
        r.run();
    }
}