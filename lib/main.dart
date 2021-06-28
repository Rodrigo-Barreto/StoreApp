import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/product_overview_screen.dart';
import 'screens/product_details_screen.dart';

void main() {
  runApp(MyStore());
}

class MyStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Store',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.deepOrange,
        fontFamily: 'Lato',
      ),
      home: ProductOverview(),
      routes: {
        AppRoutes.Product_Details: (ctx) => ProductDetails(),
      },
    );
  }
}
