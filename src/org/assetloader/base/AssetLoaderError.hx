package org.assetloader.base;

import flash.errors.Error;

/** AssetLoader errors. */
class AssetLoaderError extends Error {
    public static inline var INVALID_URL : String = "Asset's url is invalid.";
    public static inline var ASSET_TYPE_NOT_RECOGNIZED : String = "Asset type not recognized. Try an asset type found on org.assetloader.base.AssetType .";
    public static inline var ASSET_AUTO_TYPE_NOT_FOUND : String = "Could not determine asset's type automatically. Please set the asset's type.";
    public static inline var ALREADY_CONTAINS_LOADER : String = "Already contains this instance of ILoader.";
    public static inline var DOESNT_CONTAIN_LOADER : String = "Does not contain this instance of ILoader, thus it cannot be removed.";

    public function new(message : Dynamic = "", id : Dynamic = 0) {
        super("[AssetLoaderError] " + message, id);
    }

    public static function COULD_NOT_PARSE_CONFIG(id : String, message : String) : String {
        return "AssetLoader (" + id + "), Could not parse config, message from parser: " + message;
    }

    public static function ALREADY_CONTAINS_LOADER_WITH_ID(parentId : String, childId : String) : String {
        return "AssetLoader (" + parentId + ") already contains a child with the same id (" + childId + ").";
    }

    public static function CIRCULAR_REFERENCE_FOUND(id : String) : String {
        return "AssetLoader (" + id + ") has detected that somewhere in it's loading queue it contains itself.";
    }

    public static function ALREADY_CONTAINED_BY_OTHER(id : String, currentParentId : String) : String {
        return "Loader (" + id + ") is already contained by IAssetLoader (" + currentParentId + "). Remove from parent first.";
    }
}