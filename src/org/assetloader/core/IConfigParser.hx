package org.assetloader.core;

/** Parses and builds loading queues from String data. */
import org.assetloader.parsers.ConfigVO;
interface IConfigParser {
    /** Test data to see if it can be parsed. */
    function isValid(data : String) : Bool ;

    /** Implementation should convert String into respective type and add the parsed
		assets into their respective parent IAssetLoader */
    function parse(assetloader:IAssetLoader, data:String):Void ;
    function parseXml(xml: Xml, inheritFrom: ConfigVO = null):Void;
}
