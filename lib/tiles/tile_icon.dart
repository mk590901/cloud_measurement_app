import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/controller.dart';
import '../interfaces/i_sink.dart';
import '../blocs/icon_refreshing_bloc.dart';
import '../interfaces/i_size_setter.dart';
import '../interfaces/i_update.dart';
import '../interfaces/i_color_setter.dart';
import '../states/icon_refreshing_state.dart';
import '../errors/errors.dart';
import '../utils/utils.dart';

class IconTile extends StatelessWidget implements ISizeSetter, IColorSetter {
  IconTile({
    Key? key,
    required this.icon,
    required this.width,
    required this.height,
  }) : super(key: key);

  IconTile.short({
    Key? key,
    required this.icon,
  }) : super(key: key);

  IconTile add(IUpdate updater) {
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IconRefreshingBloc, IconRefreshingState>(
        builder: (context, state) {
      ErrorType? lastError = Controller.controller()?.lastError();
      backgroundColor = extractBackgroundColorFromError(lastError);
      Color textColor = calculateInverseColor(backgroundColor);
      updater.addContext(context);

      return Scaffold(
        backgroundColor: backgroundColor,
        body: Listener(
          onPointerDown: (e) {
            updater.update(
                null, true, MeasurementError(ErrorType.ok), DateTime.now());
          },
          onPointerMove: (e) {
            //print('Move  [$id]');
          },
          onPointerUp: (e) {
            //@updater.update(null, false, MeasurementError(ErrorType.ok), DateTime.now());
            Controller.controller()?.start(uuid);
          },
          onPointerCancel: (e) {
            //print('Cancel [$id]');
          },
          child: Center(
            child: Icon(
              icon,
              size: min<double>(width.toDouble(), height.toDouble()) * 3 / 5,
              color: getColor(state.data(), textColor),
            ),
          ),
        ),
      );
    });
  }

  Color? getColor(ISink? data, Color? color) {
    if (data == null) {
      return color;
    } else if (data.data() == 0) {
      return color;
      ;
    } else {
      return color?.withOpacity((_max - data.data()) / _max);
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
