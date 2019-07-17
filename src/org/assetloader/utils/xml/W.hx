package org.assetloader.utils.xml;


import haxe.ds.HashMap;

/** Xml walker utility class. */
class W {
    private var _root:Xml;
    private var _parent:Xml;
    private var _current:Array<Xml>;
    private var _attributes:Array<HashMap<String>>;
    private var _texts:Array<Null<String>>;
    private var _retCode:Int;

    /** Creates new walking operation.
		The XML document or fragment to start walking from. */
    public function new(value:Xml) {
        this._root = value;
        this._retCode = 0;
        this._current = new Array<Xml>();
        if (value != null && value.nodeType == Xml.Document){
            _current.push(value.firstElement());
        } else if (value != null) {
            _current.push(value);
        }
    }

    /** Creates new walking operation. */
    public static function alk(value:Xml):W { return new W(value); }

    /** Filters child nodes. */
    public function c(?x:Null<Xml>->Int->Bool):W {
        var it:Iterator<Null<Xml>> = _current.iterator();
        var itw:Iterator<Null<Xml>>;
        var working:Array<Xml> = null;
        var a:Array<Xml> = null;
        var node:Xml;
        var i:Int = 0;

        while (it.hasNext()) {
            node = cast it.next();
            if (node.nodeType == Xml.Element) {
                if (working == null) working = new Array<Xml>();
                itw = node.iterator();
                while (itw.hasNext()) working.push(itw.next());
            }
        }
        if (working != null) {
            it = working.iterator();
            while (it.hasNext()) {
                if (a == null) a = new Array<Xml>();
                node = cast it.next();
                if (x != null) {
                    if (x(node, i)) a.push(node);
                }
                else a.push(node);
                i++;
            }
        }
        this._current = a;
        this._retCode = 0;
        return this;
    }

    /** Filters child nodes. */
    public function d(?x:Null<Xml>->Bool):W {
        var it:Iterator<Null<Xml>> = this._current.iterator();
        var working:Array<Xml> = null;
        var a:Array<Xml> = null;
        var node:Xml;

        while (it.hasNext()) {
            node = cast it.next();
            if (node.nodeType == Xml.Element) {
                if (working == null) working = new Array<Xml>();
                working = working.concat(this.rec(node));
            }
            else {
                if (working == null) working = new Array<Xml>();
                working.push(node);
            }
        }
        if (working != null) {
            it = working.iterator();
            while (it.hasNext()) {
                if (a == null) a = new Array<Xml>();
                node = cast it.next();
                if (x != null) {
                    if (x(node)) a.push(node);
                }
                else a.push(node);
            }
        }
        this._current = a;
        this._retCode = 0;
        return this;
    }

    /** Filters child nodes. */
    public function p(?x:Null<Xml>->Int->Bool):W {
        var it:Iterator<Null<Xml>> = this._current.iterator();
        var itw:Iterator<Null<Xml>>;
        var working:Array<Xml> = null;
        var a:Array<Xml> = null;
        var node:Xml;
        var pnode:Xml;
        var i:Int = 0;

        while (it.hasNext()) {
            node = cast it.next();
            pnode = node.parent;
            if (pnode != null) {
                if (working == null) working = new Array<Xml>();
                if (!Lambda.has(working, pnode)) working.push(pnode);
                else if (working.length == 0) working = null;
            }
        }
        if (working != null) {
            it = working.iterator();
            while (it.hasNext()) {
                if (a == null) a = new Array<Xml>();
                node = cast it.next();
                if (x != null) {
                    if (x(node, i)) a.push(node);
                }
                else a.push(node);
                i++;
            }
        }
        this._current = a;
        this._retCode = 0;
        return this;
    }

    /** Filters child nodes. */
    public function a(?x:String->String->Xml->Bool):W {
        var it:Iterator<Null<Xml>> = this._current.iterator();
        var ait:Iterator<String>;
        var node:Xml;
        var atts:HashMap<String> = null;
        var allatts:Array<HashMap<String>> = null;
        var s:String;
        var vs:String;
        var a:Array<Xml> = null;

        while (it.hasNext()) {
            node = cast it.next();
            if (node.nodeType != Xml.Element) continue;
            ait = node.attributes();
            atts = null;
            if (allatts == null) allatts = new Array<HashMap<String>>();
            while (ait.hasNext()) {
                if (x == null) {
                    if (atts == null) atts = new HashMap<String>();
                    s = cast ait.next();
                    atts.set(s, node.get(s));
                    if (a == null) a = new Array<Xml>();
                    a.push(node);
                }
                else {
                    s = cast ait.next();
                    vs = node.get(s);
                    if (x(s, vs, node)) {
                        if (atts == null) atts = new HashMap<String>();
                        atts.set(s, vs);
                        if (a == null) a = new Array<Xml>();
                        a.push(node);
                    }
                }
            }
            if (atts != null) allatts.push(atts);
        }
        this._attributes = allatts;
        this._current = a;
        this._retCode = 1;
        return this;
    }

    public function v(?x:Null<Xml>->Bool):W {
        return this;
    }

    /** Filters child nodes. */
    public function t(?x:Null<String>->Xml->Bool):W {
        var it:Iterator<Null<Xml>> = this._current.iterator();
        var itt:Iterator<Null<Xml>>;
        var itw:Iterator<Null<String>>;
        var working:Array<Null<String>> = null;
        var a:Array<Null<String>> = null;
        var ca:Array<Xml> = null;
        var node:Xml;
        var vnode:Xml;
        var tnode:String;
        var i:Int = 0;

        while (it.hasNext()) {
            node = cast it.next();
            if (node.nodeType == Xml.Element) {
                itt = node.iterator();
                while (itt.hasNext()) {
                    vnode = cast itt.next();
                    if (vnode.nodeType == Xml.CData || vnode.nodeType == Xml.PCData) {
                        if (working == null) working = new Array<Null<String>>();
                        working.push(vnode.nodeValue);
                        if (ca == null) ca = new Array<Xml>();
                        ca.push(vnode);
                    }
                }
            }
            else if (node.nodeType == Xml.CData || node.nodeType == Xml.PCData) {
                if (working == null) working = new Array<Null<String>>();
                working.push(node.nodeValue);
                if (ca == null) ca = new Array<Xml>();
                ca.push(node);
            }
        }
        if (working != null) {
            itw = working.iterator();
            while (itw.hasNext()) {
                if (a == null) a = new Array<Null<String>>();
                tnode = cast itw.next();
                if (x != null) {
                    if (x(tnode, ca[i])) {
                        i++;
                        a.push(tnode);
                    }
                    else ca.splice(i, 1);
                }
                else {
                    i++;
                    a.push(tnode);
                }
            }
        }
        this._current = ca;
        this._texts = a;
        this._retCode = 2;
        return this;
    }

    /** Call this at the end of the procedure if you need the last result returned after filtering. */
    public function z():Dynamic {
        var u:Dynamic = null;
        switch (this._retCode){
            case 0: u = this._current;
            case 1: u = this._attributes;
            case 2: u = this._texts;
        }
        return u;
    }

    private function rec(node:Xml):Array<Xml> {
        var ret:Array<Xml> = null;
        if (node.nodeType != Xml.Element) {
            ret = new Array<Xml>();
            ret.push(node);
            return ret;
        }
        var tmp:Array<Xml>;
        var it:Iterator<Xml> = node.iterator();
        var n:Xml;
        while (it.hasNext()) {
            if (ret == null) ret = new Array<Xml>();
            n = cast it.next();
            tmp = this.rec(n);
            ret.push(n);
            if (tmp != null) ret = ret.concat(this.rec(n));
        }
        return ret;
    }
}