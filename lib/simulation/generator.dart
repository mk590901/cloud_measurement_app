import '../interfaces/i_thresholds.dart';
import 'generator_bundle.dart';
import 'simulator_utils.dart';

class Generator {
  final Mode _mode;
  final IThresholds _thresholds;
  late double _min;
  late double _max;
  Generator(this._mode, this._thresholds) {
    _min = getMin(_mode, _thresholds);
    _max = getMax(_mode, _thresholds);
  }

  double min () {
    return _min;
  }

  double max () {
    return _max;
  }
}
