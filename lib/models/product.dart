import 'dart:convert';
import '../utils/urls.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;
  String token;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });
  final String _baseUrl = '${baseUrl.USER_FAVORITE}';

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite(String id, String token, String userId) async {
    _toggleFavorite();

    try {
      final response = await http.put(
        Uri.parse("$_baseUrl/$userId/$id.json?auth=$token"),
        body: json.encode(
          isFavorite,
        ),
      );

      if (response.statusCode >= 400) {
        _toggleFavorite();
      }
    } catch (error) {
      _toggleFavorite();
      print(error);
    }
  }
}
