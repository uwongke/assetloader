package org.assetloader.parsers;


import openfl.net.URLRequest;
import org.assetloader.core.ILoader;
import org.assetloader.base.LoaderFactory;
import org.assetloader.base.Param;
import org.assetloader.base.AssetType;
import haxe.DynamicAccess;
import test.org.assetloader.parsers.XmlConfigSchema;
import js.Browser;
import haxe.Json;

import haxe.macro.ExprTools.ExprArrayTools;
import com.poptropica.interfaces.IPlatform;
//import org.assetloader.base.LoaderFactory;
//import org.assetloader.core.ILoader;
//import org.assetloader.base.AssetType;
//import openfl.net.URLRequest;
//import flash.errors.Error;

import org.assetloader.core.IAssetLoader;
import org.assetloader.core.IConfigParser;

using Lambda;


class XmlConfigParser implements IConfigParser {

    private var _assetloader : IAssetLoader;
    private var _loaderFactory : LoaderFactory;
    private var _platform : IPlatform;

    public function new(platform : IPlatform) {
        //_platform = platform;
    }

    public function isValid(data : String) : Bool {
        //var xml : FastXML;

        //try {
        //    xml = new FastXML(data);
        //} catch (error : Error) {
        //    return false;
        //}

        //if (xml.node.nodeKind.innerData() != "element") {
        //    return false;
        //}

        return true;
    }

    public function parse(assetloader: IAssetLoader, data: String) : Void {
        _assetloader = assetloader;
        _loaderFactory = new LoaderFactory(_platform);
        parseXml(Xml.parse(data));

        _assetloader = null;
        _loaderFactory = null;
    }

    private function parseXml(data: Xml, inheritFrom : ConfigVO = null) : Void {
        var rootVo : ConfigVO = parseVo(data, inheritFrom);

        var access = new haxe.xml.Access(data.firstElement());
        var children: Array<Xml> = Reflect.field(access, "children");

        children.foreach((child)->{
            var children: Array<Xml> = Reflect.field(child, "children");
            if(children.length !=0){
                var vo : ConfigVO = parseVo(child, rootVo);
                if((vo.id != "" || vo.id != null) && (vo.src == "" || vo.src == null)) {
                    var group : IAssetLoader = parseGroup(vo);
                    //_assetloader.addLoader(group);
                    //group.addConfig(vo.xml);
                }
                else if((vo.id != "" || vo.id != null) && (vo.src != "" || vo.src != null)){
                    Browser.console.log("IS THIS CONDITION WORKING?????");
                    _assetloader.addLoader(parseAsset(vo));
                }

                else{
                    parseXml(child, vo);
                }

            }
            return true;
        });
    }

    private function parseGroup(vo : ConfigVO) : IAssetLoader {
        var loader : IAssetLoader = cast((_loaderFactory.produce(vo.id, AssetType.GROUP, null, getParams(vo))), IAssetLoader);
        //Browser.console.log("============================");
        //Browser.console.log(loader);
        if(loader !=null){
            loader.numConnections = vo.connections;
        }

        return loader;
    }

    private function parseAsset(vo : ConfigVO) : ILoader {
        return _loaderFactory.produce(vo.id, vo.type, new URLRequest(vo.src), getParams(vo));
    }


    private function parseVo(data: Xml, inheritFrom : ConfigVO = null) : ConfigVO {
        inheritFrom = inheritFrom == null ? new ConfigVO() : inheritFrom;

        var child : ConfigVO = new ConfigVO();
        var attributes = Reflect.fields(inheritFrom);

        /** wrap the Xml for Access */
        var access = new haxe.xml.Access(data.firstElement());

        /** Set the fields either to Xml value via reflection */
        attributes.foreach((it)->{
            switch(access.has.resolve(it)){
                case true: Reflect.setField(child, it, access.att.resolve(it));
                default: {};
            }
            return true;
        });

        Browser.console.log(child);
        return child;
    }

    /** HELPER FUNCTIONS */
    private function getParams(vo : ConfigVO) : Array<Dynamic> {
        var params : Array<Dynamic> = [];

        if (vo.priority < 0) {
            params.push(new Param(Param.PRIORITY, vo.priority));
        }

        if (vo.base !=null && vo.base != "") {
            params.push(new Param(Param.BASE, vo.base));
        }

        params.push(new Param(Param.WEIGHT, vo.weight));
        params.push(new Param(Param.RETRIES, vo.retries));
        params.push(new Param(Param.ON_DEMAND, vo.onDemand));
        params.push(new Param(Param.PREVENT_CACHE, vo.preventCache));

        params.push(new Param(Param.TRANSPARENT, vo.transparent));
        params.push(new Param(Param.SMOOTHING, vo.smoothing));
        params.push(new Param(Param.FILL_COLOR, vo.fillColor));
        params.push(new Param(Param.BLEND_MODE, vo.blendMode));
        params.push(new Param(Param.PIXEL_SNAPPING, vo.pixelSnapping));

        return params;
    }

    //private function convertWeight(str : String) : Int {
    //    if (str == null) {
    //        return 0;
    //    }

        //str = StringTools.replace(new as3hx.Compat.Regex(" ", "g"), "");
        //var mbExp : as3hx.Compat.Regex = new as3hx.Compat.Regex("mb", "gi");
        //if (mbExp.test(str)) {
        //    return as3hx.Compat.parseInt(as3hx.Compat.parseFloat(mbExp.replace(str, "")) * 1024 * 1024);
        //}
        //var kbExp : as3hx.Compat.Regex = new as3hx.Compat.Regex("kb", "gi");
        //if (kbExp.test(str)) {
        //    return as3hx.Compat.parseInt(as3hx.Compat.parseFloat(kbExp.replace(str, "")) * 1024);
        //}

        //return as3hx.Compat.parseFloat(str);

        //str = str.replace(new as3hx.Compat.Regex(" ", "g"), "");
    //}

//    private function toBoolean(value : String, defaultReturn : Bool) : Bool {
//        value = value.toLowerCase();
//
//        if (value == "1" || value == "yes" || value == "true") {
//            return true;
//        }
//
//        if (value == "0" || value == "no" || value == "false") {
//            return false;
//        }
//
//        return defaultReturn;
//    }
}

//default: Reflect.setField(child, it, Reflect.field(child, it));