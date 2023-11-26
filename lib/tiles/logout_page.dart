import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/select_page_bloc.dart';
import '../core/application_holder.dart';
import '../events/select_page_events.dart';
import '../toit.io/igui_adapter.dart';
import '../utils/utils.dart';

class LogoutPage extends StatefulWidget {
  final String _name;
  //final Color _color;

  const LogoutPage(this._name, //this._color,
      {Key? key})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _LogoutPageState createState() {
    print('------- _AccountManagementPageState -------');
    return _LogoutPageState();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _LogoutPageState extends State<LogoutPage> implements IGUIAdapter {
  bool _visibility = false; //  for circular progress bar

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, color: Colors.blue.shade900);

  TextEditingController? emailTextController;

  @override
  void initState() {
    print('_ModePageState.init [${widget._name}]');
    super.initState();
    prepareTextControllers();
    ApplicationHolder.holder()?.register(2, this);

  }

  void prepareTextControllers() {
    emailTextController = TextEditingController();
    emailTextController?.text = ApplicationHolder.holder()!.getAccount(); //'Michael.Kanzieper@gmail.com';
  }
  
  @override
  void dispose() {
    print("------- AccountManagement.dispose -------");

    if (emailTextController != null) {
      emailTextController!.dispose();
    }

    ApplicationHolder.holder()?.unregister(2);

    super.dispose();

    print("+++++++ AccountManagement.dispose +++++++");
  }

  @override
  void onLogin() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard.
      _visibility = true;
      //ApplicationHolder.holder()!.bridge()!.login(_email, _password, context);
    });
  }

  @override
  void onLogout() {
    setState(() {
      ApplicationHolder.holder()?.setLogin(false);
      ApplicationHolder.holder()?.setAccount("");
      ApplicationHolder.holder()?.setPassword("");
      _visibility = true;
      ApplicationHolder.holder()?.bridge()?.logout();
    });
  }

  @override
  void onError(message) {
    print("_AccountManagementPageState -- on Error");
    if (mounted) {
      setState(() {
        _visibility = false;
      });
    }
    showToast(context, message);
  }

  @override
  void onLogged() {
    print("_AccountManagementPageState -- on Logged");
  }

  @override
  void onLogoff() {
    print("_AccountManagementPageState -- on onLogoff");
    setState(() {
      _visibility = false;
    });
    showToast(context, "LOGOUT WAS DONE");
    context.read<SelectPageBloc>().add(SelectPage().setData('login'));
  }

  @override
  void onReceive(message) {
    print("_AccountManagementPageState -- on Receive");
  }

  @override
  void onStop() {
    print("_AccountManagementPageState -- on Stop");
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      obscureText: false, // true
      enabled: false,
      style: style,
      controller: emailTextController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(32.0), )),
    );

    final logoutButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        onPressed: () {
          if (ApplicationHolder.holder()!.isLogged()) {
            onLogout();
          }
          else {
            showToast(context, 'You are log off. First execute login');
          }
        },
        child: Text("Logout",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    Container logoutPage = Container(
        color: Colors.grey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 24.0),
                SizedBox(
                  height: 128.0,
                  child: Image.asset(
                    "assets/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32.0),
                emailField,
                //emailText,
                const SizedBox(height: 96.0),
                logoutButton,
                const SizedBox(
                  height: 16.0,
                ),
                CircularProgressIndicator(
                  backgroundColor:
                      _visibility ? Colors.blueAccent : Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(
                      _visibility ? Colors.blueGrey : Colors.transparent),
                  strokeWidth: 10,
                ),
              ],
            ),
          ),
        ));

    return Scaffold(
      // key: _scaffoldKey,
      // appBar: _appBar,
      // drawer: buildDrawer(context),
      body: /*ApplicationHolder.holder()!.isLogged() ?*/ logoutPage /*: loginPage*/,
    );
  }

}
