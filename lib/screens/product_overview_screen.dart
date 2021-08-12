import 'dart:convert';

import 'package:app/utils/push_page.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:app/widgets/badge.dart';
import 'package:app/provider/products.dart';
import 'package:app/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart_items.dart';
import '../utils/app_routes.dart';

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool toggleFAvorite = false;
  final pushPage = new Navigation();
  bool isLoading = true;

  void initState() {
    super.initState();

    Provider.of<Products>(context, listen: false).loadProducts().then((value) {
      setState(() {
        isLoading = false;
      });
    });

    // responsavel por carregar os produtos
  }

  Widget build(BuildContext context) {
    Products product = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
        actions: [
          PopupMenuButton(
            onSelected: (int contador) {
              if (contador == 0) {
                product.showFavoriteOnly();
              } else {
                product.showall();
              }
            },
            icon: Icon(Icons.more_vert_rounded),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorite'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('All'),
                value: 1,
              )
            ],
          ),
          Consumer<Cart>(
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () => pushPage.pushPage(context, AppRoutes.Cart),
            ),
            builder: (_, cart, child) => Badge(
              value: cart.itemCount.toString(),
              child: child,
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(),
    );
  }
}
