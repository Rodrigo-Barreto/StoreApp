import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imgUrl;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price,
      this.imgUrl,
      @required this.productId});
}
