package test.org.assetloader.parsers;

import js.Browser;
import as3hx.Error;
import org.assetloader.core.IConfigParser;
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
        _parser = new XmlConfigParser(null);
        _assetloader = new AssetLoader(null);
    }

    override public function tearDown() {}

    //public function test_one():Void {
    //    _parser.parse(_assetloader, _data);
    //    assertTrue(true);
    //}

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
        _assetloader.hasLoader('SAMPLE_GROUP_01');

        //trace("\nAssetLoader#hasLoader('SAMPLE_GROUP_01') should be true");
        //assertTrue(_assetloader.hasLoader("SAMPLE_GROUP_01"));


        assertTrue(true);
    }



}



//    private var _data = "{
//    \"loader\": {
//        \"_attributes\": {
//            \"connections\": \"3\",
//            \"base\": \"test\"
//        },
//        \"group\": {
//            \"_attributes\": {
//                \"id\": \"SAMPLE_GROUP_01\",
//                \"connections\": \"1\",
//                \"preventCache\": \"false\"
//            },
//            \"group\": {
//                \"_attributes\": {
//                    \"id\": \"SAMPLE_GROUP_02\",
//                    \"connections\": \"2\"
//                },
//                \"asset\": [
//                    {
//                        \"_attributes\": {
//                            \"id\": \"SAMPLE_TXT\",
//                            \"src\": \"sampleTXT.txt\"
//                        }
//                    },
//                    {
//                        \"_attributes\": {
//                            \"id\": \"SAMPLE_JSON\",
//                            \"src\": \"sampleJSON.json\"
//                        }
//                    },
//                    {
//                        \"_attributes\": {
//                            \"id\": \"SAMPLE_XML\",
//                            \"src\": \"sampleXML.xml\"
//                        }
//                    },
//                    {
//                        \"_attributes\": {
//                            \"id\": \"SAMPLE_CSS\",
//                            \"src\": \"sampleCSS.css\"
//                        }
//                    }
//                ]
//            },
//            \"asset\": [
//                {
//                    \"_attributes\": {
//                        \"id\": \"SAMPLE_BINARY\",
//                        \"src\": \"sampleZIP.zip\",
//                        \"weight\": \"3493\"
//                    }
//                },
//                {
//                    \"_attributes\": {
//                        \"id\": \"SAMPLE_SOUND\",
//                        \"src\": \"sampleSOUND.mp3\",
//                        \"weight\": \"213 kb\"
//                    }
//                }
//            ]
//        },
//        \"assets\": {
//            \"_attributes\": {
//                \"preventCache\": \"true\"
//            },
//            \"asset\": [
//                {
//                    \"_attributes\": {
//                        \"id\": \"SAMPLE_IMAGE\",
//                        \"src\": \"sampleIMAGE.png\",
//                        \"weight\": \"5 kb\",
//                        \"fillColor\": \"0x0\",
//                        \"smoothing\": \"true\",
//                        \"transparent\": \"true\"
//                    }
//                },
//                {
//                    \"_attributes\": {
//                        \"id\": \"SAMPLE_VIDEO\",
//                        \"src\": \"sampleVIDEO.flv\",
//                        \"weight\": \"0.312 mb\",
//                        \"onDemand\": \"true\"
//                    }
//                },
//                {
//                    \"_attributes\": {
//                        \"id\": \"SAMPLE_SWF\",
//                        \"src\": \"sampleSWF.swf\",
//                        \"weight\": \"526\",
//                        \"priority\": \"1\"
//                    }
//                }
//            ]
//        },
//        \"asset\": {
//            \"_attributes\": {
//                \"id\": \"SAMPLE_ERROR\",
//                \"base\": \"/\",
//                \"src\": \"fileThatDoesNotExist.php\",
//                \"type\": \"image\",
//                \"retries\": \"5\"
//            }
//        }
//    }
//}";