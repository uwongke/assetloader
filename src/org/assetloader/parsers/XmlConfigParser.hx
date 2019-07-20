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
    //private var _platform : IPlatform;

    public function new() {
        //_platform = platform;
    }

    public function isValid(data : String) : Bool {
        var xml: Xml;

        try {
            xml = Xml.parse(data);
        } catch (error : Error) {
            return false;
        }

        //if (xml.node.nodeKind.innerData() != "element") {
        //    return false;
        //}

        return true;
    }

    public function parse(assetloader : IAssetLoader, data : String):Void {
        _assetloader = assetloader;
        _loaderFactory = new LoaderFactory();
        parseXml(Xml.parse(data));
    }

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
        //Browser.console.log(vo.src);
        return _loaderFactory.produce(vo.id, vo.type, new URLRequest(vo.src), getParams(vo));
    }

    private function parseVo(xml:Xml, inheritFrom:ConfigVO = null):ConfigVO {
        if (inheritFrom == null) {
            inheritFrom = new ConfigVO();
        }

        var child:ConfigVO = new ConfigVO();
        var access = new haxe.xml.Access(xml);

        child.src = access.has.resolve("src") == true ? access.att.resolve("src") : "";
        child.id = access.has.resolve("id") == true ? access.att.resolve("id") : "";
        child.base = access.has.resolve("base") == true ? access.att.resolve("base") : inheritFrom.base;
        child.type = access.has.resolve("type") == true ? access.att.resolve("type") : inheritFrom.type;
        child.connections = access.has.resolve("connections") == true ? Std.parseInt(access.att.resolve("connections")) : inheritFrom.connections;
        child.retries = access.has.resolve("retries") == true ?  Std.parseInt(access.att.resolve("retries")) : inheritFrom.retries;
        child.onDemand = access.has.resolve("onDemand") == true ? toBoolean(access.att.resolve("onDemand")) : inheritFrom.onDemand;
        child.preventCache = access.has.resolve("preventCache") == true ? toBoolean(access.att.resolve("preventCache")) : inheritFrom.preventCache;
        child.transparent = access.has.resolve("transparent") == true ? toBoolean(access.att.resolve("transparent")) : inheritFrom.transparent;
        child.smoothing = access.has.resolve("smoothing") == true ? toBoolean(access.att.resolve("smoothing")) : inheritFrom.smoothing;
        child.fillColor = access.has.resolve("fillColor") == true ? Std.parseFloat(access.att.resolve("fillColor")) : inheritFrom.fillColor;
        child.blendMode = access.has.resolve("blendMode") == true ? access.att.resolve("blendMode") : inheritFrom.blendMode;
        child.pixelSnapping = access.has.resolve("pixelSnapping") == true ? access.att.resolve("pixelSnapping") : inheritFrom.pixelSnapping;
        child.priority = access.has.resolve("priority") == true ? Std.parseInt(access.att.resolve("priority")) : -1;
        child.type = child.type.toUpperCase();
        child.xml = xml;


        //Browser.console.log("=====parseVo=====");
        //Browser.console.log(child);

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

//    private function parseXml(data: Xml, inheritFrom : ConfigVO = null) : Void {
//        var rootVo:ConfigVO = parseVo(data.firstElement(), inheritFrom);
//        var access = new haxe.xml.Access(data.firstElement());
//        var children: Array<Xml> = Reflect.field(access, "children");
//
//        var filtered: Array<Xml> = new Array<Xml>();
//
//        //TODO@Wolfie -> replace with a lambda filter..
//        children.foreach((it: Xml)->{
//            var innerChildren: Array<Xml> = Reflect.field(it, "children");
//            if(innerChildren.length !=0){
//                filtered.push(it);
//            }
//            return true;
//        });
//
//        filtered.foreach((it: Xml)->{
//            var vo:ConfigVO = parseVo(it, rootVo);
//
//            Browser.console.log("=============General=============");
//            Browser.console.log(vo);
//
//            /** Handle Groups */
//            if(vo.id != "" && vo.src == "") {
//                var group:IAssetLoader = parseGroup(vo);
//                assetloader.addLoader(group);
//                group.addConfig(vo.xml.toString());
//                Browser.console.log("=============Groups=============");
//                Browser.console.log(vo);
//            }
//            else if(vo.id == "" && vo.src == ""){
//                /** Handle Assets */
//                Browser.console.log("=============Assets=============");
//                Browser.console.log(vo);
//                assetloader.addLoader(parseAsset(vo));
//            }
//            else {
//                parseXml(it, vo);
//            }
//            return true;
//        });
//
//
//
//        //Browser.console.log("=================================");
//        //Browser.console.log(filtered);
//
//        //var filtered = Lambda.filter(children, (it: Xml)->{
//        //    Reflect.field(it, "children").length !=0;
//        //    return true;
//        //}).
//
//        //var ic: Array<Xml> = Reflect.field(access, "children");
//        //if(ic.length !=0){
//        //    Browser.console.log("=================================");
//        //    Browser.console.log(filtered);
//        //}
//
//
////        var rootVo : ConfigVO = parseVo(data.firstElement(), inheritFrom);
////        var access = new haxe.xml.Access(data.firstElement());
////        var children: Array<Xml> = Reflect.field(access, "children");
////
////        children.foreach((child: Xml)->{
////            var innerChildren: Array<Xml> = Reflect.field(child, "children");
////            //Browser.console.log(innerChildren);
////
////            if(innerChildren.length !=0){
////                var vo : ConfigVO = parseVo(child, rootVo);
////
////                if((vo.id != "" || vo.id != null) && (vo.src == "" || vo.src == null)) {
////                    var group : IAssetLoader = parseGroup(vo);
////                    assetloader.addLoader(group);
////                    group.addConfig(vo.xml.toString());
////                }
////                else if(vo.id != "" && vo.src != ""){
////                    assetloader.addLoader(parseAsset(vo));
////                }
////                else {
////                    //Browser.console.log("=================================");
////                    //parseXml(child, vo);
////                }
////            }
////            return true;
////        });
//    }

//private function recurseNodes(node: Xml, vo:ConfigVO):Void {
//        var children:Array<Xml> = Reflect.field(node, "children");
//        var filtered:Array<Xml> = new Array<Xml>();
//
//        /** Filter out empty nodes */
//        children.foreach((it: Xml)->{
//            var innerChildren: Array<Xml> = Reflect.field(it, "children");
//            if(children.length !=0){ filtered.push(it); }
//            return true;
//        });
//
//        var test = Reflect.field(node, "nodeName");
//
//        Browser.console.log(test);
//
//        switch(Reflect.field(node, "nodeName")){
//            case "group": {
//                //var group : IAssetLoader = parseGroup(vo);
//                //assetloader.addLoader(group);
//                //group.addConfig(vo.xml.toString());
//                //parseXml(node, vo);
//                Browser.console.log("group");
//                Browser.console.log(node);
//            }
//            case "asset": {
//                //var asset = parseAsset(vo);
//                //assetloader.addLoader(asset);
//
//                Browser.console.log("asset");
//                Browser.console.log(node);
//            }
//            default:
//                //parseXml(node, vo);
//                //Browser.console.log("default");
//                //Browser.console.log(node);
//        }
//
//        //filtered.foreach((it: Xml)->{
//        //    if(Reflect.field(it, "nodeName") !=null){
//        //        var voo:ConfigVO = parseVo(it, vo);
//                //recurseNodes(it, voo);
//        //    }
//        //    return true;
//        //});
//
//
////        switch(Reflect.field(node, "nodeName")){
////            case "group": {
////                var group : IAssetLoader = parseGroup(vo);
////                //Browser.console.log(group);
////                assetloader.addLoader(group);
////                group.addConfig(vo.xml.toString());
////                var groupChildren: Array<Xml> = Reflect.field(node, "children");
////                groupChildren.foreach((it: Xml)->{
////                    if(Reflect.field(it, "nodeName") !=null){
////                        var voo:ConfigVO = parseVo(it, vo);
////                        recurseNodes(it, voo);
////                    };
////                    return true;
////                });
////                //Browser.console.log(groupChildren);
////            }
////            case "asset": {
////                var asset = parseAsset(vo);
////                //Browser.console.log(asset);
////                assetloader.addLoader(asset);
////            }
////            default: {
////                //Browser.console.log(node);
////                //parseXml(node, vo);
////            }
////        }
//
//        //filtered.foreach((it: Xml)->{
//        //    if(Reflect.field(it, "nodeName") !=null){
//        //        var voo:ConfigVO = parseVo(it, vo);
//        //        recurseNodes(it, voo);
//        //    }
//        //    return true;
//        //});
//    }

//var rootVo:ConfigVO = parseVo(xml.firstElement(), inheritFrom);

//var children:Array<Xml> = Reflect.field(xml.firstElement(), "children");
//var topLevel:Array<Xml> = new Array<Xml>();

//children.foreach((it: Xml)->{
//    var innerChildren: Array<Xml> = Reflect.field(it, "children");
//    if(innerChildren.length !=0){
//        topLevel.push(it);
//    }
//    return true;
//});

//topLevel.foreach((it: Xml)->{
//    var vo:ConfigVO = parseVo(it, rootVo);
//    recurseNodes(it, vo);
//    return true;
//});

//var filtered = filterChildren(children);
//Browser.console.log(children);



/** Intentional shadowing... */
//        children  = Reflect.field(xml, "children");
//        children.foreach((it: Xml)->{
//            //Browser.console.log(it);
//
//            var vo:ConfigVO = parseVo(it.firstElement(), rootVo);
//
//
//            if(vo.id != "" && vo.src == "") {
//                //Browser.console.log("=====GROUP=====");
//                //Browser.console.log(vo);
//                //var group : IAssetLoader = parseGroup(vo);
//                //_assetloader.addLoader(group);
//                //group.addConfig(vo.xml.toString());
//            }
//            else if(vo.id != "" && vo.src != ""){
//                //Browser.console.log("=====ASSET=====");
//                //Browser.console.log(vo);
//                //_assetloader.addLoader(parseAsset(vo));
//            }
//            else {
//                //Browser.console.log("=====OTHER=====");
//                //Browser.console.log(it);
//                //Browser.console.log(vo);
//                //parseXml(it, vo);
//            }
//
//            return true;
//        });