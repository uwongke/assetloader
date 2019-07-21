package test.org.assetloader.base;

import openfl.system.LoaderContext;
import org.assetloader.base.Param;
import org.assetloader.core.IParam;

class ParamTest extends haxe.unit.TestCase {
    private var _param : Param;
    private var _id : String = "test-id";
    private var _value : LoaderContext = new LoaderContext();


    override public function setup() {
        _param = new Param(_id, _value);
    }

    override public function tearDown() {
        _param = null;
    }

    public function test_implementsIParam() : Void {
        /** Param should implement IParam */
        assertTrue(Std.is(_param, IParam));
    }

    public function test_retainsId() : Void {
        /** Param should retain id passed */
        assertEquals(_param.id, _id);
    }

    public function test_retainsValue() : Void {
        /** Param should retain value passed */
        assertEquals(_param.value, _value);
    }
}
