package org.assetloader.parsers;

class ConfigVO {
    /** Internal */
    public var xml : Xml;

    /** IAssetLoader */
    public var connections : Int = 3;

    /** Mixed, but mostly for ILoaders */
    public var base : String = null;
    //public var id : String = "";
    //public var src : String = "";
    public var id : String;
    public var src : String;
    public var type : String = "AUTO";
    public var retries : Int = 3;
    public var weight : Int = 0;
    public var priority : Int = -1;
    public var onDemand : Bool = false;
    public var preventCache : Bool = false;

    /** ImageLoader */
    public var transparent : Bool = true;
    public var fillColor : Float = 4.294967295E9;
    public var blendMode : String = null;
    public var smoothing : Bool = false;
    public var pixelSnapping : String = "auto";


    public function new() {}
}