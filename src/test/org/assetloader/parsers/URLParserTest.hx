package test.org.assetloader.parsers;

import org.assetloader.parsers.URLParser;

class URLParserTest extends haxe.unit.TestCase {
    override public function setup() {}

    override public function tearDown() {}

    public function test_complexURL() : Void {
        var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

        /** url */
        assertEquals("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);

        /** protocol */
        assertEquals("https", parser.protocol);

        /** login */
        assertEquals("matan", parser.login);

        /** password */
        assertEquals("pswrd", parser.password);

        /** host */
        assertEquals("www.matanuberstein.co.za", parser.host);

        /** path */
        assertEquals("/assets/sample/sampleTXT.txt", parser.path);

        /** fileName */
        assertEquals("sampleTXT.txt", parser.fileName);

        /** fileExtension */
        assertEquals("txt", parser.fileExtension);

        /** #urlVariables#var1 **/
        assertEquals("value1", parser.urlVariables.var1);

        /** URLParser#urlVariables#var2 */
        assertEquals("value2", parser.urlVariables.var2);

        /** URLParser#anchor */
        assertEquals("comments", parser.anchor);

        /** URLParser#isValid should be true */
        assertEquals(parser.isValid, true);
    }
}