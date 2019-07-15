package org.assetloader.loaders;

/** WebSWFLoader is just like SWFLoader,
	but it adds an additional parameter: <code>Param.LOADER_CONTEXT</code>
	which alleviates Security Sandbox Violations when assets
	are stored on Akamai (which is a different domain). */
import openfl.system.SecurityDomain;
import openfl.system.LoaderContext;
import org.assetloader.base.Param;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
class WebSWFLoader extends SWFLoader {
    public function new(request : URLRequest, id : String = null) {
        super(request, id);
        _type = AssetType.SWF;
        addParam(new Param(Param.LOADER_CONTEXT, new LoaderContext(false, null, SecurityDomain.currentDomain)));
    }
}