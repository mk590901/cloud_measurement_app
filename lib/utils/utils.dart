import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/controller.dart';
import '../core/error_wrapper.dart';
import '../core/errors_helper.dart';
import '../errors/errors.dart';
import '../interfaces/i_sink.dart';

String extractValue(var data) {
  String result = 'XXX';
  if (data == null) {
    return Controller.controller()!.getLastValue();
  }
  if (data is ISink) {
    if (data.data() != null) {
      result = getPrefix(data);
    } else {
      return Controller.controller()!.getLastValue();
    }
  }
  return result;
}

String getPrefix(ISink<dynamic> data) {
  String prefix = '';
  ErrorType? errorType = data.error()?.errorType();
  if (errorType == ErrorType.out_range) {
    prefix  = '\u2251';
  }
  if (errorType == ErrorType.cancel) {
    prefix  = '\u21bb';
  }
  else
  if (errorType == ErrorType.ok) {
    prefix  = ' ';
  }
  else
  if (errorType == ErrorType.failed) {
    prefix  = '\u223F';
  }
  else
  if (errorType == ErrorType.critical_high) {
    prefix  = '\u21c8';
  }
  else
  if (errorType == ErrorType.warning_high) {
    prefix  = '\u2191';
  }
  else
  if (errorType == ErrorType.critical_low) {
    prefix  = '\u21ca';
  }
  else
  if (errorType == ErrorType.warning_low) {
    prefix  = '\u2193';
  }
  return prefix + data.data();
}

bool extractProgress(var data) {
  bool result = false;
  if (data == null) {
    return result;
  }
  if (data is ISink) {
    if (data.data() != null) {
      result = data.progress() == null ? false : data.progress()!;
    } else {
      return result;
    }
  }
  return result;
}

Color extractButtonColor(var data) {
  Color result = Colors.white;
  if (data == null) {
    return result;
  }
  if (data is ISink) {
    if (data.data() != null) {
      result = data.progress() == null ? Colors.white : data.progress()! ? Colors.deepOrange : Colors.amber;
    } else {
      return result;
    }
  }
  return result;
}

Color extractBackgroundColorFromError(ErrorType? errorType) {
  Color result = Colors.lightBlue;
  if (errorType == null) {
    //print ("1) extractBackgroundColor->$result");
    return result;
  }
  ErrorWrapper? wrapper = ErrorsHelper.errorsHelper()?.wrapper(errorType);
  if (wrapper != null) {
    result = wrapper.valueColor();
        //print ("@) extractBackgroundColor->$result");
  }
  //print ("3) extractBackgroundColor->$result");
  return result;
}

Color extractBackgroundColor(var data) {
  Color result = Colors.lightBlue;
  if (data == null) {
    //print ("1) extractBackgroundColor->$result");
    return result;
  }
  if (data is ISink) {
    if (data.error() != null) {
      ErrorType? errorType = data.error()?.errorType();
      ErrorWrapper? wrapper = ErrorsHelper.errorsHelper()?.wrapper(errorType!);
      if (wrapper != null) {
        result = wrapper.valueColor();
        //print ("@) extractBackgroundColor->$result");
      }
    } else {
      //print ("2) extractBackgroundColor->$result");
      return result;
    }
  }
  //print ("3) extractBackgroundColor->$result");
  return result;
}

Color extractValueColor(var data) {
  Color result = Colors.white12;
  if (data == null) {
    return Colors.white;
  }
  if (data is ISink) {
    if (data.error() != null) {
      ErrorType? errorType = data.error()?.errorType();
      ErrorWrapper? wrapper = ErrorsHelper.errorsHelper()?.wrapper(errorType!);
      if (wrapper != null) {
        result = wrapper.valueColor();
      }
    } else {
      return Colors.white;
    }
  }
  return result;
}

Color extractTextColor(var data) {
  Color result = Colors.white12;
  if (data == null) {
    return Colors.white;
  }
  if (data is ISink) {
    if (data.error() != null) {
      ErrorType? errorType = data.error()?.errorType();
      ErrorWrapper? wrapper = ErrorsHelper.errorsHelper()?.wrapper(errorType!);
      if (wrapper != null) {
        result = wrapper.textColor();
      }
    } else {
      return Colors.white;
    }
  }
  return result;
}

String extractDescription(var data) {
  String result = "";
  if (data == null) {
    return result;
  }
  if (data is ISink) {
    if (data.error() != null) {
      ErrorType? errorType = data.error()?.errorType();
      ErrorWrapper? wrapper = ErrorsHelper.errorsHelper()?.wrapper(errorType!);
      if (wrapper != null) {
        result = wrapper.description();
      }
    } else {
      return result;
    }
  }
  return result;
}

String extractDateTime(var data) {
  String result = "";
  if (data == null) {
    return result;
  }
  if (data is ISink) {
    if (data.data() != null) {
      result = composeDateTime(data.dateTime());
    } else {
      return result;
    }
  }
  return result;
}

String composeDateTime(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }
  String result =
      "${string(dateTime.day,2)}.${string(dateTime.month,2)}.${dateTime.year}\n${string(dateTime.hour,2)}:${string(dateTime.minute,2)}:${string(dateTime.second,2)},${string(dateTime.millisecond,3)}";
  return result;
}

String string(int number, int digits) {
  return number.toString().padLeft(digits, '0');
}

ButtonStyle getButtonStyle() {
  return ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(15)),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: const BorderSide(color: Colors.blueAccent)
          )
      )
  );
}

Future<dynamic> tryExit(BuildContext context) async {

  final buttonStyle = getButtonStyle();

  return (await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.grey,
      title: const Text('Are you sure?'),
      content: const Text('Do you want to exit an application'),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0))),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: buttonStyle,
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Controller.controller()?.clearListeners();
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
           },
          style: buttonStyle,
          child: const Text('Yes'),
        ),
      ],
    ),
  )) ?? false;
}

bool onBack() {
  return true;
}

void showToast(BuildContext context, String text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      content: Text(text),
      action: SnackBarAction(
          label: 'CLOSE', onPressed: scaffold.hideCurrentSnackBar),
    ),
  );
}

