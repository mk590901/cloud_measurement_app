import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'two_columns_row.dart';
import '../blocs/text_refreshing_bloc.dart';
import '../core/controller.dart';
import '../interfaces/i_size_setter.dart';
import '../interfaces/i_update.dart';
import '../interfaces/i_color_setter.dart';
import '../states/text_refreshing_state.dart';
import '../utils/utils.dart';

class TextValueExtTile extends StatelessWidget
    implements ISizeSetter, IColorSetter {
  TextValueExtTile({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  TextValueExtTile.short({
    Key? key,
  }) : super(key: key);

  String? text;
  final String uuid = const Uuid().v4().toString();
  late Color? backgroundColor = Colors.lightBlue;
  late int width;
  late int height;
  late IUpdate updater;

  TextValueExtTile add(IUpdate updater) {
    this.updater = updater;
    this.updater.setSink(uuid);

    Controller.controller()?.register(uuid, updater, runtimeType);

    return this;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TextRefreshingBloc, TextRefreshingState>(
        builder: (context, state) {
      backgroundColor = extractBackgroundColor(state.data());
      Color textColor = calculateInverseColor(backgroundColor);
      updater.addContext(context);
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Listener(
          onPointerDown: (e) {
//          print('Down  [$id]');
          },
          onPointerMove: (e) {
//          print('Move  [$id]');
          },
          onPointerUp: (e) {
//          print('Up    [$id]');
            Controller.controller()?.start(uuid);
          },
          onPointerCancel: (e) {
//          print('Cancel [$id]');
          },
          child: Stack(
            children: <Widget>[
              TwoColumnRow(
                widgetLeft: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      extractValue(state.data()),
                      style: TextStyle(
                        fontSize: height.toDouble() / 4,
                        color: textColor, // set text color to blue
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "°C",
                      style: TextStyle(
                        fontSize: height.toDouble() / 6,
                        color: textColor, // set text color to blue
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                widgetRight: Text(
                  extractDateTime(state.data()),
                  style: TextStyle(
                    fontSize: height.toDouble() / 6,
                    color: textColor, // set text color to blue
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              Visibility(
                visible: extractProgress(state.data()),
                child: Center(
                  child: CupertinoActivityIndicator(
                    color: calculateInverseColor(
                        extractBackgroundColor(state.data())),
                    //Colors.white,
                    radius: height.toDouble() / 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
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
