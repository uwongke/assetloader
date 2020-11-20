package org.assetloader.base;

import org.assetloader.core.ILoadStats;

class LoaderStats implements ILoadStats {
    public var latency(get, never) : Float;
    public var speed(get, never) : Float;
    public var averageSpeed(get, never) : Float;
    public var progress(get, never) : Float;
    public var totalTime(get, never) : Float;
    public var bytesLoaded(get, never) : Int;
    public var bytesTotal(get, set) : Int;
    
    private var _latency : Float = 0;
    private var _speed : Float = 0;
    private var _averageSpeed : Float = 0;
    private var _progress : Float = 0;
    private var _totalTime : Float = 0;
    private var _numOpened : Int = 0;
    private var _totalLatency : Float = 0;
    private var _bytesLoaded : Int = 0;
    private var _bytesTotal : Int = 0;
    private var _startTime : Int;
    private var _openTime : Int;
    private var _updateTime : Int;

    public function new() {
    }

    public function start() : Void {
        _startTime = Math.round(haxe.Timer.stamp() * 1000);

        _latency = 0;
        _speed = 0;
        _averageSpeed = 0;
        _progress = 0;
        _totalTime = 0;
    }

    public function open() : Void {
        _numOpened++;
        _openTime = Math.round(haxe.Timer.stamp() * 1000);

        _totalLatency += _openTime - _startTime;
        _latency = _totalLatency / _numOpened;

        update(0, 0);
    }

    public function done() : Void {
        update(_bytesTotal, _bytesTotal);

        _totalTime = Math.round(haxe.Timer.stamp() * 1000) - _startTime;
    }

    public function update(bytesLoaded : Int, bytesTotal : Int) : Void {
        _bytesTotal = bytesTotal;

        if (bytesLoaded > 0) {
            var bytesDif : Int = bytesLoaded - _bytesLoaded;
            _bytesLoaded = bytesLoaded;

            _progress = (_bytesLoaded / _bytesTotal) * 100;

            var currentTime : Int = Math.round(haxe.Timer.stamp() * 1000);
            var updateTimeDif : Int = (currentTime - _updateTime);

            if (updateTimeDif > 0) {
                _updateTime = currentTime;
                _speed = (bytesDif / 1024) / (updateTimeDif / 1000);

                var totalTimeDif : Float = (_updateTime - _openTime) / 1000;
                _averageSpeed = (_bytesLoaded / 1024) / totalTimeDif;
            }
        }
    }

    public function reset() : Void {
        _startTime = 0;
        _openTime = 0;
        _updateTime = 0;

        _latency = 0;
        _speed = 0;
        _averageSpeed = 0;
        _progress = 0;
        _totalTime = 0;

        _bytesLoaded = 0;
        _bytesTotal = 0;

        _numOpened = 0;
        _totalLatency = 0;
    }

    private function get_latency() : Float {
        return _latency;
    }

    private function get_speed() : Float {
        return _speed;
    }

    private function get_averageSpeed() : Float {
        return _averageSpeed;
    }

    private function get_progress() : Float {
        return _progress;
    }

    private function get_totalTime() : Float {
        return _totalTime;
    }

    private function get_bytesLoaded() : Int {
        return _bytesLoaded;
    }

    private function get_bytesTotal() : Int {
        return _bytesTotal;
    }

    private function set_bytesTotal(bytesTotal : Int) : Int {
        _bytesTotal = bytesTotal;
        return bytesTotal;
    }
}
