import 'package:flutter/material.dart';

class Navigation {
  void pushPage(BuildContext context, route, [arguments]) {
    Navigator.of(context).pushNamed(
      route,
      arguments: arguments,
    );
  }

  void pushRepace(BuildContext context, route) {
    Navigator.of(context).pushReplacementNamed(route);
  }
}
