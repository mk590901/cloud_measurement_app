import 'dart:math';
import '../body_temperature_thresholdss.dart';
import 'generator.dart';

enum Mode {
  NORMAL,
  WARNING_LOW,
  WARNING_HIGH,
  CRITICAL_LOW,
  CRITICAL_HIGH,
  OUT_RANGE_LOW,
  OUT_RANGE_HIGH
}

class GeneratorBundle {
  final Mode _mode;
  final Generator _generator;
  final int _size;
  final random = Random();

  GeneratorBundle (this._mode, this._size, this._generator);

  Mode mode() {
    return _mode;
  }

  double randomValue() {
    double min = _generator.min();
    double max = _generator.max();
    int randomNumber = (min*10).toInt() + random.nextInt(((max - min)*10).toInt());
    return randomNumber.toDouble()/10;
  }

  String strValue() {
    double min = _generator.min();
    double max = _generator.max();
    int randomNumber = (min*10).toInt() + random.nextInt(((max - min)*10).toInt());
    double value = randomNumber.toDouble()/10;
    return "$_mode: [$min,$max] $value";
  }

  double value() {
    return randomValue();
  }

  int size() {
    return _size;
  }
}

class Scheduler {
  final List<GeneratorBundle> _list = [
    GeneratorBundle(Mode.OUT_RANGE_LOW, 4, Generator(Mode.OUT_RANGE_LOW, BodyTemperatureThresholds())),
    GeneratorBundle(Mode.CRITICAL_LOW, 4, Generator(Mode.CRITICAL_LOW, BodyTemperatureThresholds())),
    GeneratorBundle(Mode.WARNING_LOW, 5, Generator(Mode.WARNING_LOW, BodyTemperatureThresholds())),
    GeneratorBundle(Mode.NORMAL, 12, Generator(Mode.NORMAL, BodyTemperatureThresholds())),
    GeneratorBundle(Mode.WARNING_HIGH, 4, Generator(Mode.WARNING_HIGH, BodyTemperatureThresholds())),
    GeneratorBundle(Mode.CRITICAL_HIGH, 5, Generator(Mode.CRITICAL_HIGH, BodyTemperatureThresholds())),
  ];

  int _current = 0;
  int _index = -1;

  void start(int idx) {
    _current = idx;
    _index = -1;
    //print("******* start  $_ms *******");
  }

  void startNext(int idx) {
    _current = idx;
    _index = 0;
    //print("******* start  $_ms *******");
  }

  double next() {
    GeneratorBundle pair = _list[_current];
    _index++;
    // print("******* $currentTimeMs : $_ms *******");
    // print("******* $delta ${pair.period()} *******");

    if (_index >= pair.size()) {
      print("******* JUMP $_index *******");
      _current++;
      if (_current == _list.length) {
        _current = 0;
      }
      startNext(_current);
    }
    return _list[_current].value();
  }


  String nextStr() {
    GeneratorBundle pair = _list[_current];
    _index++;
    // print("******* $currentTimeMs : $_ms *******");
    // print("******* $delta ${pair.period()} *******");

    if (_index >= pair.size()) {
      // print("******* JUMP *******");
      _current++;
      if (_current == _list.length) {
        _current = 0;
      }
      start(_current);
    }
    return _list[_current].strValue();
  }
}
