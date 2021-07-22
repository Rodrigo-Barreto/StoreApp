import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];
  final _url = Uri.parse(
    'https://flutter-studies-ec810-default-rtdb.firebaseio.com/products.json',
  );

  Future<void> loadProducts() async {
    final response = await http.get(_url);
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();

    if (data != null) {
      data.forEach(
        (productId, productData) {
          _items.add(Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ));
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
    final response = await http.post(_url,
        body: jsonEncode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'isFavorite': newProduct.isFavorite
        }));

    _items.add(Product(
      id: json.decode(response.body)['name'],
      title: newProduct.title,
      price: newProduct.price,
      description: newProduct.description,
      imageUrl: newProduct.imageUrl,
    ));
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

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == id);

    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }
}
