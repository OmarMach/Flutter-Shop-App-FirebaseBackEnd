import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart' show Cart;
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/cart_list_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = 'cart';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    Provider.of<Orders>(context, listen: false).fetchOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("The cart ok?"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ${cart.totalAmount}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderNow(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (context, index) => CartListItem(
                price: cart.items.values.toList()[index].price,
                title: cart.items.values.toList()[index].title,
                id: cart.items.values.toList()[index].id,
                productId: cart.items.keys.toList()[index],
                quantity: cart.items.values.toList()[index].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderNow extends StatefulWidget {
  const OrderNow({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderNowState createState() => _OrderNowState();
}

class _OrderNowState extends State<OrderNow> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: widget.cart.totalAmount <= 0
          ? Colors.white
          : Theme.of(context).errorColor,
      child: _isLoading ? CircularProgressIndicator() : Text("Order now."),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? () => null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Items Ordered.'),
                ));
                widget.cart.clearCart();
              } catch (error) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                      'Error while ordering the items, please check your internet connection.'),
                ));
              }
              setState(() {
                _isLoading = false;
              });
            },
    );
  }
}
