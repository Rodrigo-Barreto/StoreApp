import 'package:app/models/product.dart';
import 'package:app/provider/products.dart';
import 'package:app/widgets/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  bool toggleFAvorite = false;

  Widget build(BuildContext context) {
    Products product = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
        centerTitle: true,
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
        ],
      ),
      body: ProductsGrid(),
    );
  }
}
