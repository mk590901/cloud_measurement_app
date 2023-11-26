abstract class IGUIAdapter {
  void onReceive(var message);
  void onLogin();
  void onLogged();
  void onLogout();
  void onLogoff();
  void onStop();
  void onError(var message);
}