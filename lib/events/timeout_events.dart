import '../events/event.dart';

class Timeout<T> extends Event<T> {
  T? _data;
  Timeout();
  @override
  T? getData() {
    return _data;
  }

  @override
  Timeout<T> setData([T? data]) {
    _data = data;
    return this;
  }


}
