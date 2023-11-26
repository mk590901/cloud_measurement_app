import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:toit_api/toit/api/auth.pbgrpc.dart'
    show AuthClient, LoginRequest, LogoutRequest;
import 'package:toit_api/toit/api/pubsub/publish.pbgrpc.dart'
    show PublishClient, PublishRequest;
import 'package:toit_api/toit/api/pubsub/subscribe.pbgrpc.dart';
import '../core/cloud_temperature_sensor.dart';
import '../core/controller.dart';
import '../state_machines/cloud_task_state_machine.dart';
import 'igui_adapter.dart';
import 'gui_adapter.dart';
//import 'application_holder.dart';

import '../state_machines/cloud_task_state_machine.dart';
import '../events/start_events.dart';
import '../states/task_state.dart';
import '../events/delay_events.dart';
import '../events/break_events.dart';


class ToitBridge {
  var token_;
  var channel_;
  var subscribeStub_;
  var mainTopicInpName_;
  var options_;
  var mainTopicInp_;
  var mainTopicOutName_;
  var mainTopicOut_;
  var existingSubscriptions_;
  var inpSubscription_;
  var publishStub_;
  var fetchFuture_;
  var before;

  final bool _simulation = false; //true;

  bool        receiverIsActive_ = false;
  final GUIAdapter _adapter = GUIAdapter();
  final CloudTaskStateMachine _task =
    CloudTaskStateMachine(state_(TaskStates.idle)).setDelay(1);  //  5

  ToitBridge(this.mainTopicInpName_, this.mainTopicInp_, this.mainTopicOutName_, this.mainTopicOut_);

  void login(var username, var password, BuildContext context) async {
    channel_ = ClientChannel('api.toit.io');

    print ("ClientChannel $username : $password" );

    try {
      print('Login...');
      var authClient = AuthClient(channel_);
      var resp = await authClient
          .login(LoginRequest(username: username, password: password));

      var tokenBytes = resp.accessToken;
      token_ = utf8.decode(tokenBytes);
      print('Access token->[$token_]');

      CloudTemperatureSensor.sensor()?.setController(Controller.controller());
      CloudTemperatureSensor.sensor()?.setCloudBridge(this);

      _adapter.onLogged();  // Create ToitBridge
    }
    catch (exception) {
      print ("Login.Exception->${exception.toString()}");
      //guiAdapter_.onError(exception.toString());
      _adapter.onError(exception.toString());
    }
    finally {
      //guiAdapter_.onStop();
      _adapter.onStop();
    }
  }

//  https://github.com/toitware/api/blob/master/dart/example/auth/username_pw.dart

  void logout() async {
    bool error = false;
    try {
      print('Logout...');
      var options = CallOptions(
          metadata: {'Authorization': 'Bearer ${token_}'});
      print("bridge: - Logging out...");
      // For example, we use it in the log-out call here:
      var authorizedClientStub = AuthClient(channel_, options: options);
      await authorizedClientStub.logout(LogoutRequest());
      //_adapter.onLogouted();
      print("bridge: + Logging out...");

    }
    catch (exception) {
        print ("Logout.Exception->${exception.toString()}");
        _adapter.onError(exception.toString());
        error = true;
    } finally {
      _adapter.onStop();
      channel_.shutdown();
      if (!error) {
        _adapter.onLogoff();
      }
    }
    //unregisterAll();
    //ApplicationHolder.holder()!.unregister(1);
  }

  void create() async {
    try {
      options_ = CallOptions(metadata: {'Authorization': 'Bearer $token_'});
      print('PubSub...');
      print('Listing existing subscriptions...');
      subscribeStub_ = SubscribeClient(channel_, options: options_);
      existingSubscriptions_ = (await subscribeStub_.listSubscriptions(ListSubscriptionsRequest())).subscriptions;
      existingSubscriptions_.forEach((sub) {
        print('\t${sub.name}: ${sub.topic}');
      });
      runReceiver();
      prepareSend(mainTopicInpName_, options_);
    }
    catch(exception) {
      _adapter.onError(exception.toString());
    }
  }

  void runReceiver() async {
    if (!receiverIsActive_) {
      _runReceiver(mainTopicOutName_, mainTopicOut_, subscribeStub_, channel_);
    }
  }

  void _runReceiver(var topicName, var topic, SubscribeClient stub, ClientChannel channel) async {
    print('receiveMessages.streaming->[$topic]');
    try {
      var subscription = Subscription(name: topicName, topic: topic);
      var stream = stub.stream(StreamRequest(subscription: subscription));
      print('receiveMessages.streaming');
      await stream.forEach((response) {
        var envelopes = response.messages;
        for (var message in envelopes) {
          // We know the data is utf8. That doesn't need to be the case.
          // The data could be binary.
          var str = utf8.decode(message.message.data);
          print ("!!! str->[$str] !!!");
          // Acknowledge each message individually.
          // We could also just send one request to handle them all.
          stub.acknowledge(AcknowledgeRequest(
              subscription: subscription, envelopeIds: [message.id]));
          //guiAdapter_.onReceive(str);
          _adapter.onReceive(str);
        }
      });
      print('receiveMessages.done');
    }
    catch (exception) {
      print ('receiveMessages.exception->[${exception.toString()}]');
      // guiAdapter_.onStop();
      // guiAdapter_.onError(exception.toString());
      _adapter.onStop();
      _adapter.onError(exception.toString());
    } finally {
      print('receiveMessages.shutting down');
      print('receiveMessages.shutdown complete');
      receiverIsActive_ = false;
    }
  }

  void shutdown() {
    print('shutdown start');
    if (channel_ == null) {
      print('shutdown final (null)');
      return;
    }
    channel_.shutdown();
    print('shutdown final');
  }

  void prepareSend(var topicName, CallOptions options) {
    if (existingSubscriptions_.any((sub) => sub.name == topicName)) {
      // Selected subscription exists
      inpSubscription_ = getSubscription(existingSubscriptions_, topicName);
      print('InpSubscription>  ${inpSubscription_.name}');
      fetchFuture_ = subscribeStub_.fetch(
          FetchRequest(subscription: inpSubscription_));
      publishStub_ = PublishClient(channel_, options: options);
    }
  }

//  For simulation ...
  void receiveBack(String value) {
    _adapter.onReceive(value);
  }

  void send(String message) async {

    if (_simulation) {
//  For simulation ...
      print ("ToitBridge.simulation.send()->[$message]");

      if (message == 'start') {
        _task.setBridge(this);
        _task.dispatch(Start());
      }
      else
      if (message == 'cancel') {
        _task.dispatch(Break());
      }
      return;
    }

    runReceiver();
    before = DateTime.now();
    await sendMessages(message);

  }

  Future<void> sendMessages(var sendMessage) async {
      await publishStub_.publish(PublishRequest(
          topic: mainTopicInp_,
          publisherName: 'dart toit-api demo',
          data: [utf8.encode(sendMessage)]));
      print('Waiting for the published value to reach the subscription...');
      var fetch = await fetchFuture_;
      printFetch(fetch);
      print('Acknowledging...');
      if (fetch.messages != null && fetch.messages.length > 0) {
        await subscribeStub_.acknowledge(AcknowledgeRequest(
            subscription: inpSubscription_,
            envelopeIds: [fetch.messages.first.id]));
      }
      print('Quit...');
  }

  Subscription getSubscription(List<Subscription> list, String topicName) {
    var result = Subscription();
    if (list.isEmpty) {
      return result;
    }
    for (var i = 0; i < list.length; i++) {
      var sub = list[i];
      if (sub.name == topicName) {
        result = sub;
        break;
      }
    }
    return result;
  }

  void printFetch(FetchResponse fetchResponse) {
    print ('printFetch.start');
    var list = fetchResponse.messages;
    print ('printFetch.length-> ${list.length}');
    list.forEach((element) {
      print ('element.id.length->(${element.id.length})\n');
      var listData = element.id;
      var out = '';
      for (var i = 0; i < listData.length; i++) {
        out += String.fromCharCode(listData[i]);
      }
      print ('out->($out)');
    });
    print ('printFetch.final');
  }

  void register(int key, IGUIAdapter? adapter) {
    print ('toit.bridge.register->[$key]');
    _adapter.register(key, adapter);
  }

  void unregister(int key) {
    print ('toit.bridge.unregister->[$key]');
    _adapter.unregister(key);
  }

  void unregisterAll() {
    print ('toit.bridge.unregisterAll');
    _adapter.unregisterAll();
  }

}