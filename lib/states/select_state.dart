import '../custom_grid_tile.dart';

enum SelectStates { select }

int state_(SelectStates state) {
  return state.index;
}

class SelectState {
  final SelectStates _state;
  String? _data;

  SelectState(this._state) {
    _data = 'login';
  }

  SelectStates state() {
    return _state;
  }
  
  void setData(String? data) {
    _data = data;
  }

  String? data() {
    return _data;
  }
}
