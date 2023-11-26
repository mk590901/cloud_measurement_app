// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import '../toit.io/igui_adapter.dart';
import "../toit.io/toit_api_bridge.dart";
//import '../velocityHelper/ShiftBuffer.dart';

enum ApplicationMode {
  Application,
  AccountManagement,
  About,
}

var mainTopicInp_ = 'cloud:demo/ping';
var mainTopicInpName_ = 'PING';
var mainTopicOut_ = 'cloud:demo/pong';
var mainTopicOutName_ = 'PONG';

class ApplicationHolder {
  static ApplicationHolder? _instance;

  ApplicationMode _mode = ApplicationMode.Application;
  bool _login = false;
  String _account = "";
  String _password = "";

  ToitBridge? bridge_;

  // Path?  _path;
  // late List<Offset> _points;
  // final ShiftBuffer<double> _shiftBuffer = ShiftBuffer<double>(256);

  static void initInstance() {
    _instance ??= ApplicationHolder();
  }

  ApplicationHolder() {
    bridge_ ??= ToitBridge(
        mainTopicInpName_, mainTopicInp_, mainTopicOutName_, mainTopicOut_);

  }

  void shutdown() {
    if (bridge_ != null) {
      bridge_!.shutdown();
    }
  }

  void register(int key, IGUIAdapter? adapter) {

    if (bridge_ != null) {
      bridge_!.register(key, adapter);
    }
  }

  void unregister(int key) {
    if (bridge_ != null) {
      bridge_!.unregister(key);
    }
  }

  ToitBridge? bridge() {
    return bridge_;
  }

  static ApplicationHolder? holder() {
    if (_instance == null) {
      throw Exception("--- ApplicationHolder was not initialized ---");
    }
    return _instance;
  }

  void log(String message) {
    //print ('${getColor(tag)}${message}$_reset');
    print('ApplicationHolder: $message');
  }

  void setMode(ApplicationMode mode) {
    _mode = mode;
  }

  ApplicationMode getMode() {
    return _mode;
  }

  void setLogin(bool login) {
    _login = login;
  }

  bool isLogged() {
    return _login;
  }

  void setAccount(String account) {
    _account = account;
  }

  String getAccount() {
    return _account;
  }

  void setPassword(String password) {
    _password = password;
  }

  String getPassword() {
    return _password;
  }

}
