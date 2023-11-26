import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/controller.dart';
import 'states/select_state.dart';
import 'blocs/select_page_bloc.dart';
import 'events/select_page_events.dart';
import 'utils/utils.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    Key? key,
    required this.title,
    this.topPadding = 0,
    required this.child,
    required this.floatingActionButton,
  }) : super(key: key);

  final String title;
  final Widget child;
  final Widget floatingActionButton;
  final double topPadding;

  Future<bool> leaveApp(BuildContext context) async {
    bool rc = onBack();
    if (!rc) {
      return rc;
    } else {
      return await tryExit(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {
          leaveApp(context);
        }),
        backgroundColor: Colors.blueGrey,
        title:
            BlocBuilder<SelectPageBloc, SelectState>(builder: (context, state) {
          return Text(buildTitle(state));
        }),
        actions: [
          actionButton(context, Icons.login_sharp, 'login'),
          actionButton(context, Icons.logout_sharp, 'logout'),
          actionButton(context, Icons.device_thermostat_sharp, 'device'),
          actionButton(context, Icons.help_outline_sharp, 'help'),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: child,
      ),
      floatingActionButton: floatingActionButton,
    );
  }

  String buildTitle(SelectState state) {
    String? statePage = state.data();
    String titleName = title;
    if (statePage == 'logout') {
      titleName = 'Logout';
    } else if (statePage == 'login') {
      titleName = 'Login';
    } else if (statePage == 'help') {
      titleName = 'About';
    } else if (statePage == 'device') {
      titleName = 'Sensor';
    }
    return titleName;
  }
}

Widget actionButton(BuildContext context, IconData? icon, String page) {
  return BlocBuilder<SelectPageBloc, SelectState>(builder: (context, state) {
    String? statePage = state.data();
    return IconButton(
        icon: Icon(icon),
        color: statePage == page ? Colors.white : Colors.white60,
        iconSize: 32,
        onPressed: () {

           if (!Controller.controller()!.isContinuosMeasurement()) {

           // /////////////////////////////////////////////////////////////
           //   String sensorName = Controller.controller()!.sensor()!.ident();
           //   print ('******* onPressed->sensor->[$sensorName] *******');
           // /////////////////////////////////////////////////////////////

             bool? busy = Controller.controller()!.busy();
             if (busy != null && !busy) {
               context.read<SelectPageBloc>().add(SelectPage().setData(page));
             }
             else {
               showToast(context, "First stop simulation");
             }
          }
          else {
            showToast(context, "First stop simulation");
          }
        });
  });
}
