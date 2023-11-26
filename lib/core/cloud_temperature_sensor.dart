import 'dart:async';
import 'dart:math';
import '../events/failed_events.dart';
import '../events/success_events.dart';
import '../events/timeout_events.dart';
import '../toit.io/igui_adapter.dart';
import '../toit.io/toit_api_bridge.dart';
import '../errors/errors.dart';
import '../events/break_events.dart';
import '../events/start_events.dart';
import '../states/cloud_measurement_state.dart';
import '../state_machines/cloud_measurement_state_machine.dart';
import '../interfaces/i_controller.dart';
import '../interfaces/i_sensor.dart';
import 'controller.dart';

class CloudTemperatureSensor implements ISensor, IGUIAdapter {

  static CloudTemperatureSensor? _instance;

  final CloudMeasurementStateMachine _task =
      CloudMeasurementStateMachine(state_(CloudMeasurementStates.idle)).setDelay(10);  //  5
  final random = Random();
  late IController? _controller;
  late ToitBridge _cloudBridge;

  void setCloudBridge(ToitBridge cloudBridge) {
    _cloudBridge = cloudBridge;
  }

  void register() {
    if (_cloudBridge == null) {
      return;
    }
    _cloudBridge.register(99, this);
  }

  void unregister() {
    if (_cloudBridge == null) {
      return;
    }
    _cloudBridge.unregister(99);
  }

  void send(String command) {
    _cloudBridge.send(command);
  }

  static void initInstance() {
    _instance ??= CloudTemperatureSensor();
  }

  static CloudTemperatureSensor? sensor() {
    if (_instance == null) {
      throw Exception("--- TemperatureSensor wasn't initialized ---");
    }
    return _instance;
  }

  @override
  void start() {
    print ('CloudTemperatureSensor.start()->Start()');
    _task.dispatch(Start());
  }

  @override
  void stop() {
    print ('CloudTemperatureSensor.stop()->Break()');
    _task.dispatch(Break());
  }

  @override
  void setController(IController? controller) {
    _task.setController(controller);
    _controller = controller;
    _controller?.setSensor(this);

    print ('CloudTemperatureSensor.setController()');
  }

  @override
  void success() {
    _task.dispatch(Success());
  }

  @override
  void failed() {
    _task.dispatch(Failed());
  }

  @override
  void timeout() {
    //sensor()?.stop();  // ??
    _task.dispatch(Timeout());
  }

/*
  @override
  void measure() {
    print ("!!!!!!! MEASURE !!!!!!!");
    int min = 0;
    int max = 100;
    int randomNumber = min + random.nextInt(max - min + 1);
    if (randomNumber < 10) {
      _task.cancelTimer();
      _controller?.onFailed(ErrorType.failed);
    } else {
      _task.cancelTimer();
      _controller?.onSucceed(
          //_controller!.isContinuosMeasurement() ? _controller!.getValue() : getTemperature());
          _controller!.getValue());
    }
  }
*/

//  Timer? timer_;

  @override
  void measure() {
    print ("!!!!!!! CloudTemperatureSensor.MEASURE !!!!!!!");

    register();

    print("CloudTemperatureSensor.measure: timer created");
    // timer_ = Timer(Duration(seconds: 20), () {
    //   print("Measurement delay");
    //   timer_?.cancel();
    //   send('start');
    // });

    send('start');


/*
    int min = 0;
    int max = 100;
    int randomNumber = min + random.nextInt(max - min + 1);
    if (randomNumber < 10) {
      _task.cancelTimer();
      unregister();
      _controller?.onFailed(ErrorType.failed);
    } else {
      _task.cancelTimer();
      unregister();
      _controller?.onSucceed(
        //_controller!.isContinuosMeasurement() ? _controller!.getValue() : getTemperature());
          _controller!.getValue());
    }
 */
  }

  // String getTemperature() {
  //   String result ='';
  //   int min = 320;
  //   int max = 480;
  //   int randomNumber = min + random.nextInt(max - min + 1);
  //   result = (randomNumber/10).toString();
  //   return result;
  // }

  @override
  void cancel() {
    send('cancel');
  }

  @override
  bool busy() {
    String? stateName = _task.getStateName(_task.state());

    print("CloudTemperatureSensor.busy stateName->[$stateName]");

    if (stateName == null) {
      return false;
    }
    return (stateName == "idle") ? false : true;
  }

  @override
  String ident() {
    return 'CloudTemperatureSensor.CloudTemperature sensor';
  }

//  IGUIAdapter
  @override
  void onError(message) {
    // TODO: implement onError
  }

  @override
  void onLogged() {
    // TODO: implement onLogged
  }

  @override
  void onLogin() {
    // TODO: implement onLogin
  }

  @override
  void onLogoff() {
    // TODO: implement onLogoff
  }

  @override
  void onLogout() {
    // TODO: implement onLogout
  }

  @override
  void onReceive(message) {
    print ("CloudTemperature.onReceive: $message");
    _task.cancelTimer();
  // parsing answer
    if (message == 'cancel') {
      _controller?.onFailed(ErrorType.cancel);
    }
    else
    if (message == 'failed') {
      _controller?.onFailed(ErrorType.failed);
    }
    else {
      _controller?.onSucceed(message);
    }
    unregister();
  }

  @override
  void onStop() {
    // TODO: implement onStop
  }

}
