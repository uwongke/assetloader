package org.assetloader.parsers;

import com.poptropica.interfaces.IPlatform;
import org.assetloader.base.LoaderFactory;
import org.assetloader.core.ILoader;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
import flash.errors.Error;

import org.assetloader.core.IAssetLoader;
import org.assetloader.core.IConfigParser;


class XmlConfigParser implements IConfigParser {

    private var _assetloader : IAssetLoader;

    private var _loaderFactory : LoaderFactory;
    private var _platform : IPlatform;
    public function new(platform : IPlatform) {
        _platform = platform;
    }

    public function isValid(data : String) : Bool {
        var xml : FastXML;

        try {
            xml = new FastXML(data);
        } catch (error : Error) {
            return false;
        }

        if (xml.node.nodeKind.innerData() != "element") {
            return false;
        }

        return true;
    }

    public function parse(assetloader : IAssetLoader, data : String) : Void {
        _assetloader = assetloader;

        _loaderFactory = new LoaderFactory(_platform);

        parseXml(new FastXML(data));

        _assetloader = null;
        _loaderFactory = null;
    }

    private function parseXml(xml : FastXML, inheritFrom : ConfigVO = null) : Void {
        var rootVo : ConfigVO = parseVo(xml, inheritFrom);
        var children : FastXMLList = xml.node.children.innerData();

        var cL : Int = children.length();
        for (i in 0...cL) {
            var vo : ConfigVO = parseVo(children.get(i), rootVo);

            if (vo.id != "" && vo.src == "") {
                var group : IAssetLoader = parseGroup(vo);
                _assetloader.addLoader(group);
                group.addConfig(vo.xml);
            }
            else if (vo.id != "" && vo.src != "") {
                _assetloader.addLoader(parseAsset(vo));
            }
            else {
                parseXml(children.get(i), vo);
            }
        }
    }

    private function parseGroup(vo : ConfigVO) : IAssetLoader {
        var loader : IAssetLoader = cast((_loaderFactory.produce(vo.id, AssetType.GROUP, null,
        getParams(vo)
        )), IAssetLoader);

        loader.numConnections = vo.connections;
        return loader;
    }

    private function parseAsset(vo : ConfigVO) : ILoader {
        return _loaderFactory.produce(vo.id, vo.type, new URLRequest(vo.src), getParams(vo));
    }

    private function parseVo(xml : FastXML, inheritFrom : ConfigVO = null) : ConfigVO {
        if (inheritFrom == null) {
            inheritFrom = new ConfigVO();
        }

        var child : ConfigVO = new ConfigVO();

        child.src = xml.att.src || "";
        child.id = xml.att.id || "";

        child.base = xml.att.base || inheritFrom.base;
        child.type = xml.att.type || inheritFrom.type;
        child.weight = convertWeight(xml.att.weight);
        child.connections = xml.att.connections || inheritFrom.connections;
        child.retries = xml.att.retries || inheritFrom.retries;
        child.priority = xml.att.priority || -1;
        child.onDemand = toBoolean(xml.att.onDemand, inheritFrom.onDemand);
        child.preventCache = toBoolean(xml.att.preventCache, inheritFrom.preventCache);

        child.transparent = toBoolean(xml.att.transparent, inheritFrom.transparent);
        child.smoothing = toBoolean(xml.att.smoothing, inheritFrom.smoothing);
        child.fillColor = ((xml.att.fillColor)) ? as3hx.Compat.parseFloat(xml.att.fillColor) : inheritFrom.fillColor;
        child.blendMode = xml.att.blendMode || inheritFrom.blendMode;
        child.pixelSnapping = xml.att.pixelSnapping || inheritFrom.pixelSnapping;

        child.type = child.type.toUpperCase();

        child.xml = xml;

        return child;
    }

    /** HELPER FUNCTIONS */
    private function getParams(vo : ConfigVO) : Array<Dynamic> {
        var params : Array<Dynamic> = [];

        if (vo.priority < 0) {
            params.push(new Param(Param.PRIORITY, vo.priority));
        }

        if (vo.base && vo.base != "") {
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

    private function convertWeight(str : String) : Int {
        if (str == null) {
            return 0;
        }

        str = str.replace(new as3hx.Compat.Regex(" ", "g"), "");

        var mbExp : as3hx.Compat.Regex = new as3hx.Compat.Regex("mb", "gi");
        if (mbExp.test(str)) {
            return as3hx.Compat.parseInt(as3hx.Compat.parseFloat(mbExp.replace(str, "")) * 1024 * 1024);
        }

        var kbExp : as3hx.Compat.Regex = new as3hx.Compat.Regex("kb", "gi");
        if (kbExp.test(str)) {
            return as3hx.Compat.parseInt(as3hx.Compat.parseFloat(kbExp.replace(str, "")) * 1024);
        }

        return as3hx.Compat.parseFloat(str);
    }

    private function toBoolean(value : String, defaultReturn : Bool) : Bool {
        value = value.toLowerCase();

        if (value == "1" || value == "yes" || value == "true") {
            return true;
        }

        if (value == "0" || value == "no" || value == "false") {
            return false;
        }

        return defaultReturn;
    }
}