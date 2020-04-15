import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime time;

  OrderItem({
    @required @required this.id,
    this.amount,
    @required this.products,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    final url = 'https://fluttertutorial-bd6af.firebaseio.com//orders.json';
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity,
                  })
              .toList()
        }));
    _orders.add(OrderItem(
      id: json.decode(response.body)['name'],
      amount: total,
      time: timestamp,
      products: cartProducts,
    ));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://fluttertutorial-bd6af.firebaseio.com/orders.json';
    try {
      final response = await http.get(url);
      final List<OrderItem> extractedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) return;
      extractedData.forEach((orderId, orderData) {
        extractedOrders.add(
          OrderItem(
              id: orderId,
              time: DateTime.parse(orderData['dateTime']),
              amount: orderData['amount'],
              products: (orderData['products'] as List<dynamic>)
                  .map(
                    (item) => CartItem(
                      id: item['id'],
                      price: item['price'],
                      quantity: item['quantity'],
                      title: item['title'],
                    ),
                  )
                  .toList()),
        );
      });
      _orders = extractedOrders;
    } catch (error) {
      print('the error is :' + error.toString());
    }
    notifyListeners();
  }
}
