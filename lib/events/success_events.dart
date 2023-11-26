import '../events/event.dart';

class Success<T> extends Event<T> {
  T? _data;
  Success();
  @override
  T? getData() {
    return _data;
  }

  @override
  Success<T> setData([T? data]) {
    _data = data;
    return this;
  }


}
