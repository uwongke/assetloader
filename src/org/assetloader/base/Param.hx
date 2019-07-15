package org.assetloader.base;

import org.assetloader.core.IParam;

/** Provides assets with parameters. */
class Param implements IParam {
    public var id(get, never) : String;
    public var value(get, never) : Dynamic;

    /** Adds a base path to the url. e.g. request.url = base + url; */
    public static inline var BASE : String = "BASE";

    /** Adds time stamp to url, which makes each call unique. */
    public static inline var PREVENT_CACHE : String = "PREVENT_CACHE";

    /** Amount of times the loading is retried. */
    public static inline var RETRIES : String = "RETRIES";

    /** Amount of times the loading is retried. */
    public static inline var PRIORITY : String = "PRIORITY";

    /** Set true if you DON'T want the asset to from part of the loading queue.
		This way you must start the asset's loading manually via IAssetLoader startAsset method. */
    public static inline var ON_DEMAND : String = "ON_DEMAND";

    /** Sets the bytesTotal amount of the file, this will improve accuracy of the
		progress bar. This is optional, because the bytesTotal is retrieved from the server
		when the progress events start coming through. You can set this with a vague value as
		it will be overritten by the value retreived from the server. */
    public static inline var WEIGHT : String = "WEIGHT";

    /** Sets the URLRequest's headers. */
    public static inline var HEADERS : String = "HEADERS";

    /** Use: DisplayObject, Image and Swf asset types */
    public static inline var LOADER_CONTEXT : String = "LOADER_CONTEXT";

    /** Sets BitmapData's transparency. */
    public static inline var TRANSPARENT : String = "TRANSPARENT";

    /** Sets BitmapData's fill color. */
    public static inline var FILL_COLOR : String = "FILL_COLOR";

    /** Sets BitmapData's matrix. */
    public static inline var MATRIX : String = "MATRIX";

    /** Sets BitmapData's color transform. */
    public static inline var COLOR_TRANSFROM : String = "COLOR_TRANSFROM";

    /** Sets <code>BitmapData</code>'s blend mode. */
    public static inline var BLEND_MODE : String = "BLEND_MODE";

    /** Sets BitmapData's clipping rectangle. */
    public static inline var CLIP_RECTANGLE : String = "CLIP_RECTANGLE";

    /** Sets Bitmap's pixel snapping.  */
    public static inline var PIXEL_SNAPPING : String = "PIXEL_SNAPPING";

    /** Sets Bitmap and BitmapData's smoothing property. */
    public static inline var SMOOTHING : String = "SMOOTHING";

    /** Sets Sound's load context. */
    public static inline var SOUND_LOADER_CONTEXT : String = "SOUND_LOADER_CONTEXT";

    /** If NetStream should load cross-domain policy file. */
    public static inline var CHECK_POLICY_FILE : String = "CHECK_POLICY_FILE";

    /** Adds NetStream client callback Object. */
    public static inline var CLIENT : String = "CLIENT";

    /** Allows you to attach any object/instance to an ILoader. */
    public static inline var USER_DATA : String = "USER_DATA";

    private var _id : String;

    private var _value : Dynamic;

    /** @param id Param id. */
    public function new(id : String, value : Dynamic) {
        _id = id;
        _value = value;
    }

    private function get_id() : String {
        return _id;
    }

    private function get_value() : Dynamic {
        return _value;
    }
}
