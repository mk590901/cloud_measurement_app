import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/button_bloc.dart';
import '../blocs/button_refreshing_bloc.dart';
import '../core/controller.dart';
import '../events/button_events.dart';
import '../interfaces/i_gui_action.dart';
import '../interfaces/i_sink.dart';
import '../interfaces/i_size_setter.dart';
import '../interfaces/i_update.dart';
import '../interfaces/i_color_setter.dart';
import '../states/button_refreshing_state.dart';
import '../utils/utils.dart';

class Action implements IGUIAction {
  final BuildContext context;

  Action(this.context);

  @override
  void done(String? text) {
    context.read<ButtonBloc>().add(Click());
  }
}

class ButtonTile extends StatelessWidget implements ISizeSetter, IColorSetter {
  ButtonTile({
    Key? key,
    required this.icon,
    required this.width,
    required this.height,
  }) : super(key: key);

  ButtonTile.short({
    Key? key,
    required this.icon,
  }) : super(key: key);

  ButtonTile add(IUpdate updater) {
    this.updater = updater;
    this.updater.setSink(uuid);

    Controller.controller()?.register(uuid, updater, runtimeType);

    return this;
  }

  final String uuid = const Uuid().v4().toString();
  final IconData icon;
  late Color? backgroundColor = Colors.lightBlue;
  late int width;
  late int height;

  late IUpdate updater;
  final int _max = 16;

  void refresh(BuildContext context) {
    Action action = Action(context);
    Controller.controller()?.registerAction(action);
    action.done('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ButtonRefreshingBloc, ButtonRefreshingState>(
        builder: (context, state) {
      backgroundColor = extractBackgroundColor(state.data());
      Color textColor = calculateInverseColor(backgroundColor);
      bool progress = extractProgress(state.data());
      updater.addContext(context);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Listener(
          onPointerDown: (e) {
            //updater.update(null, true, MeasurementError(ErrorType.ok), DateTime.now());
          },
          onPointerMove: (e) {},
          onPointerUp: (e) {
            Controller.controller()?.updateAlertWrapper(1);
            Controller.controller()?.start(uuid);
          },
          onPointerCancel: (e) {},
          child: Center(
            child: Icon(
                progress == false ? Icons.play_arrow_sharp : Icons.pause_sharp,
                size: 40,
                color: textColor),
          ),
        ),
      );
    });
  }

  Color? getColor(ISink? data) {
    if (data == null /*|| data.data() == 0*/) {
      return Colors.white;
    } else if (data.data() == 0) {
      return extractValueColor(data);
    } else {
      return Colors.deepPurple[200]?.withOpacity((_max - data.data()) / _max);
    }
  }

  @override
  void setSize(int width, int height) {
    this.width = width;
    this.height = height;
  }

  @override
  void setColor(Color? color) {
    backgroundColor = color;
  }

  Color calculateInverseColor(Color? color) {
    final invertedRed = 255 - color!.red;
    final invertedGreen = 255 - color.green;
    final invertedBlue = 255 - color.blue;
    return Color.fromRGBO(invertedRed, invertedGreen, invertedBlue, 1.0);
  }
}
