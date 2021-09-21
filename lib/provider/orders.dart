import 'dart:async';
import 'dart:convert';
import 'package:app/models/cart.dart';
import 'package:app/provider/cart_items.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/order.dart';
import '../utils/urls.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  String _token;
  String userId;

  List<Order> get orders {
    return [..._orders];
  }

  Orders(
    this._token,
    this._orders,
    this.userId,
  );

  final String _baseUrl = '${baseUrl.BASE_API_URL}orders';

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      Uri.parse('$_baseUrl.json?auth=$_token'),
      body: json.encode(
        {
          'userId': userId,
          'amount': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.item.values
              .map(
                (cartItem) => {
                  'productId': cartItem.id,
                  'title': cartItem.title,
                  'quantity': cartItem.quantity,
                  ' price': cartItem.price,
                  'imgUrl': cartItem.imgUrl,
                },
              )
              .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      Order(
        id: json.decode(response.body)['name'],
        amount: cart.totalAmount,
        date: date,
        products: cart.item.values.toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> loaderOrdens() async {
    print(userId);
    _orders = [];

    final response = await http.get(
      Uri.parse('$_baseUrl.json?auth=$_token'),
    );

    Map<String, dynamic> data = json.decode(response.body);

    if (data['error'] == null) {
      data.forEach((orderId, order) {
        if (order['userId'] == userId) {
          _orders.add(Order(
            id: orderId,
            amount: order['amount'],
            date: DateTime.parse(order['date']),
            products: (order['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item['id'],
                title: item['title'],
                quantity: item['quantity'],
                price: item['price'],
                productId: item['productId'],
              );
            }).toList(),
          ));
        }
      });
      _orders = _orders.reversed.toList();
      notifyListeners();
    }
    Future.value();
  }
}
