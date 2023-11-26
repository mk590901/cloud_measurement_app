import 'dart:async';
import 'basic_state_machine.dart';
import 'state.dart';
import 'trans.dart';
import '../interfaces/trans_methods.dart';
import '../states/cloud_measurement_state.dart';
import '../events/event.dart';
import '../events/start_events.dart';
import '../events/break_events.dart';
import '../events/success_events.dart';
import '../events/failed_events.dart';
import '../events/timeout_events.dart';
import '../interfaces/i_controller.dart';

class CloudMeasurementStateMachine extends BasicStateMachine {

  Timer? timer;
  late int defaultTimeout = 8;
  late IController? controller = null;

  CloudMeasurementStateMachine(super.currentState);

  CloudMeasurementStateMachine setDelay(final int delay) {
    this.defaultTimeout = delay;
    return this;
  }

  CloudMeasurementStateMachine setController(final IController? controller) {
    this.controller = controller;
    return this;
  }

  @override
  void create() {
    states_ [state_(CloudMeasurementStates.idle)]         = State([ Trans(Start(),    state_(CloudMeasurementStates.measurement), On_Start(this))]);
    states_ [state_(CloudMeasurementStates.measurement)]  = State([ Trans(Success(),  state_(CloudMeasurementStates.idle),        On_Success(this)),
                                                                    Trans(Failed(),   state_(CloudMeasurementStates.idle),        On_Failed(this)),
                                                                    Trans(Break(),    state_(CloudMeasurementStates.idle),        On_Break(this)),
                                                                    Trans(Timeout(),  state_(CloudMeasurementStates.idle),        On_Timeout(this)),
                                                                  ]);
  }

  @override
  String? getEventName(int event) {
    // TODO: implement getEventName
    throw UnimplementedError();
  }

  @override
  String? getStateName(int state) {
    return "${CloudMeasurementStates.values[state].name}";
  }

  @override
  void publishEvent(Event event) {
    print ("publishEvent->${event}");
  }

  @override
  void publishState(int state) {
    // TODO: implement publishState
  }

  void cancelTimer() {
    if (timer != null && timer!.isActive) {
      timer?.cancel();
      timer = null;
      print ("******* CANCEL TIMER *******");
    }
  }


}
