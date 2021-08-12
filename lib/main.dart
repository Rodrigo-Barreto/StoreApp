import 'package:app/provider/cart_items.dart';
import 'package:app/provider/orders.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/orders_screen.dart';
import 'package:app/screens/product_form_screen.dart';
import 'package:app/screens/products_screen.dart';
import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
import 'screens/product_overview_screen.dart';
import 'screens/product_details_screen.dart';
import 'provider/products.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyStore());
}

class MyStore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Products()),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => Orders())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Store',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverview(),
        routes: {
          AppRoutes.Product_Details: (ctx) => ProductDetails(),
          AppRoutes.Cart: (ctx) => CartScreen(),
          AppRoutes.Orders_Screem: (ctx) => OrderScreen(),
          AppRoutes.Home: (ctx) => ProductOverview(),
          AppRoutes.ProductScreen: (ctx) => ProductScreen(),
          AppRoutes.ProductFormScreen: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
