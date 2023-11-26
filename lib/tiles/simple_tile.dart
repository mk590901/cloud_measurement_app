import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../blocs/select_page_bloc.dart';
import '../events/select_page_events.dart';
import '../states/select_state.dart';

class SimpleTile extends StatelessWidget {
  SimpleTile({
    Key? key,
    required this.icon,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String uuid = const Uuid().v4().toString();
  final IconData icon;
  final int width;
  final int height;

  void refresh(BuildContext context) {
    context.read<SelectPageBloc>().add(SelectPage().setData("custom"));
  }

  // SimpleTile add(IIterator iterator) {
  //   this.iterator = iterator;
  //   this.iterator.setUuid(uuid);
  //   return this;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (e) {},
        onPointerMove: (e) {},
        onPointerUp: (e) {
          // print ("SimpleTile.Up");
          // refresh(context);
        },
        onPointerCancel: (e) {},
        child:

        BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {

          return Center(

            child: Icon(
                icon,
                size: min<double>(width.toDouble(), height.toDouble()) * 3 / 5,
                color: Colors.deepOrange//getColor(state.data()),
            ),
          );


          // return Image.network(
          //   'https://picsum.photos/$width/$height?random=250',
          //   width: width.toDouble(),
          //   height: height.toDouble(),
          //   fit: BoxFit.cover,
          // );


        }),
      ),
    );
  }
}
