import 'package:flutter/material.dart';

import 'interfaces/i_iterator.dart';
import 'interfaces/i_size_setter.dart';
import 'interfaces/i_color_setter.dart';

class CustomGridTile {

  CustomGridTile(this.crossAxisCount, this.mainAxisCount, this._widget) {
    (_widget as ISizeSetter).setSize(crossAxisCount * 100, mainAxisCount * 100);
  }

  CustomGridTile add(IIterator iterator) {
    this.iterator = iterator;
    return this;
  }

  Widget widget() {
    return _widget;
  }

  void setBackgroundColor(final Color? backgroundColor) {
    this.backgroundColor = backgroundColor;
    (_widget as IColorSetter).setColor(backgroundColor);
  }

  final int crossAxisCount;
  final int mainAxisCount;
  late Color? backgroundColor;

  final Widget _widget;
  late  IIterator iterator;


}
