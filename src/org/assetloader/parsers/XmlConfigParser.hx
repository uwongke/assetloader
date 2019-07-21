package org.assetloader.parsers;


import openfl.errors.Error;
import openfl.net.URLRequest;
import org.assetloader.core.ILoader;
import org.assetloader.base.LoaderFactory;
import org.assetloader.base.Param;
import org.assetloader.base.AssetType;
import js.Browser;

import org.assetloader.core.IAssetLoader;
import org.assetloader.core.IConfigParser;

using Lambda;

class XmlConfigParser implements IConfigParser {

    /** AssetLoader Property */
    private var _assetloader:IAssetLoader;
    @:isvar public var assetloader(get, set):IAssetLoader;
    public function get_assetloader(): IAssetLoader {
        return _assetloader;
    }
    public function set_assetloader(value: IAssetLoader): IAssetLoader {
        return _assetloader = value;
    }

    private var _loaderFactory : LoaderFactory;

    public function new() {}

    public function isValid(data : String) : Bool {
        var xml: Xml;

        try {
            xml = Xml.parse(data);
        } catch (error : Error) {
            return false;
        }

        return true;
    }

    public function parse(assetloader : IAssetLoader, data : String):Void {
        _assetloader = assetloader;
        _loaderFactory = new LoaderFactory();
        parseXml(Xml.parse(data));
    }

    /** These handlers can be consolidated but for now let's leave them like this to make it easier to troubleshoot */

    private function handleGroupAsset(node: Xml, vo:ConfigVO, group: IAssetLoader): Void {
        group.addLoader(parseAsset(parseVo(node, vo)));
    }

    private function handleAssets(node: Xml, vo:ConfigVO, loader: IAssetLoader): Void {
        var assets: Array<Xml> = Reflect.field(node, "children");
        assets.foreach((it: Xml)->{
            var nodeName = Reflect.field(it, "nodeName");
            if(nodeName !=null && nodeName == "asset"){
                loader.addLoader(parseAsset(parseVo(it, vo)));
            }
            return true;
        });
    }

    private function handleNestedGroup(node: Xml, vo:ConfigVO, parentGroup: IAssetLoader): Void {
        var group:IAssetLoader = parseGroup(vo);
        parentGroup.addLoader(group);
        group.addConfig(vo.xml.toString());

        /** Process Asset */
        var nested: Array<Xml> = Reflect.field(node, "children");
        nested.foreach((it: Xml)->{
            switch(Reflect.field(it, "nodeName")){
                case "asset": handleGroupAsset(it, vo, group);
                case "group": handleNestedGroup(it, parseVo(it, vo), group);
            }
            return true;
        });
    }

    private function handleGroup(node:Xml, vo:ConfigVO): Void {
        /** Process Group */
        var group:IAssetLoader = parseGroup(vo);
        _assetloader.addLoader(group);
        group.addConfig(vo.xml.toString());

        /** Process Asset */
        var nested: Array<Xml> = Reflect.field(node, "children");
        nested.foreach((it: Xml)->{
            switch(Reflect.field(it, "nodeName")){
                case "asset": handleGroupAsset(it, vo, group);
                case "group": handleNestedGroup(it, parseVo(it, vo), group);
            }
            return true;
        });
    }

    public function parseXml(xml: Xml, inheritFrom: ConfigVO = null):Void {
        var children: Array<Xml> = new Array<Xml>();

        xml.firstElement().foreach((it)->{
            var innerChildren: Array<Xml> = Reflect.field(it, "children");
            if(innerChildren.length !=0){
                children.push(it);
            }
            return true;
        });

        var rootVo:ConfigVO = parseVo(xml.firstElement(), inheritFrom);

        children.foreach((it: Xml)->{
            var vo:ConfigVO = parseVo(it, rootVo);
            switch(Reflect.field(it, "nodeName")){
                case "group": handleGroup(it, vo);
                case "assets": handleAssets(it, vo, _assetloader);
            }

            return true;
        });
    }

    private function parseGroup(vo : ConfigVO) : IAssetLoader {
        var loader : IAssetLoader = cast((_loaderFactory.produce(vo.id, AssetType.GROUP, null, getParams(vo))), IAssetLoader);
        loader.numConnections = vo.connections;
        return loader;
    }

    private function parseAsset(vo : ConfigVO) : ILoader {
        return _loaderFactory.produce(vo.id, vo.type, new URLRequest(vo.src), getParams(vo));
    }

    private function parseVo(xml:Xml, inheritFrom:ConfigVO = null):ConfigVO {
        if (inheritFrom == null) {
            inheritFrom = new ConfigVO();
        }

        var child:ConfigVO = new ConfigVO();
        var access = new haxe.xml.Access(xml);

        var attributes = Reflect.fields(inheritFrom);
        var access = new haxe.xml.Access(xml);

        /**Set the fields either to Xml value or default (via reflection) */
        attributes.foreach((it)->{
            switch(access.has.resolve(it)){
                case true: {
                    var value = access.att.resolve(it);
                    Reflect.setField(child, it, value);
                }
                default: Reflect.setField(child, it, Reflect.field(inheritFrom, it));
            }
            return true;
        });

        child.onDemand = access.has.resolve("onDemand") == true ? toBoolean(access.att.resolve("onDemand")) : inheritFrom.onDemand;
        child.preventCache = access.has.resolve("preventCache") == true ? toBoolean(access.att.resolve("preventCache")) : inheritFrom.preventCache;
        child.transparent = access.has.resolve("transparent") == true ? toBoolean(access.att.resolve("transparent")) : inheritFrom.transparent;
        child.smoothing = access.has.resolve("smoothing") == true ? toBoolean(access.att.resolve("smoothing")) : inheritFrom.smoothing;
        child.type = child.type.toUpperCase();
        child.xml = xml;

        //child.src = access.has.resolve("src") == true ? access.att.resolve("src") : "";
        //child.id = access.has.resolve("id") == true ? access.att.resolve("id") : "";
        //child.base = access.has.resolve("base") == true ? access.att.resolve("base") : inheritFrom.base;
        //child.type = access.has.resolve("type") == true ? access.att.resolve("type") : inheritFrom.type;
        //child.connections = access.has.resolve("connections") == true ? Std.parseInt(access.att.resolve("connections")) : inheritFrom.connections;
        //child.retries = access.has.resolve("retries") == true ?  Std.parseInt(access.att.resolve("retries")) : inheritFrom.retries;
        //child.fillColor = access.has.resolve("fillColor") == true ? Std.parseFloat(access.att.resolve("fillColor")) : inheritFrom.fillColor;
        //child.blendMode = access.has.resolve("blendMode") == true ? access.att.resolve("blendMode") : inheritFrom.blendMode;
        //child.pixelSnapping = access.has.resolve("pixelSnapping") == true ? access.att.resolve("pixelSnapping") : inheritFrom.pixelSnapping;
        //child.priority = access.has.resolve("priority") == true ? Std.parseInt(access.att.resolve("priority")) : -1;

        //if(access.has.resolve("weight")){
            //var weight = convertWeight(access.att.resolve("weight"));
            //Browser.console.log("===============");
            //Browser.console.log(weight);
        //}

        //child.src = access.has.resolve("weight") == true ? access.att.resolve("weight") : "";
        return child;
    }

//    private function parseVo(data: Xml, inheritFrom : ConfigVO = null) : ConfigVO {
//        inheritFrom = inheritFrom == null ? new ConfigVO() : inheritFrom;
//
//        var child : ConfigVO = new ConfigVO();
//        var attributes = Reflect.fields(inheritFrom);
//
//        /** wrap the Xml for Access */
//        //var access = new haxe.xml.Access(data.firstElement());
//        var access = new haxe.xml.Access(data);
//
//        /**Set the fields either to Xml value or default (via reflection) */
//        attributes.foreach((it)->{
//            switch(access.has.resolve(it)){
//                case true: {
//                    Reflect.setField(child, it, access.att.resolve(it));
//                }
//                default: Reflect.setField(child, it, Reflect.field(inheritFrom, it));
//            }
//            return true;
//        });
//        child.xml = data;
//        return child;
//    }


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

    //TODO@Wolfie -> re-introduce weight conversions

    private function convertWeight(str : String) : Int {
        if(str == null) {
            return 0;
        }

        var test = new as3hx.Compat.Regex(" ", "g");
        //Browser.console.log("==================");
        //Browser.console.log(test);
        //Browser.console.log("==================");
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
        return 0;
    }

    private function toBoolean(value:String):Bool {
        value = value.toLowerCase();

        if (value == "1" || value == "yes" || value == "true") {
            return true;
        }

        if (value == "0" || value == "no" || value == "false") {
            return false;
        }
        return false;
    }
}