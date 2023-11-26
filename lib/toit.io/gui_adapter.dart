import "../core/cloud_temperature_sensor.dart";
import "../core/controller.dart";
import "../core/temperature_sensor.dart";
import "igui_adapter.dart";

class GUIAdapter implements IGUIAdapter {
  final Map<int, IGUIAdapter?> _container = <int,IGUIAdapter?>{};
  
  void register(int key, IGUIAdapter? adapter) {
    _container[key] = adapter;
  }

  void unregister(int key) {
    _container.remove(key);
  }

  void unregisterAll() {
    clear();
  }

  void clear() {
    _container.clear();
  }

  int size() {
    return _container.length;
  }

  IGUIAdapter? get(int key) {
    IGUIAdapter? result;
    if (_container.containsKey(key)) {
      result = _container[key];
    }
    return  result;
  }

  @override
  void onError(message) {
    _container.forEach((k,v) {
      if (v != null) {
        v.onError(message);
      }
    });
  }

  @override
  void onLogged() {
    print ('onLogged->${_container.length}');

    // CloudTemperatureSensor.sensor()?.setController(Controller.controller());
    // CloudTemperatureSensor.sensor()?.setCloudBridge(toitBridge);

    _container.forEach((k,v) {
      if (v != null) {
        v.onLogged();
      }
    });
  }

  @override
  void onLogin() {
    print ('onLogin->${_container.length}');

    _container.forEach((k,v) {
      if (v != null) {
        v.onLogged();
      }
    });
  }

  @override
  void onReceive(message) {

    print ("GUI adapter.onReceive->[$message]");

    Map<int,IGUIAdapter?> clone = Map<int,IGUIAdapter?>.of(_container);
    clone.forEach((k,v) {
      if (v != null) {
        v.onReceive(message);
      }
    });

    // _container.forEach((k,v) {
    //   if (v != null) {
    //     v.onReceive(message);
    //   }
    // });
  }

  @override
  void onStop() {
    print ('onStop->${_container.length}');
    _container.forEach((k,v) {
      if (v != null) {
        v.onStop();
      }
    });
  }

  @override
  void onLogout() {
    print ('onLogout->${_container.length}');
    _container.forEach((k,v) {
      if (v != null) {
        v.onLogged();
      }
    });
  }

  @override
  void onLogoff() {
    print ('onLogoff->${_container.length}');

    TemperatureSensor.sensor()?.setController(Controller.controller());

    _container.forEach((k,v) {
      if (v != null) {
        v.onLogoff();
      }
    });
  }
}


