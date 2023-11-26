import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/select_page_bloc.dart';
import '../factory_pager.dart';
import '../interfaces/i_gui_action.dart';
import '../blocs/button_bloc.dart';
import '../events/button_events.dart';
import '../states/button_state.dart';
import '../common.dart';
import '../custom_grid_tile.dart';
import '../core/capabilities/gui_icon_updater.dart';
import '../core/capabilities/gui_button_updater.dart';
import '../core/controller.dart';
import '../states/select_state.dart';
import '../tiles/tile_button.dart';
import '../tiles/tile_icon.dart';
import '../tiles/tile_text_value_ext.dart';
import '../core/capabilities/gui_text_updater.dart';
import '../utils/utils.dart';

class Action implements IGUIAction {
  final BuildContext context;

  Action(this.context);

  @override
  void done(String? text) {
    context.read<ButtonBloc>().add(Click());
  }
}

class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({
    Key? key,
  }) : super(key: key);

  static final tiles = [
    CustomGridTile(
        1,
        1,
        IconTile.short(
          icon: Icons.thermostat_sharp,
        ).add(IconUpdater())),
    CustomGridTile(3, 1, TextValueExtTile.short().add(TextUpdater())),
    CustomGridTile(
        1,
        1,
        ButtonTile.short(
          icon: Icons.play_arrow_sharp,
        ).add(ButtonUpdater())),
  ];

  void refresh(BuildContext context) {
    Action action = Action(context);
    Controller.controller()?.updateAlertWrapper(3);
    Controller.controller()?.registerAction(action);
    action.done('');
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> onBackPressed() async {
      bool rc = onBack();
      if (!rc) {
        return rc;
      } else {
        return await tryExit(context);
      }
    }

    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: onBackPressed,
      child: AppScaffold(
        title: 'SENSOR',
        floatingActionButton:

        BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {

          String? page = state.data();
          print('1) page [$page]');

          return Visibility(
            visible: page == 'device',
            child: FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () {
                refresh(context);
              },
              tooltip: 'SENSOR BLoC page',
              child:
              BlocBuilder<ButtonBloc, ButtonState>(builder: (context, state) {
                return Icon(
                    state
                        .state()
                        .name == 'stop'
                        ? Icons.play_arrow_sharp
                        : Icons.pause_sharp,
                    size: 40,
                    color: Colors.white);
              }),
            ),
          );
        }),

        child: BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {
          String? page = state.data();

          // if (page != 'device') {
          //   if (Controller.controller()!.isContinuosMeasurement()) {
          //     Controller.controller()!.finalContinuosMeasurement();
          //     //print('*** finalContinuosMeasurement ***');
          //   }
          // }

          print('2) page [$page] ${Controller.controller()!.isContinuosMeasurement()}');

          return FactoryPager.pager()!.getWidget(page!,
              screenSize.width.toInt(), screenSize.height.toInt(), tiles);
        }),
      ),
    );
  }
}
