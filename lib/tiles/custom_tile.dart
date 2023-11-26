import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../blocs/select_page_bloc.dart';
import '../events/select_page_events.dart';
import '../states/select_state.dart';

class CustomTile extends StatelessWidget {
  CustomTile({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final String uuid = const Uuid().v4().toString();
  final int width;
  final int height;
  //late IIterator iterator;

  void refresh(BuildContext context) {
    //context.read<SelectPageBloc>().add(SelectPage().setData("sample"));
    context.read<SelectPageBloc>().add(SelectPage().setData("device"));
  }

  // ImageTile add(IIterator iterator) {
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
          // print ("CustomTile.Up");
          // refresh(context);
        },
        onPointerCancel: (e) {},
        child:
        BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {
          return Image.network(
            'https://picsum.photos/$width/$height?random=120',
            width: width.toDouble(),
            height: height.toDouble(),
            fit: BoxFit.cover,
          );
        }),



      ),
    );
  }
}
