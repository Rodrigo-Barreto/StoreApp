import 'package:app/provider/auth.dart';
import 'package:app/provider/cart_items.dart';
import 'package:app/provider/orders.dart';
import 'package:app/screens/cart_screen.dart';
import 'package:app/screens/orders_screen.dart';
import 'package:app/screens/product_form_screen.dart';
import 'package:app/screens/products_screen.dart';
import 'package:app/utils/authOrHome.dart';
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
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', [], ''),
          update: (context, auth, previus) {
            return Products(
                auth.token ?? '', previus?.items ?? [], auth.userId ?? '');
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', [], ''),
          update: (context, auth, previus) {
            return Orders(
                auth.token ?? '', previus.orders ?? [], auth.userId ?? '');
          },
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Store',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: AuthOrHome(),
        routes: {
          AppRoutes.Product_Details: (ctx) => ProductDetails(),
          AppRoutes.Cart: (ctx) => CartScreen(),
          AppRoutes.Orders_Screem: (ctx) => OrderScreen(),
          AppRoutes.ProductOverview: (ctx) => ProductOverview(),
          AppRoutes.ProductScreen: (ctx) => ProductScreen(),
          AppRoutes.ProductFormScreen: (ctx) => ProductFormScreen(),
        },
      ),
    );
  }
}
