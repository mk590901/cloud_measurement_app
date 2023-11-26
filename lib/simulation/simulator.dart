import 'dart:async';
import 'generator_bundle.dart';

class Simulator {
  final Scheduler _scheduler = Scheduler();

  Simulator();

  String getValue() {
    String value = '${_scheduler.next()}';
    print ('getValue->$value');
    return value;
  }

}

