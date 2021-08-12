import 'package:app/models/cart.dart';

class Order {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.amount,
    this.products,
    this.date,
  });
}
