import 'package:app/provider/auth.dart';
import 'package:app/screens/auth_screen.dart';
import 'package:app/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return FutureBuilder(
      future: auth.tryLoginaAutoLogin(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.error != null) {
          return Center(
            child: Text('Error'),
          );
        } else {
          return auth.isAuth ? ProductOverview() : AuthScreen();
        }
      },
    );
  }
}
