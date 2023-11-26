import 'basic_state_machine.dart';
import 'state.dart';
import 'trans.dart';
import '../states/select_state.dart';
import '../events/event.dart';
import '../events/select_page_events.dart';
import '../interfaces/trans_methods.dart';

class SelectPageStateMachine extends BasicStateMachine {

  SelectPageStateMachine(super.currentState);

  @override
  void create() {
    states_ [state_(SelectStates.select)]   = State([ Trans(SelectPage(),  state_(SelectStates.select),  OnNothing())]);
  }

  @override
  String? getEventName(int event) {
    // TODO: implement getEventName
    throw UnimplementedError();
  }

  @override
  String? getStateName(int state) {
    return "state [${SelectStates.values[state].name}]";
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
