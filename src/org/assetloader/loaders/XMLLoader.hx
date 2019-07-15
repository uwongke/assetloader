package org.assetloader.loaders;

import flash.errors.Error;
import org.assetloader.signals.LoaderSignal;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
class XMLLoader extends TextLoader {
    public var xml(get, never) : FastXML;


    private var _xml : FastXML;

    public function new(request : URLRequest, id : String = null) {
        super(request, id);
        _type = AssetType.XML;
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onComplete = new LoaderSignal(FastXML);
    }

    override public function destroy() : Void {
        super.destroy();
        _xml = null;
    }

    override private function testData(data : String) : String {
        try {
            _data = _xml = new FastXML(data);
        } catch (err : Error) {
            return err.message;
        }

        if (xml != null) {
            if (xml.node.nodeKind.innerData() != "element") {
                return "Not valid XML.";
            }
        }

        return "";
    }

    /** Gets the resulting XML after loading and parsing is complete. */
    private function get_xml() : FastXML {
        return _xml;
    }
}