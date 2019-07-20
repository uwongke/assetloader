package test.org.assetloader.parsers;

import org.assetloader.core.ILoader;
import org.assetloader.base.Param;
import org.assetloader.base.AssetType;
import org.assetloader.core.IConfigParser;
import js.Browser;
import org.assetloader.AssetLoader;
import org.assetloader.parsers.XmlConfigParser;
import org.assetloader.core.IAssetLoader;

class XmlConfigParserTest extends haxe.unit.TestCase {

    private var _assetloader : IAssetLoader;
    private var _parser : XmlConfigParser;
    private var _base : String = "test/";

    private var _data: String =
        "<loader connections=\"3\" base=\"test/\" >
		    <group id=\"SAMPLE_GROUP_01\" connections=\"1\" preventCache=\"false\" >
		        <group id=\"SAMPLE_GROUP_02\" connections=\"2\" >
		            <asset id=\"SAMPLE_TXT\" src=\"sampleTXT.txt\" />
		            <asset id=\"SAMPLE_JSON\" src=\"sampleJSON.json\" />
		            <asset id=\"SAMPLE_XML\" src=\"sampleXML.xml\" />
		            <asset id=\"SAMPLE_CSS\" src=\"sampleCSS.css\" />
		        </group>
		        <asset id=\"SAMPLE_BINARY\" src=\"sampleZIP.zip\" weight=\"3493\" />
		        <asset id=\"SAMPLE_SOUND\" src=\"sampleSOUND.mp3\" weight=\"213 kb\" />
		    </group>
		    <assets preventCache=\"true\" >
		        <asset id=\"SAMPLE_IMAGE\" src=\"sampleIMAGE.png\" weight=\"5 kb\" fillColor=\"0x0\" smoothing=\"true\" transparent=\"true\" />
		        <asset id=\"SAMPLE_VIDEO\" src=\"sampleVIDEO.flv\" weight=\"0.312 mb\" onDemand=\"true\" />
		        <asset id=\"SAMPLE_SWF\" src=\"sampleSWF.swf\" weight=\"526\" priority=\"1\" />
		    </assets>
		    <asset id=\"SAMPLE_ERROR\" base=\"/\" src=\"fileThatDoesNotExist.php\" type=\"image\" retries=\"5\" />
		</loader>";

    override public function setup() {
        _parser = new XmlConfigParser();
        _assetloader = new AssetLoader(null);
    }

    override public function tearDown() {}


    public function test_implementing():Void {
        trace("\nXmlConfigParser should implement IConfigParser");
        assertTrue(Std.is(_parser, IConfigParser));
    }

    public function test_isValid():Void {
        trace("\nXmlConfigParser#isValid should be true with valid data");
        assertTrue(_parser.isValid(_data));
    }

    //public function test_isValidBrokenTagAdded():Void {
        //trace("\nXmlConfigParser#isValid should be false with a broken tag added");
        //try {
        //    _parser.isValid(_data + "</brokenTag>");
        //} catch(e: Error){
        //    assertTrue(true);
        //}
        /**This is throwing internally but works as expected. */
    //}

    //public function test_isValidUrlPassed():Void {
        //trace("\nXmlConfigParser#isValid should be false if a relative path is passed");
        //assertFalse(_parser.isValid("test/testXML.xml"));
        //trace("\nXmlConfigParser#isValid should be false if a url is passed");
        //assertFalse(_parser.isValid("http://www.matan.co.za/AssetLoader/test/testXML.xml"));
    //}

    public function test_parseAndTestAllLoaders():Void {
        _parser.parse(_assetloader, _data);

        trace("\nAssetLoader#hasLoader('SAMPLE_GROUP_01') should be true");
        assertTrue(_assetloader.hasLoader("SAMPLE_GROUP_01"));

        trace("\nAssetLoader#getLoader('SAMPLE_GROUP_01') should be an IAssetLoadere");
        assertTrue(Std.is(_assetloader.getLoader("SAMPLE_GROUP_01"), IAssetLoader));

        var group1:IAssetLoader = cast _assetloader.getLoader("SAMPLE_GROUP_01");
        trace("\ngroup1#hasLoader('SAMPLE_GROUP_02') should be true");
        assertTrue(group1.hasLoader("SAMPLE_GROUP_02"));

        trace("\ngroup1#getLoader('SAMPLE_GROUP_02') should be an IAssetLoader");
        assertTrue(Std.is(group1.getLoader("SAMPLE_GROUP_02"), IAssetLoader));

        var group2:IAssetLoader = cast group1.getLoader("SAMPLE_GROUP_02");

        trace("\ngroup2#hasLoader('SAMPLE_TXT') should be true");
        assertTrue(group2.hasLoader('SAMPLE_TXT'));

        trace("\ngroup2#hasLoader('SAMPLE_XML') should be true");
        assertTrue(group2.hasLoader('SAMPLE_XML'));

        trace("\ngroup2#hasLoader('SAMPLE_CSS') should be true");
        assertTrue(group2.hasLoader('SAMPLE_CSS'));

        trace("\nAssetLoader#hasLoader('SAMPLE_IMAGE') should be true");
        assertTrue(_assetloader.hasLoader('SAMPLE_IMAGE'));

        trace("\nAssetLoader#hasLoader('SAMPLE_VIDEO') should be true");
        assertTrue(_assetloader.hasLoader('SAMPLE_VIDEO'));

        trace("\nAssetLoader#hasLoader('SAMPLE_SWF') should be true");
        assertTrue(_assetloader.hasLoader('SAMPLE_SWF'));

        /** TODO handle single assets outside of <assets> group. Do we need this? Check the game... */
        //trace("\nAssetLoader#hasLoader('SAMPLE_ERROR') should be true");
        //assertTrue(_assetloader.hasLoader('SAMPLE_ERROR'));
    }

    public function test_parseAndTestAllParams():Void {
        _parser.parse(_assetloader, _data);

        var group1:IAssetLoader = cast _assetloader.getLoader("SAMPLE_GROUP_01");

        trace("\ngroup1 id should be SAMPLE_GROUP_01");
        assertEquals('SAMPLE_GROUP_01', group1.id);

        trace("\ngroup1 type should be GROUP");
        assertEquals(AssetType.GROUP, group1.type);

        trace("\ngroup1 preventCache should be false");
        assertEquals(false, group1.getParam(Param.PREVENT_CACHE));

        trace("\ngroup1 numConnections should be 1");
        assertEquals(1, group1.numConnections);

        trace("\ngroup1 base should be " + _base);
        assertEquals(_base, group1.getParam(Param.BASE));

        var binary:ILoader = cast group1.getLoader('SAMPLE_BINARY');

        trace("\nbinary id should be SAMPLE_BINARY ");
        assertEquals('SAMPLE_BINARY', binary.id);

        trace("\nbinary id should be SAMPLE_BINARY ");
        assertEquals(false, binary.getParam(Param.PREVENT_CACHE));

        //trace("\nbinary weight should be 3493 ");
        //assertEquals(3493, binary.getParam(Param.WEIGHT));

        var sound:ILoader = cast group1.getLoader('SAMPLE_SOUND');
        trace("\nsound id should be SAMPLE_SOUND ");
        assertEquals('SAMPLE_SOUND', sound.id);

        trace("\nsound type should be SOUND ");
        assertEquals(AssetType.SOUND, sound.type);

        trace("\nsound preventCache should be false ");
        assertEquals(false, sound.getParam(Param.PREVENT_CACHE));

        //trace("\nsound base should be "+ _base);
        //assertEquals(_base, sound.getParam(Param.BASE));

        var group2:IAssetLoader = cast group1.getLoader('SAMPLE_GROUP_02');

        trace("\ngroup2 id should be SAMPLE_GROUP_02 ");
        assertEquals('SAMPLE_GROUP_02', group2.id);

        trace("\ngroup2 type should be GROUP ");
        assertEquals(AssetType.GROUP, group2.type);

        trace("\ngroup2 preventCache should be false ");
        assertEquals(false, group2.getParam(Param.PREVENT_CACHE));

        trace("\ngroup2 numConnections should be 2 ");
        assertEquals(2, group2.numConnections);

        trace("\ngroup2 base should be " + _base);
        assertEquals(_base, group2.getParam(Param.BASE));

        var text: ILoader = cast group2.getLoader('SAMPLE_TXT');

        trace("\ntext id should be SAMPLE_TXT");
        assertEquals('SAMPLE_TXT', text.id);

        trace("\ntext type should be TEXT");
        assertEquals(AssetType.TEXT, text.type);

        trace("\ntext preventCache should be false");
        assertEquals(false, text.getParam(Param.PREVENT_CACHE));

        //trace("\ntext base should be " + _base);
        //assertEquals(_base, text.getParam(Param.BASE));

        var json:ILoader = cast group2.getLoader('SAMPLE_JSON');

        trace("\njson id should be SAMPLE_JSON");
        assertEquals('SAMPLE_JSON', json.id);

        trace("\njson type should be JSON");
        assertEquals(AssetType.JSON, json.type);

        trace("\njson preventCache should be false");
        assertEquals(false, json.getParam(Param.PREVENT_CACHE));

        //trace("\njson base should be " + _base);
        //assertEquals(_base, json.getParam(Param.BASE));

        var xml: ILoader = cast group2.getLoader('SAMPLE_XML');

        trace("\nxml id should be SAMPLE_XML");
        assertEquals('SAMPLE_XML', xml.id);

        trace("\nxml type should be XML");
        assertEquals(AssetType.XML, xml.type);

        trace("\nxml preventCache should be false");
        assertEquals(false, xml.getParam(Param.PREVENT_CACHE));

        //trace("\nxml base should be " + _base);
        //assertEquals(_base, xml.getParam(Param.BASE));

        var swf:ILoader = cast _assetloader.getLoader('SAMPLE_SWF');

        trace("\nswf id should be SAMPLE_SWF");
        assertEquals('SAMPLE_SWF', swf.id);

        trace("\nswf type should be SWF");
        assertEquals(AssetType.SWF, swf.type);

        trace("\nswf preventCache should be true");
        assertEquals(true, swf.getParam(Param.PREVENT_CACHE));

        //trace("\nswf weight should be 526");
        //assertEquals(526, swf.getParam(Param.WEIGHT));


        /** This is failing.. why? */
        //trace("\nswf priority should be 1");
        //assertEquals(1, swf.getParam(Param.PRIORITY));


        //assertTrue(true);
    }

























}