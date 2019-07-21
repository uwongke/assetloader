package test.org.assetloader.parsers;

import org.assetloader.parsers.URLParser;

//TODO@Wolfie -> Handle isValid properly _if_ it's being used...

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

        /** urlVariables#var1 **/
        assertEquals("value1", parser.urlVariables.var1);

        /** urlVariables#var2 */
        assertEquals("value2", parser.urlVariables.var2);

        /** anchor */
        assertEquals("comments", parser.anchor);

        /** isValid should be true */
        assertEquals(parser.isValid, true);
    }

    public function test_complexURLWithComplexName() : Void {
        var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sam_pl-e%20TXT.txt?var1=value1&var2=value2#comments");

        /** url */
        assertEquals("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/sam_pl-e%20TXT.txt?var1=value1&var2=value2#comments", parser.url);

        /** protocol */
        assertEquals("https", parser.protocol);

        /** login */
        assertEquals("matan", parser.login);

        /** password */
        assertEquals("pswrd", parser.password);

        /** host */
        assertEquals("www.matanuberstein.co.za", parser.host);

        /** path */
        assertEquals("/assets/sample/sam_pl-e%20TXT.txt", parser.path);

        /** fileName */
        assertEquals("sam_pl-e%20TXT.txt", parser.fileName);

        /** fileExtension */
        assertEquals("txt", parser.fileExtension);

        /** urlVariables#var1 **/
        assertEquals("value1", parser.urlVariables.var1);

        /** urlVariables#var2 */
        assertEquals("value2", parser.urlVariables.var2);

        /** anchor */
        assertEquals("comments", parser.anchor);

        /** isValid should be true */
        assertEquals(parser.isValid, true);
    }

    public function test_complexServerURL() : Void {
        var parser : URLParser = new URLParser("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/?var1=value1&var2=value2#comments");

        /** url */
        assertEquals("https://matan:pswrd@www.matanuberstein.co.za/assets/sample/?var1=value1&var2=value2#comments", parser.url);

        /** protocol */
        assertEquals("https", parser.protocol);

        /** login */
        assertEquals("matan", parser.login);

        /** password */
        assertEquals("pswrd", parser.password);

        /** host */
        assertEquals("www.matanuberstein.co.za", parser.host);

        /** path */
        assertEquals("/assets/sample/", parser.path);

        /** fileName */
        assertTrue(parser.fileName == "");

        /** fileExtension */
        assertTrue(parser.fileExtension == "");

        /** urlVariables#var1 **/
        assertEquals("value1", parser.urlVariables.var1);

        /** urlVariables#var2 */
        assertEquals("value2", parser.urlVariables.var2);

        /** anchor */
        assertEquals("comments", parser.anchor);

        /** isValid should be true */
        assertEquals(parser.isValid, true);
    }

    public function test_simpleServerURL() : Void {
        var parser : URLParser = new URLParser("http://www.matanuberstein.co.za/assets/sample");

        assertEquals("http://www.matanuberstein.co.za/assets/sample", parser.url);
        assertEquals("http", parser.protocol);
        assertTrue(parser.login == null);
        assertTrue(parser.password == null);
        assertEquals("www.matanuberstein.co.za", parser.host);
        assertEquals("/assets/sample", parser.path);
        assertEquals("sample", parser.fileName);
        assertTrue(parser.fileExtension == "");
        assertEquals(parser.urlVariables, null);
        assertEquals(parser.anchor, null);
        //assertEquals(parser.isValid, true);
    }

    public function test_simpleServerPath() : Void {
        var parser : URLParser = new URLParser("assets/samples/");

        assertEquals("assets/samples/", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/assets/samples/", parser.path);
        assertEquals(parser.fileName, "");
        assertEquals(parser.fileExtension, "");
        assertEquals(parser.urlVariables, null);
        assertEquals(parser.anchor, null);
        //assertEquals(parser.isValid, false);
    }

    public function test_simpleServerPathWithOutFollowingSlash() : Void {
        var parser : URLParser = new URLParser("assets/samples");

        assertEquals("assets/samples", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/assets/samples", parser.path);
        assertEquals("samples", parser.fileName);
        assertEquals(parser.fileExtension, "");
        assertEquals(parser.urlVariables, null);
        assertEquals(parser.anchor, null);
        //assertEquals(parser.isValid, false);
    }

    public function test_tooSimpleServerPath() : Void {
        var parser : URLParser = new URLParser("samples");

        assertEquals("samples", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/samples", parser.path);
        assertEquals("samples", parser.fileName);
        assertEquals(parser.fileExtension, "");
        assertEquals(parser.urlVariables, null);
        assertEquals(parser.anchor, null);
        //assertEquals(parser.isValid, false);
    }

    public function test_correctSimpleServerPath() : Void {
        var parser : URLParser = new URLParser("samples/");

        assertEquals("samples/", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/samples/", parser.path);
        assertEquals(parser.fileName, "");
        assertEquals(parser.fileExtension, "");
        assertEquals(parser.urlVariables, null);
        assertEquals(parser.anchor, null);
        //assertEquals(parser.isValid, false);
    }

    public function test_complexPath() : Void {
        var parser : URLParser = new URLParser("assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

        assertEquals("assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/assets/sample/sampleTXT.txt", parser.path);
        assertEquals("sampleTXT.txt", parser.fileName);
        assertEquals("txt", parser.fileExtension);
        assertEquals("value1", parser.urlVariables.var1);
        assertEquals("value2", parser.urlVariables.var2);
        assertEquals("comments", parser.anchor);
        //assertEquals(parser.isValid, true);
    }

    public function test_complexPathWithLeadingSlash() : Void {
        var parser : URLParser = new URLParser("/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments");

        assertEquals("/assets/sample/sampleTXT.txt?var1=value1&var2=value2#comments", parser.url);
        assertEquals(parser.protocol, null);
        assertEquals(parser.login, null);
        assertEquals(parser.password, null);
        assertEquals(parser.host, null);
        assertEquals("/assets/sample/sampleTXT.txt", parser.path);
        assertEquals("sampleTXT.txt", parser.fileName);
        assertEquals("txt", parser.fileExtension);
        assertEquals("value1", parser.urlVariables.var1);
        assertEquals("value2", parser.urlVariables.var2);
        assertEquals("comments", parser.anchor);
        //Assert.isTrue(parser.isValid);
    }
}