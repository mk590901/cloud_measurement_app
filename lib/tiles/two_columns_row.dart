import 'package:flutter/material.dart';

class TwoColumnRow extends StatelessWidget {
  final Widget widgetLeft;
  final Widget widgetRight;

  const TwoColumnRow({
    Key? key,
    required this.widgetLeft,
    required this.widgetRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: widgetLeft,
          ),
        ),
        Expanded(
          child: Center(
            child: widgetRight,
          ),
        ),
      ],
    );
  }
}
