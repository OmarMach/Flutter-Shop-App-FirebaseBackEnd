import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/app_drawer.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart.dart';
import 'package:shop_app/widgets/product_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showOnlyfav = false;
  var _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    // Provider.of<Products>(context, listen: false).addDummyDataToServer();
    Provider.of<Products>(context, listen: false).fetchData(true).then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text("Articles disponibles"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.filter_list),
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites)
                  showOnlyfav = true;
                else
                  showOnlyfav = false;
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Afficher les favoris'),
                  value: FilterOptions.Favorites),
              PopupMenuItem(
                child: Text('Afficher tous les articles'),
                value: FilterOptions.All,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cartData, child) => Badge(
              child: child,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyfav),
    );
  }
}
