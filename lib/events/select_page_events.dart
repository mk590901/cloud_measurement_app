import '../events/event.dart';

class SelectPage<T> extends Event<T> {
  T? _data;
  SelectPage();
  @override
  T? getData() {
    return _data;
  }

  @override
  SelectPage<T> setData([T? data]) {
    _data = data;
    return this;
  }


}
