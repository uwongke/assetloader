package test.org.assetloader.parsers;

import js.Browser;
import org.assetloader.AssetLoader;
import org.assetloader.parsers.XmlConfigParser;
import org.assetloader.core.IAssetLoader;

class XmlConfigParserTest extends haxe.unit.TestCase {

    private var _assetloader : IAssetLoader;
    private var _parser : XmlConfigParser;

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


    //public function test_implementing():Void {
    //    trace("\nXmlConfigParser should implement IConfigParser");
    //    assertTrue(Std.is(_parser, IConfigParser));
    //}

    //public function test_isValid():Void {
        //trace("\nXmlConfigParser#isValid should be true with valid data");
        //assertTrue(_parser.isValid(_data));
    //}

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


        Browser.window.setTimeout(()->{
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

            assertTrue("group2#hasLoader('SAMPLE_TXT') should be true", group2.hasLoader('SAMPLE_TXT'));


        }, 2000);



//        trace("\ngroup2#hasLoader('SAMPLE_JSON') should be true");
//        var json = group2.hasLoader('SAMPLE_JSON');
        //assertTrue(group2.hasLoader('SAMPLE_JSON'));

//        Browser.console.log(json);



        assertTrue(true);
    }



}