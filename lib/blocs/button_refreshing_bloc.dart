import 'package:flutter_bloc/flutter_bloc.dart';
import '../events/refresh_events.dart';
import '../events/event.dart';
import '../state_machines/basic_state_machine.dart';
import '../state_machines/refreshing_state_machine.dart';
import '../states/button_refreshing_state.dart';

class ButtonRefreshingBloc extends Bloc<Event, ButtonRefreshingState> {
  BasicStateMachine? _stateMachine;

  ButtonRefreshingBloc(ButtonRefreshingState state) : super(state) {
    _stateMachine = RefreshingStateMachine(state_(ButtonRefreshingStates.refreshing));

    on<Refresh>((event, emit) {
      done(event, emit);
    });
  }

  void done(Event event, Emitter<ButtonRefreshingState> emit) {
    int newState = _stateMachine!.dispatch(event);
    if (newState >= 0) {
      ButtonRefreshingState nextState = ButtonRefreshingState(ButtonRefreshingStates.values[newState]);
      nextState.setData(event.getData());
      emit(nextState);
    }
  }
}
