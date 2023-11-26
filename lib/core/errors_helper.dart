import 'package:flutter/material.dart';
import './../errors/errors.dart';
import 'error_wrapper.dart';

class ErrorsHelper {

  static ErrorsHelper? _instance;

  final Map<ErrorType, ErrorWrapper>  _container = {};

  static void initInstance() {
    _instance ??= ErrorsHelper();
  }

  static ErrorsHelper? errorsHelper() {
    if (_instance == null) {
      throw Exception("--- ErrorsHelper wasn't initialized ---");
    }
    return _instance;
  }

  ErrorsHelper() {
    _container[ErrorType.ok]            = ErrorWrapper(Colors.lightBlue, Colors.lightBlue, "");
    _container[ErrorType.failed]        = ErrorWrapper(Colors.yellowAccent, Colors.yellowAccent, "Measurement is failed");
    _container[ErrorType.cancel]        = ErrorWrapper(Colors.amber, Colors.amber, "Measurement is canceled");
    _container[ErrorType.out_range]     = ErrorWrapper(Colors.blueGrey, Colors.blueGrey, "Out of range value");
    _container[ErrorType.critical_low]  = ErrorWrapper(Colors.deepPurple, Colors.deepPurple, "Below the minimum allowable value");
    _container[ErrorType.critical_high] = ErrorWrapper(Colors.deepOrange.shade400, Colors.deepOrange.shade400, "Above the maximum allowable value");
    _container[ErrorType.warning_low]   = ErrorWrapper(Colors.deepPurpleAccent, Colors.deepPurpleAccent, "Below normal value");
    _container[ErrorType.warning_high]  = ErrorWrapper(Colors.deepOrange.shade200, Colors.deepOrange.shade200, "Above normal value");
  }

  ErrorWrapper? wrapper (ErrorType type) {
    return  _container[type];
  }

}
