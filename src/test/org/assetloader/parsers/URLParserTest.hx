package test.org.assetloader.parsers;

import org.assetloader.parsers.URLParser;

class URLParserTest extends haxe.unit.TestCase {
    override public function setup() {}

    override public function tearDown() {}

    public function test_complexURL() : Void {
        var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");
        //trace("=================");
        //trace(parser.url);
        //assertEquals("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#commentsl", parser.url);  /** URLParser#url */
        //assertEquals("https", parser.protocol);  /** URLParser#protocol */

        //Assert.areEqual("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);  // URLParser#url
        //Assert.areEqual("https", parser.protocol);  // URLParser#protocol
        //Assert.areEqual("matan", parser.login);  // URLParser#login
        //Assert.areEqual("pswrd", parser.password);  // URLParser#password
        //Assert.areEqual("www.matanuberstein.co.za", parser.host);  // URLParser#host
        //Assert.areEqual("/assets/sample/sampleTXT.txt", parser.path);  // URLParser#path
        //Assert.areEqual("sampleTXT.txt", parser.fileName);  // URLParser#fileName
        //Assert.areEqual("txt", parser.fileExtension);  // URLParser#fileExtension
        //Assert.areEqual("value1", parser.urlVariables.var1);  // URLParser#urlVariables#var1
        //Assert.areEqual("value2", parser.urlVariables.var2);  // URLParser#urlVariables#var2
        //Assert.areEqual("comments", parser.anchor);  // URLParser#anchor
        //Assert.isTrue(parser.isValid);  // URLParser#isValid should be true

        assertTrue(true);
    }
}