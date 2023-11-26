enum CloudMeasurementStates { idle, measurement }

int state_(CloudMeasurementStates state) {
  return state.index;
}

class CloudMeasurementState {
  final CloudMeasurementStates _state;
  String? _data;

  CloudMeasurementState(this._state) {
    _data = null;
  }

  CloudMeasurementStates state() {
    return _state;
  }
  
  void setData(String? data) {
    _data = data;
  }

  String? data() {
    return _data;
  }
}
