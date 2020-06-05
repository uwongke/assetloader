package org.assetloader.loaders;

import openfl.errors.Error;
import openfl.net.URLRequest;
import org.assetloader.base.AssetType;
import org.assetloader.signals.LoaderSignal;

class XMLLoader extends TextLoader {
    /** Gets the resulting XML after loading and parsing is complete. */
    private var _xml:Xml;

    public var xml(get, never):Xml;

    private function get_xml():Xml {
        return _xml;
    }

    public function new(request:URLRequest, ?xml:Xml, ?id:String = null) {
        super(request, id);
        _type = AssetType.XML;
        if (xml != null) {
            _xml = xml;
        }
    }

    override private function initSignals():Void {
        super.initSignals();
        _onComplete = new LoaderSignal([Xml]);
    }

    override public function destroy():Void {
        super.destroy();
        _xml = null;
    }

    override private function testData(data:String):String {
        try {
            _data = _xml = Xml.parse(data);
        } catch (err:Error) {
            return err.message;
        }

        if (xml != null) {
            // if (xml.node.nodeKind.innerData() != "element") {
            //    return "Not valid XML.";
            // }
        }

        return "";
    }
}
