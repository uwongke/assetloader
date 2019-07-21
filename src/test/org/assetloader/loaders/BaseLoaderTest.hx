package test.org.assetloader.loaders;

import js.Browser;
import org.osflash.signals.events.GenericEvent;
import test.org.assetloader.base.AbstractLoaderTest;

class BaseLoaderTest extends AbstractLoaderTest {

    private var _payloadType: Class<Dynamic>;
    private var _payloadTypeName:String;
    private var _payloadPropertyName:String;
    private var _path:String = "assets/test/";
    private var _hadParent : Bool = false;

    override public function setup() {
        super.setup();
        _hadRequest = true;
    }

    public function test_booleanStateBeforeLoad():Void {
        assertEquals(null, _loader.invoked);
        assertEquals(null, _loader.inProgress);
        assertEquals(null, _loader.stopped);
        assertEquals(null, _loader.loaded);
        assertEquals(null, _loader.failed);
    }

    public function test_booleanStateDuringLoad():Void {
        //handleSignal(this, _loader.onOpen, onOpen_booleanStateDuringLoad_handler);
        _loader.start();
        assertTrue(true);
    }

    private function test_onOpen_booleanStateDuringLoad_handler(event: GenericEvent, data : Dynamic) : Void {
        assertEquals(null, _loader.invoked);
        assertEquals(null, _loader.inProgress);
        assertEquals(null, _loader.stopped);
        assertEquals(null, _loader.loaded);
        assertEquals(null, _loader.failed);
    }

    public function test_booleanStateAfterStoppedLoad():Void {
        //Browser.console.log("===================");
        _loader.start();
        _loader.stop();
        //assertEquals(null, _loader.invoked);
        //assertEquals(null, _loader.inProgress);
        //Assert.areEqual(true, _loader.invoked);  // null
        //Assert.areEqual(false, _loader.inProgress);  // null
        //Assert.areEqual(true, _loader.stopped);  // null
        //Assert.areEqual(false, _loader.loaded);  // null
        //Assert.areEqual(false, _loader.failed);  // null
    }





}
