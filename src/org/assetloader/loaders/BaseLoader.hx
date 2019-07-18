package org.assetloader.loaders;

import openfl.net.URLVariables;
import org.assetloader.parsers.URLParser;
import openfl.events.SecurityErrorEvent;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.events.Event;
import openfl.events.HTTPStatusEvent;
import org.assetloader.base.Param;
import openfl.events.ErrorEvent;
import openfl.net.URLRequest;
import openfl.events.IEventDispatcher;
import org.assetloader.core.ILoader;
import org.assetloader.base.AbstractLoader;

class BaseLoader extends AbstractLoader implements ILoader {
    private var _eventDispatcher : IEventDispatcher;

    public function new(request : URLRequest, type : String, id : String = null) {
        var param = id != null ? id : request.url;
        super(param, type, request);
    }

    override public function start() : Void {
        if (!_invoked) {
            _invoked = true;
            _stopped = false;
            _eventDispatcher = constructLoader(); /** TODO@Wolfie -> How can this be desireable? */

            addListeners(_eventDispatcher);

            super.start();

            invokeLoading();
        }
        else {
            _invoked = false;
            stop();
            start();
        }
    }

    private function constructLoader():IEventDispatcher {
        return null;
    }

    private function invokeLoading() : Void {
    }

    override public function stop() : Void {
        removeListeners(_eventDispatcher);
        _eventDispatcher = null;

        super.stop();
    }

    override public function destroy() : Void {
        removeListeners(_eventDispatcher);
        _eventDispatcher = null;

        super.destroy();
    }

    private function error_handler(event : ErrorEvent) : Void {
        if (_retryTally < getParam(Param.RETRIES) - 1) {
            _retryTally++;
            start();
        }
        else {
            _inProgress = false;
            _failed = true;
            removeListeners(_eventDispatcher);
            _onError.dispatch([this, event.type, event.text]);
        }
    }

    private function httpStatus_handler(event : HTTPStatusEvent) : Void {
        _onHttpStatus.dispatch([this, event.status]);
    }

    private function open_handler(event : Event) : Void {
        _stats.open();
        _inProgress = true;
        _onOpen.dispatch([this]);
    }

    private function progress_handler(event : ProgressEvent) : Void {
        _stats.update(Std.int(event.bytesLoaded), Std.int(event.bytesTotal));
        _onProgress.dispatch(
            [this, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress,
        _stats.bytesLoaded, _stats.bytesTotal]);
    }

    private function complete_handler(event : Event) : Void {
        _stats.done();
        _onProgress.dispatch([this, _stats.latency, _stats.speed, _stats.averageSpeed, _stats.progress,
        _stats.bytesLoaded, _stats.bytesTotal]);

        _inProgress = false;
        _failed = false;
        _loaded = true;
        _onComplete.dispatch([this, _data]);
    }

    private function addListeners(dispatcher : IEventDispatcher): Void {
        if (dispatcher != null) {
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, error_handler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);

            dispatcher.addEventListener(Event.OPEN, open_handler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progress_handler);
            dispatcher.addEventListener(Event.COMPLETE, complete_handler);

            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
        }
    }

    private function removeListeners(dispatcher : IEventDispatcher) : Void {
        if (dispatcher != null) {
            dispatcher.removeEventListener(IOErrorEvent.IO_ERROR, error_handler);
            dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, error_handler);

            dispatcher.removeEventListener(Event.OPEN, open_handler);
            dispatcher.removeEventListener(ProgressEvent.PROGRESS, progress_handler);
            dispatcher.removeEventListener(Event.COMPLETE, complete_handler);

            dispatcher.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
        }
    }

    override public function setParam(id : String, value : Dynamic) : Void {
        var success : Bool = true;

        switch (id) {
            case Param.BASE:
                success = setBase(value);
            case Param.PREVENT_CACHE:
                setPreventCache(value);
            case Param.HEADERS:
                _request.requestHeaders = value;
        }

        if (success) {
            super.setParam(id, value);
        }
    }

    private function setBase(value : String) : Bool {
        if (value == null) {
            return false;
        }

        var urlParser : URLParser = new URLParser(_request.url);

        if (urlParser.host == null || urlParser.host == "") {
            _request.url = value + urlParser.url;
            return true;
        }

        return false;
    }

    private function setPreventCache(value : Bool) : Void {
        var url : String = _request.url;
        if (value) {
            if (url.indexOf("ck=") == -1) {
                url += (((url.indexOf("?") == -1)) ? "?" : "&") + "ck=" + Date.now().getTime();
            }
        }
        else if (url.indexOf("ck=") != -1) {
            var vrs : URLVariables = new URLVariables(url.substring(url.indexOf("?") + 1));
            var cleanUrl : String = url.substring(0, url.indexOf("?"));
            var cleanVrs : URLVariables = new URLVariables();

            for (queryKey in Reflect.fields(vrs)) {
                if (queryKey != "ck") {
                    Reflect.setField(cleanVrs, queryKey, Reflect.field(vrs, queryKey));
                }
            }

            var queryString : String = Std.string(cleanVrs);

            url = cleanUrl + (((queryString != "")) ? "?" + queryString : "");
        }
        _request.url = url;
    }
}