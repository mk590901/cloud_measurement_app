import 'package:flutter/material.dart';
import 'custom_grid_tile.dart';
import 'tiles/device_tile.dart';
import 'tiles/help_page.dart';
import 'tiles/login_page.dart';
import 'tiles/logout_page.dart';
import 'tiles/simple_tile.dart';

class FactoryPager {
  static FactoryPager? _instance;

  static FactoryPager? pager() {
    if (_instance == null) {
      throw Exception("--- FactoryPager was not initialized ---");
    }
    return _instance;
  }

  static void initInstance() {
    _instance ??= FactoryPager();
  }

  Widget getWidget(final String? tag, final int width,
      final int height, final List<CustomGridTile> tiles) {
    switch (tag) {
      case 'logout':
         return const LogoutPage('Account Management', );
      case 'login':
        return const LoginPage('Account Management', Colors.lightBlueAccent);
      case 'help':
        return HelpPage ();
      case 'device':
        return DeviceTile (icon: Icons.account_balance_sharp, width: 200, height: 200, tiles: tiles);
    }
    return SimpleTile (icon: Icons.error, width: width, height: height,);
  }
}