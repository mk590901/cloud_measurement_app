import '../events/event.dart';

class Failed<T> extends Event<T> {
  T? _data;
  Failed();
  @override
  T? getData() {
    return _data;
  }

  @override
  Failed<T> setData([T? data]) {
    _data = data;
    return this;
  }


}
