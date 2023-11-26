import '../interfaces/i_sink.dart';

enum ButtonRefreshingStates { refreshing }

int state_(ButtonRefreshingStates state) {
  return state.index;
}

class ButtonRefreshingState {
  final ButtonRefreshingStates _state;
  ISink? _data;

  ButtonRefreshingState(this._state) {
    _data = null;
  }

  ButtonRefreshingStates state() {
    return _state;
  }

  void setData(ISink? data) {
    _data = data;
  }

  ISink? data() {
    return _data;
  }
}
