package org.assetloader.loaders;

import openfl.events.Event;
import openfl.errors.Error;
import openfl.errors.SecurityError;
import org.assetloader.base.Param;
import openfl.events.TimerEvent;
import openfl.events.IEventDispatcher;
import org.assetloader.base.AssetType;
import openfl.net.URLRequest;
import openfl.utils.Timer;
import openfl.media.Sound;
import org.assetloader.signals.LoaderSignal;

class SoundLoader extends BaseLoader {
    public var onReady(get, never): LoaderSignal;
    public var onId3(get, never): LoaderSignal;
    public var sound(get, never): Sound;
    public var isReady(get, never): Bool;

    private var _onId3 : LoaderSignal;
    private var _onReady : LoaderSignal;
    private var _sound : Sound;

    private var _readyTimer : Timer;

    private var _isReady : Bool;

    public function new(request : URLRequest, id : String = null) {
        super(request, AssetType.SOUND, id);
    }

    override private function initSignals() : Void {
        super.initSignals();
        _onComplete = new LoaderSignal([Sound]);
        _onReady = new LoaderSignal([Sound]);
        _onId3 = new LoaderSignal();
    }

    override private function constructLoader() : IEventDispatcher {
        _data = _sound = new Sound();

        if (_readyTimer == null) {
            _readyTimer = new Timer(50);
            _readyTimer.addEventListener(TimerEvent.TIMER, readyTimer_handler);
        }
        else {
            _readyTimer.reset();
        }

        return _sound;
    }

    override private function invokeLoading() : Void {
        try {
            _sound.load(request, getParam(Param.SOUND_LOADER_CONTEXT));
        } catch (error : SecurityError) {
            _onError.dispatch([this, error.name, error.message]);
        }
        _readyTimer.start();
    }

    override public function stop() : Void {
        if (_invoked) {
            try {
                _sound.close();
            } catch (error : Error) {
            }
            _readyTimer.stop();
        }
        super.stop();
    }

    override public function destroy() : Void {
        super.destroy();

        if (_readyTimer != null) {
            _readyTimer.removeEventListener(TimerEvent.TIMER, readyTimer_handler);
        }

        _sound = null;
        _readyTimer = null;
        _isReady = false;
    }

    override private function addListeners(dispatcher : IEventDispatcher) : Void {
        super.addListeners(dispatcher);
        if (dispatcher != null) {
            dispatcher.addEventListener(Event.ID3, id3_handler);
        }
    }

    override private function removeListeners(dispatcher : IEventDispatcher) : Void {
        super.removeListeners(dispatcher);
        if (dispatcher != null) {
            dispatcher.removeEventListener(Event.ID3, id3_handler);
        }
    }

    override private function complete_handler(event : Event) : Void {
        if (!_isReady) {
            _isReady = true;
            _onReady.dispatch([this, _sound]);
            _readyTimer.stop();
        }
        super.complete_handler(event);
    }

    private function readyTimer_handler(event : TimerEvent) : Void {
        if (!_isReady && !_sound.isBuffering) {
            _onReady.dispatch([this, _sound]);
            _isReady = true;
            _readyTimer.stop();
        }
    }

    private function id3_handler(event : Event) : Void {
        _onId3.dispatch([this]);
    }

    /** Dispatches when the Sound instance is ready to be played e.g. streamed while still loading.
		The SoundLoader closely monitors the isBuffering property of the Sound instance, the first
		time isBuffering is false, onReady will dispatch. It could happen that the sound file is finished
		loading loading before the isBuffering monitor detected it, so another check occurs onComplete.
		Thus onReady will always fire before onComplete, but only once. */
    private function get_onReady() : LoaderSignal {
        return _onReady;
    }

    /** Dispatches when the SoundLoader has loaded the ID3 information of
		the sound clip. */
    private function get_onId3() : LoaderSignal {
        return _onId3;
    }

    /** Gets the Sound instance. */
    private function get_sound() : Sound {
        return _sound;
    }

    /** Gets whether the Sound instance is ready to be streamed or not. */
    private function get_isReady() : Bool {
        return _isReady;
    }
}