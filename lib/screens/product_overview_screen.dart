import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../components/product_item.dart';

class ProductOverview extends StatelessWidget {
  final List loaderProduct = DUMMY_PRODUCTS;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Store"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: loaderProduct.length,
        itemBuilder: (ctx, item) => ProductItem(
          product: loaderProduct[item],
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10),
      ),
    );
  }
}
