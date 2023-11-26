import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../blocs/button_bloc.dart';
import '../blocs/select_page_bloc.dart';
import '../custom_grid_tile.dart';
import '../events/button_events.dart';
import '../src/widgets/staggered_grid.dart';
import '../src/widgets/staggered_grid_tile.dart';
import '../states/select_state.dart';
import '../interfaces/i_gui_action.dart';

class Action implements IGUIAction {
  final BuildContext context;

  Action(this.context);

  @override
  void done(String? text) {
    context.read<ButtonBloc>().add(Click());
  }
}

class DeviceTile extends StatelessWidget {
  DeviceTile({
    Key? key,
    required this.icon,
    required this.width,
    required this.height,
    required this.tiles,
  }) : super(key: key);

  final String uuid = const Uuid().v4().toString();
  final IconData icon;
  final int width;
  final int height;
  final List<CustomGridTile> tiles;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: (e) {},
        onPointerMove: (e) {},
        onPointerUp: (e) {
        },
        onPointerCancel: (e) {},
        child: BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {
          return Center(
            child: SingleChildScrollView(
              child: StaggeredGrid.count(
                crossAxisCount: 5,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                children: [
                  ...tiles.mapIndexed((index, tile) {
                    return StaggeredGridTile.count(
                      crossAxisCellCount: tile.crossAxisCount,
                      mainAxisCellCount: tile.mainAxisCount,
                      child: tile.widget(),
                    );
                  }),
                ],
              ),
            ), // This trailing comma makes auto-formatting nicer for build methods.
          );
        }),
      ),
    );
  }
}
