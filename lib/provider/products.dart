import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];

  final String _baseUrl =
      'https://flutter-studies-ec810-default-rtdb.firebaseio.com/products';

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl.json'));
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
    final response = await http.post(Uri.parse('$_baseUrl.json'),
        body: jsonEncode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'isFavorite': newProduct.isFavorite
        }));

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
      await http.patch(Uri.parse("$_baseUrl/${product.id}.json"),
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

      final response = await http.delete(Uri.parse("$_baseUrl/${product.id}.json"));

      if(response.statusCode>=400){
        _items.insert(index, product);
        notifyListeners();
        throw('Http Error');

      }
      
    }
  }
}
