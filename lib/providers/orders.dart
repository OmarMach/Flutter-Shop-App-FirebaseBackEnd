import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/cart.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          time: DateTime.now(),
          products: cartProducts,
        ));
        notifyListeners();
  }
}