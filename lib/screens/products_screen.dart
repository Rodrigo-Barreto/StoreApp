import 'package:app/components/product_item.dart';
import 'package:app/provider/products.dart';
import 'package:app/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/push_page.dart';
import '../utils/app_routes.dart';

class ProductScreen extends StatefulWidget {
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Future<void> refreshProducts(BuildContext context) {
    return Provider.of<Products>(context, listen: false).loadProducts();
  }

  @override
  void initState() {
    Provider.of<Products>(context, listen: false).loadProducts();
    super.initState();
  }

  @override
  final pushPage = Navigation();

  Widget build(BuildContext context) {
    final Products products = Provider.of(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              pushPage.pushPage(context, AppRoutes.ProductFormScreen);
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: Text('Products Manager'),
      ),
      body: RefreshIndicator(
        onRefresh: () => refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: products.itemsCount,
              itemBuilder: (ctx, item) {
                return Column(
                  children: [
                    ProductItem(
                      product: products.items[item],
                    ),
                    Divider(),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
