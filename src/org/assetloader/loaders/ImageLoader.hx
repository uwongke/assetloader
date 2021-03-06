package org.assetloader.loaders;

import openfl.errors.Error;
import org.assetloader.base.AssetType;
import org.assetloader.base.Param;
import org.assetloader.signals.LoaderSignal;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.net.URLRequest;
import openfl.events.ErrorEvent;
import openfl.events.Event;
import openfl.errors.Error;
import openfl.display.Sprite;
import openfl.geom.*;

/**
 * @author Matan Uberstein
 */
class ImageLoader extends DisplayObjectLoader {
    public var bitmapData(get, never):BitmapData;
    public var bitmap(get, never):Bitmap;

    /**
     * @private
     */
    private var _bitmapData:BitmapData;

    /**
     * @private
     */
    private var _bitmap:Bitmap;

    public function new(request:URLRequest, id:String = null) {
        super(request, id);
        _type = AssetType.IMAGE;
    }

    /**
     * @private
     */
    override private function initSignals():Void {
        super.initSignals();
        _onComplete = new LoaderSignal([Bitmap]);
    }

    /**
     * @inheritDoc
     */
    override public function destroy():Void {
        super.destroy();
        if(_bitmapData != null)
            _bitmapData.dispose();
        _bitmap = null;
    }

    /**
     * @private
     *
     * @inheritDoc
     */
    override private function testData(data:DisplayObject):String {
        var errMsg:String = "";

        try {
            /*
                var sourceBitmapData:BitmapData = cast((data), Bitmap).bitmapData;
                var transparent:Bool = ((getParam(Param.TRANSPARENT) == null)) ? sourceBitmapData.transparent : getParam(Param.TRANSPARENT);
                _bitmapData = new BitmapData(Std.int(_loader.contentLoaderInfo.width), Std.int(_loader.contentLoaderInfo.height), transparent,
                    getParam(Param.FILL_COLOR));
                _bitmapData.draw(sourceBitmapData, getParam(Param.MATRIX), getParam(Param.COLOR_TRANSFROM), getParam(Param.BLEND_MODE),
                    getParam(Param.CLIP_RECTANGLE), getParam(Param.SMOOTHING));
                _data = _bitmap = new Bitmap(_bitmapData, getParam(Param.PIXEL_SNAPPING), getParam(Param.SMOOTHING));
             */

            _data = _bitmap = cast(data, Bitmap);
        } catch (err:Error) {
            errMsg = err.message;
        }

        return errMsg;
    }

    /**
     * Gets the resulting BitmapData after loading is complete.
     *
     * @return BitmapData
     */
    private function get_bitmapData():BitmapData {
        return _bitmapData;
    }

    /**
     * Gets the resulting Bitmap after loading is complete.
     *
     * @return Bitmap
     */
    private function get_bitmap():Bitmap {
        return _bitmap;
    }
}
