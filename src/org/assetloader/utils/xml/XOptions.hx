package org.assetloader.utils.xml;

class XOptions {
    public var indent:UInt;
    public var lineEnd:String;
    public var indentChar:String;
    public var inlineTags:Array<String>;
    public var attributeSorting:Int;
    public var attributesOnNewLine:Bool;
    public var gtOnNewLine:Int;
    public var ignorePIs:Bool;
    public var ignoreComments:Bool;
    public var ignoreWhite:Bool;
    public var outputProlog:Bool;
    public var xmlVersion:String;
    public var xmlEncoding:String;
    public var useSingleQuotes:Bool;
    public var wrapEqWithSpaces:Bool;
    public var alwaysExpand:Bool;

    public function new() {
        this.indent = 1;
        this.lineEnd = "\r";
        this.indentChar = "\t";
        this.attributeSorting = -1;
        this.attributesOnNewLine = false;
        this.gtOnNewLine = 0;
        this.ignorePIs = false;
        this.ignoreComments = false;
        this.ignoreWhite = true;
        this.outputProlog = false;
        this.xmlVersion = "1.0";
        this.xmlEncoding = "utf-8";
        this.useSingleQuotes = false;
        this.wrapEqWithSpaces = false;
        this.alwaysExpand = true;// false;
    }
}