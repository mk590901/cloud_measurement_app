import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/button_bloc.dart';
import '../core/controller.dart';
import '../events/button_events.dart';
import '../interfaces/i_gui_action.dart';
import '../interfaces/i_sink.dart';
import '../blocs/icon_refreshing_bloc.dart';
import '../interfaces/i_update.dart';
import '../states/button_state.dart';
import '../states/icon_refreshing_state.dart';
import '../errors/errors.dart';
import '../utils/utils.dart';

// class Action implements IGUIAction {
//   final BuildContext context;
//
//   Action(this.context);
//
//   @override
//   void done(String? text) {
//     context.read<ButtonBloc>().add(Click());
//   }
// }

class WidgetButton extends StatelessWidget {
  WidgetButton({
    Key? key,
    required this.icon,
    required this.page,
  }) : super(key: key);

  final String uuid = const Uuid().v4().toString();
  final IconData icon;
  final String page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Listener(
        onPointerDown: (e) {
        },
        onPointerMove: (e) {
        },
        onPointerUp: (e) {
        },
        onPointerCancel: (e) {
        },
        child: BlocBuilder<ButtonBloc, ButtonState>(
            builder: (context, state) {

              return //Center(
                //child:
                  IconButton(
                      icon: Icon(icon),
                      color: Colors.white,
                      iconSize: 32,
                      onPressed: () {
                        //context.read<SelectPageBloc>().add(SelectPage().setData(page));
                      });

                // child: Icon(
                //   state.state().name == 'stop'
                //       ? Icons.play_arrow_sharp
                //       : Icons.pause_sharp,
                //   size: 40,
                //   color: Colors.white),
             // );

              //   //updater.addContext(context);
          //
          // return Center(
          //
          //   child: Icon(
          //     icon,
          //     size: min<double>(width.toDouble(), height.toDouble()) * 3 / 5,
          //     color: getColor(state.data()),
          //   ),
          // );



        }),
      ),
    );
  }

  // Color? getColor(ISink? data) {
  //   if (data == null /*|| data.data() == 0*/) {
  //     print('getColor 1');
  //     return Colors.white;
  //   }
  //   else
  //   if (data.data() == 0)   {
  //     print('getColor 2');
  //     return extractValueColor(data);
  //     //return Colors.white;
  //   }
  //   else {
  //     print('getColor 3');
  //     return Colors.deepPurple[200]?.withOpacity((_max - data.data())/_max);
  //   }
  // }
}
