import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  final String _baseUrl =
      'https://flutter-studies-ec810-default-rtdb.firebaseio.com/products';

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(Product product) async {
    _toggleFavorite();

    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/${product.id}.json"),
        body: json.encode({'isFavorite': isFavorite}),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
    }
  }
}
