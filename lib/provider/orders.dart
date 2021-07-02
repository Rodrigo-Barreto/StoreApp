import 'dart:math';

import 'package:app/models/cart.dart';
import 'package:app/provider/cart_items.dart';
import 'package:flutter/material.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  void addOrder(Cart cart) {
    _orders.insert(
      0,
      Order(
        id: Random().nextDouble().toString(),
        amount: cart.totalAmount,
        date: DateTime.now(),
        products: cart.item.values.toList(),
      ),
    );
  }
}
