import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/select_page_bloc.dart';
import '../core/application_holder.dart';
import '../events/select_page_events.dart';
import '../toit.io/igui_adapter.dart';
import '../utils/utils.dart';

class LoginPage extends StatefulWidget {
  final String _name;
  final Color _color;

  const LoginPage(this._name, this._color,
      {Key? key})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _LoginPageState createState() {
    print('------- _AccountManagementPageState -------');
    return _LoginPageState();
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class _LoginPageState extends State<LoginPage> implements IGUIAdapter {
  bool _visibility = false;

  var _email;
  var _password;

  TextStyle style = const TextStyle(fontFamily: 'Montserrat', fontSize: 18.0);

  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;

  @override
  void initState() {
    print('_ModePageState.init [${widget._name}]');
    super.initState();
    prepareTextControllers();
    ApplicationHolder.holder()?.register(1, this);
  }

  void prepareTextControllers() {
    emailTextController           = TextEditingController();
    passwordTextController        = TextEditingController();
    emailTextController?.text     = ApplicationHolder.holder()!.getAccount();
    passwordTextController?.text  = ApplicationHolder.holder()!.getPassword();
  }
  
  @override
  void dispose() {
    print("------- AccountManagement.dispose -------");

    if (passwordTextController != null) {
      passwordTextController!.dispose();
    }

    if (emailTextController != null) {
      emailTextController!.dispose();
    }

    ApplicationHolder.holder()?.unregister(1);

    super.dispose();

    print("+++++++ AccountManagement.dispose +++++++");
  }

  @override
  void onLogin() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard.
      _visibility = true;
      ApplicationHolder.holder()?.bridge()?.login(_email, _password, context);
    });
  }

  @override
  void onLogout() {
    setState(() {
      SystemChannels.textInput.invokeMethod('TextInput.hide'); // hide keyboard.
      // ApplicationHolder.holder()!.setLogin(false);
      // ApplicationHolder.holder()!.setAccount("");
      // ApplicationHolder.holder()!.setPassword("");
      // _visibility = true;
      // ApplicationHolder.holder()!.bridge()!.logout();
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
    setState(() {
      _visibility = false;
      ApplicationHolder.holder()!.setLogin(true);
      ApplicationHolder.holder()!.setAccount(_email);
      ApplicationHolder.holder()!.setPassword(_password);
    });
    showToast(context, "LOGIN WAS DONE");
    context.read<SelectPageBloc>().add(SelectPage().setData('logout'));
    ApplicationHolder.holder()?.bridge()?.create();  // ==> create bridge !
  }

  @override
  void onLogoff() {
    print("_AccountManagementPageState -- on onLogoff");
    setState(() {
      _visibility = false;
    });
    // showToast(context, "LOGOFF WAS DONE");
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
      style: style,
      controller: emailTextController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: passwordTextController,
      decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
          hintText: 'Password',
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        onPressed: () {
          _email = emailTextController?.text;
          _password = passwordTextController?.text;
          print ('$_email : $_password');
          if (!ApplicationHolder.holder()!.isLogged()) {
            if (_email.toString().isNotEmpty &&
                _password.toString().isNotEmpty) {
              onLogin();
            } else {
              showToast(context, 'Enter e-mail and password please');
            }
          }
          else {
            showToast(context, 'You already logged on. Please logout and try again');

          }
        },
        child: Text(/*!ApplicationHolder.holder()!.isLogged() ?*/ 'Login' /*: "Send"*/,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );

    Container loginPage = Container(
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
                const SizedBox(height: 24.0),
                passwordField,
                const SizedBox(
                  height: 24.0,
                ),
                loginButton,
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
      body: /*ApplicationHolder.holder()!.isLogged() ? logoutPage :*/ loginPage,
    );
  }
}
