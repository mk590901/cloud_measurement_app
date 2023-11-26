import '../interfaces/i_thresholds.dart';
import 'generator_bundle.dart';

double getMax(Mode mode, IThresholds thresholds) {
  final double DELTA = 2.0;
  double result = 0;
  switch (mode) {
    case Mode.NORMAL:
      result = thresholds.highWarning();
      break;
    case Mode.WARNING_LOW:
      result = thresholds.lowWarning();
      break;
    case Mode.WARNING_HIGH:
      result = thresholds.highCritical();
      break;
    case Mode.CRITICAL_LOW:
      result = thresholds.lowCritical();
      break;
    case Mode.CRITICAL_HIGH:
      result = thresholds.outOfRangeHigh();
      break;
    case Mode.OUT_RANGE_LOW:
      result = thresholds.outOfRangeLow();
      break;
    case Mode.OUT_RANGE_HIGH:
      result = thresholds.outOfRangeHigh() + DELTA;
      break;
    default:
  }
  return result;
}

double getMin(Mode mode, IThresholds thresholds) {
  final double DELTA = 2.0;
  double result = 0;
  switch (mode) {
    case Mode.NORMAL:
      result = thresholds.lowWarning();
      break;
    case Mode.WARNING_LOW:
      result = thresholds.lowCritical();
      break;
    case Mode.WARNING_HIGH:
      result = thresholds.highWarning();
      break;
    case Mode.CRITICAL_LOW:
      result = thresholds.outOfRangeLow();
      break;
    case Mode.CRITICAL_HIGH:
      result = thresholds.highCritical();
      break;
    case Mode.OUT_RANGE_LOW:
      result = thresholds.outOfRangeLow() - DELTA;
      break;
    case Mode.OUT_RANGE_HIGH:
      result = thresholds.outOfRangeHigh();
      break;
    default:
  }
  return result;
}