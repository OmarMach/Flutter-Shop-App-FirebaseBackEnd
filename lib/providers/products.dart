import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  // List<Product> _dummyData = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex > 0) {
      final url =
          'https://fluttertutorial-bd6af.firebaseio.com//products/$id.json';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://fluttertutorial-bd6af.firebaseio.com//products/$id.json';
    final oldIndex = _items.indexWhere((prod) => prod.id == id);
    var oldProd = _items[oldIndex];
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(oldIndex, oldProd);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    } else
      oldProd = null;
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://fluttertutorial-bd6af.firebaseio.com//products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          description: product.description,
          imageUrl: product.imageUrl,
          title: product.title,
          price: product.price,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      print('the Error is :' + error.toString());
      throw error;
    }
  }

  Future<void> fetchData() async {
    const url = 'https://fluttertutorial-bd6af.firebaseio.com//products.json';
    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedItems = [];
      if (loadedData == null) return;
      loadedData.forEach((id, prod) {
        loadedItems.add(Product(
          id: id,
          description: prod['description'],
          imageUrl: prod['imageUrl'],
          price: prod['price'],
          title: prod['title'],
          isFavorite: prod['isFavorite'],
        ));
      });
      _items = loadedItems;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // void addDummyDataToServer() {
  //   try {
  //     _items.forEach((prod) => addProduct(prod));
  //     notifyListeners();
  //   } catch (error) {}
  // }
}
