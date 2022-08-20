import 'package:buffywalls_3/home.dart';
import 'package:buffywalls_3/pages/on_board_page.dart';
import 'package:flutter/material.dart';

class MyRoutes {
  Map<String, WidgetBuilder> getRoutes(context) => {
        '/': (BuildContext context) => const Home(),
        '/onBoard': (BuildContext context) => const OnBoarding(),
      };
}
