package org.assetloader.parsers;

import openfl.display.BlendMode;
import openfl.display.PixelSnapping;

class ConfigVO {
    /** Internal */
    public var xml:Xml;

    /** IAssetLoader */
    public var connections:Int = 3;

    /** Mixed, but mostly for ILoaders */
    public var base:String = null;

    // public var id : String;
    // public var src : String;
    public var id:String = "";
    public var src:String = "";
    public var type:String = "AUTO";
    public var retries:Int = 3;
    public var weight:Int = 0;
    public var priority:Int = -1;
    public var onDemand:Bool = false;
    public var preventCache:Bool = false;

    /** ImageLoader */
    public var transparent:Bool = true;

    public var fillColor:Null<UInt> = 0x000000;
    public var blendMode:BlendMode = null;
    public var smoothing:Bool = false;
    public var pixelSnapping:PixelSnapping = PixelSnapping.AUTO;

    public function new() {}
}
