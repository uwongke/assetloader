package org.assetloader.loaders;

import openfl.display.DisplayObject;
import openfl.display.Loader;

class LoaderUtil {

    /** Detaches the Loader from the object that was retrieved.
        Not detaching the Loader causes an exception when trying to add
        the DisplayObject to another DisplayObjectContainer.
        Called by the loaders tha
        Poptropica Addition. */
    @:access(openfl.display.Loader)
    @:access(openfl.display.DisplayObject)
    public static function removeLoaderParentage(_loader:Loader, _displayObject:DisplayObject):Void {
        // Can't do a _loader.removeChild() because Loader throws an exception.
        if (null != _displayObject) {
            if (null != _loader) {
                #if (openfl < "9.0.0")
                _loader.__children.remove(_displayObject);
                #end
                _loader.__removedChildren.push(_displayObject);
            }

            if (_displayObject.parent == _loader) {
                _displayObject.parent = null;
                _displayObject.__setTransformDirty();
                _displayObject.__setRenderDirty();
            }
        }

    }
}