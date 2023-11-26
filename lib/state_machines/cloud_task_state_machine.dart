import 'dart:async';
import '../simulation/simulator.dart';
import 'basic_state_machine.dart';
import 'state.dart';
import 'trans.dart';
import '../interfaces/trans_methods.dart';
import '../states/task_state.dart';
import '../events/event.dart';
import '../events/start_events.dart';
import '../events/delay_events.dart';
import '../events/break_events.dart';
import '../interfaces/i_controller.dart';
import '../toit.io/toit_api_bridge.dart';

class CloudTaskStateMachine extends BasicStateMachine {

  Timer? timer;
  late int delay = 1; // 5?
  late IController? controller = null;
  late ToitBridge toitBridge_;
  final Simulator _simulator =  Simulator();

  CloudTaskStateMachine(super.currentState);

  CloudTaskStateMachine setDelay(final int delay) {
    this.delay = delay;
    print ('CloudTaskStateMachine.setDelay -> [$delay]');
    return this;
  }

  CloudTaskStateMachine setController(final IController? controller) {
    this.controller = controller;
    return this;
  }

  CloudTaskStateMachine setBridge(final ToitBridge bridge) {
    toitBridge_ = bridge;
    return this;
  }

  ToitBridge getBridge() {
    return toitBridge_;
  }

  Simulator getSimulator() {
    return _simulator;
  }

  @override
  void create() {
    states_ [state_(TaskStates.idle)]         = State([ Trans(Start(),  state_(TaskStates.measurement),  OnCloudStart(this))]);
    states_ [state_(TaskStates.measurement)]  = State([ Trans(Delay(),  state_(TaskStates.idle),  OnCloudDelay(this)),
                                                        Trans(Break(),  state_(TaskStates.idle),  OnCloudBreak(this)),
                                              ]);
  }

  @override
  String? getEventName(int event) {
    // TODO: implement getEventName
    throw UnimplementedError();
  }

  @override
  String? getStateName(int state) {
    return "${TaskStates.values[state].name}";
  }

  @override
  void publishEvent(Event event) {
    print ("publishEvent->${event}");
  }

  @override
  void publishState(int state) {
    // TODO: implement publishState
  }



}
