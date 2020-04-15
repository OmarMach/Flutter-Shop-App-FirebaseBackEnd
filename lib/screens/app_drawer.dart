import 'package:flutter/material.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Navigate."),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            title: Text('Items'),
            leading: Icon(Icons.shop),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            title: Text('Orders'),
            leading: Icon(Icons.payment),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrdersScreen.routeName),
          ),
          Divider(
            color: Colors.blue,
          ),
          ListTile(
            title: Text('Admin Panel'),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName),
          ),
        ],
      ),
    );
  }
}
