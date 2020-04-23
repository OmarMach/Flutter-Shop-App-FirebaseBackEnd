import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/screens/splash_screen.dart.dart';
import 'package:shop_app/screens/user_products_screen.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (BuildContext context, Auth value, Products previous) =>
              Products(
            previous == null ? [] : previous.items,
            value.token,
            value.userId,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (BuildContext context, Auth value, Orders previous) => Orders(
              previous == null ? [] : previous.orders,
              value.token,
              value.userId),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CheDarek Delivery App',
          theme: ThemeData(
              primarySwatch: Colors.teal,
              accentColor: Colors.indigoAccent,
              fontFamily: 'Lato'),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, authSnpashot) =>
                      authSnpashot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            EditProductScreen.routeName: (context) => EditProductScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          },
        ),
      ),
    );
  }
}
