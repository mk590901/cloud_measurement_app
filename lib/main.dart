import 'package:cloud_measurement_app/core/cloud_temperature_sensor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/button_bloc.dart';
import 'blocs/button_refreshing_bloc.dart';
import 'blocs/select_page_bloc.dart';
import 'core/application_holder.dart';
import 'core/controller.dart';
import 'core/errors_helper.dart';
import 'core/temperature_sensor.dart';
import 'factory_pager.dart';
import 'pages/main_layout_page.dart';
import 'states/button_refreshing_state.dart';
import 'states/button_state.dart';
import 'states/select_state.dart';
import 'states/text_refreshing_state.dart';
import 'blocs/text_refreshing_bloc.dart';
import 'states/icon_refreshing_state.dart';
import 'blocs/icon_refreshing_bloc.dart';

void main() {
  ApplicationHolder.initInstance();
  FactoryPager.initInstance();
  ErrorsHelper.initInstance();
  TemperatureSensor.initInstance();
  CloudTemperatureSensor.initInstance();
  Controller.initInstance();
// Change in login/logout ////////////////////////////////////////////
  TemperatureSensor.sensor()?.setController(Controller.controller());
// Change in login/logout ////////////////////////////////////////////
  runApp(const TemperatureSensorApp());
}

class TemperatureSensorApp extends StatelessWidget {
  const TemperatureSensorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staggered Grid View Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blueGrey,
        //   canvasColor: Colors.grey,
        scaffoldBackgroundColor: Colors.grey,
      ),

      home: MultiBlocProvider(
        providers: [
          BlocProvider<ButtonBloc>(
            create: (_) => ButtonBloc(ButtonState(ButtonStates.stop)),
          ),
          BlocProvider<TextRefreshingBloc>(
            create: (_) => TextRefreshingBloc(TextRefreshingState(TextRefreshingStates.refreshing)),
          ),
          BlocProvider<IconRefreshingBloc>(
            create: (_) => IconRefreshingBloc(IconRefreshingState(IconRefreshingStates.refreshing)),
          ),
          BlocProvider<ButtonRefreshingBloc>(
            create: (_) => ButtonRefreshingBloc(ButtonRefreshingState(ButtonRefreshingStates.refreshing)),
          ),
          BlocProvider<SelectPageBloc>(
            create: (_) => SelectPageBloc(SelectState(SelectStates.select)),
          ),
        ],
        child: const MainLayoutPage(),
      ),
    );
  }
}
