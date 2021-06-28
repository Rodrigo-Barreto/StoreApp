import 'package:flutter/material.dart';

void pushPage(BuildContext context, route, arguments) {
  Navigator.of(context).pushNamed(
    route,
    arguments: arguments,
  );
}
