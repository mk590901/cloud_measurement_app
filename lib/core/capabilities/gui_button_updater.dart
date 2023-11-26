import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/button_refreshing_bloc.dart';
import '../../errors/errors.dart';
import '../../events/refresh_events.dart';
import '../../interfaces/i_update.dart';
import '../../helpers/sink.dart';

class ButtonUpdater implements IUpdate {

  late String? uuid;
  late BuildContext? _context;

  ButtonUpdater();

  @override
  void update(data, bool progress, MeasurementError? error, DateTime? dateTime) {
    print ("ButtonUpdater.progress->$progress");
    _context?.read<ButtonRefreshingBloc>().add(Refresh().setData(Sink.value(uuid, data, progress, error, dateTime)));
  }

  @override
  void addContext(BuildContext? context) {
    _context = context;
    //print ("ButtonUpdater.addContext->[$_context]");
  }

  @override
  void setSink(String? uuid) {
    this.uuid = uuid;
  }

}