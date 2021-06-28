import 'package:app/models/product.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
    );
  }
}
