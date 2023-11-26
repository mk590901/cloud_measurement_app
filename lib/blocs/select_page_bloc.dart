import "../events/select_page_events.dart";
import "../events/event.dart";
import "../state_machines/basic_state_machine.dart";
import "../state_machines/select_state_machine.dart";
import "../states/select_state.dart";
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectPageBloc extends Bloc<Event, SelectState> {
  BasicStateMachine? _stateMachine;

  SelectPageBloc(SelectState state) : super(state) {
    _stateMachine = SelectPageStateMachine(state_(SelectStates.select));

    on<SelectPage>((event, emit) {
      done(event, emit);
    });
  }

  void done(Event event, Emitter<SelectState> emit) {
    int newState = _stateMachine!.dispatch(event);
    if (newState >= 0) {
      SelectState nextState = SelectState(SelectStates.values[newState]);
      nextState.setData(event.getData());
      emit(nextState);
    }
  }
}
