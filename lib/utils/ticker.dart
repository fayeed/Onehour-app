import 'dart:async';

class Ticker {
  Stopwatch _watch;
  Timer _timer;

  StreamController<Duration> currentDuration = StreamController<Duration>();
  Duration startTime;

  Ticker({this.startTime = Duration.zero}) {
    _watch = Stopwatch();
  }

  void _onTick(Timer timer) {
    final tempHour = startTime.inHours + _watch.elapsed.inHours;
    final tempMinutes = startTime.inMinutes.remainder(60) +
        _watch.elapsed.inMinutes.remainder(60);
    final tempSeconds = startTime.inSeconds.remainder(60) +
        _watch.elapsed.inSeconds.remainder(60);

    final duration = Duration(
      hours: tempHour,
      minutes: tempMinutes,
      seconds: tempSeconds,
    );

    currentDuration.add(duration);
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), _onTick);
    _watch.start();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    _watch.stop();
    currentDuration.add(_watch.elapsed);
  }

  void reset() {
    stop();
    _watch.reset();
    currentDuration.add(Duration.zero);
  }
}
