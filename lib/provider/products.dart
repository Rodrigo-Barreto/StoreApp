import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../utils/urls.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  String token;
  String userId;

  Products(this.token, this._items, this.userId);

  final String _baseUrl = '${baseUrl.BASE_API_URL}/products';
  final String _baseUrlFavorite = '${baseUrl.USER_FAVORITE}';

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl.json?auth=$token'));
    Map<String, dynamic> data = jsonDecode(response.body);

    final Favresponse = await http.get(
      Uri.parse("$_baseUrlFavorite/$userId.json?auth=$token"),
    );

    Map<String, dynamic> favData =
        Favresponse.body == 'null' ? {} : jsonDecode(Favresponse.body);

    _items.clear();

    if (data != null) {
      data.forEach(
        (productId, productData) {
          final isFavorite = favData[productId] ?? false;

          _items.add(
            Product(
              id: productId,
              title: productData['title'],
              price: productData['price'],
              description: productData['description'],
              imageUrl: productData['imageUrl'],
              isFavorite: isFavorite,
            ),
          );
        },
      );

      notifyListeners();
    }

    Future.value();
  }

  bool _showFavoriteOnly = false;
  List<Product> get items {
    if (_showFavoriteOnly) {
      print(_showFavoriteOnly);
      return _items.where((element) => element.isFavorite).toList();
    }
    return [..._items];
  }

  Future<void> addProduct(Product newProduct) async {
    final response = await http.post(
      Uri.parse('$_baseUrl.json?auth=$token'),
      body: jsonEncode(
        {
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        },
      ),
    );

    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showall() {
    _showFavoriteOnly = false;
    print(_showFavoriteOnly);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      print('Id do produto é null');
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      await http.patch(Uri.parse("$_baseUrl/${product.id}.json?auth=$token'"),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
          }));
      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      var product = _items[index];

      _items.remove(product);
      notifyListeners();

      final response = await http
          .delete(Uri.parse("$_baseUrl/${product.id}.json?auth=$token'"));

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw ('Http Error');
      }
    }
  }
}
