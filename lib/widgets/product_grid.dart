import 'package:flutter/material.dart';
import 'package:app/models/product.dart';
import 'package:app/provider/products.dart';
import 'package:provider/provider.dart';
import '../components/product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Product> loaderProduct = Provider.of<Products>(context).items;
    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: loaderProduct.length,
      itemBuilder: (ctx, item) => ChangeNotifierProvider.value(
        value: loaderProduct[item],
        child: ProductGridItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
    );
  }
}
