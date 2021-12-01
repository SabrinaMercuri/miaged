import 'package:flutter/material.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/screens/basket/basket_screen.dart';
import 'package:miaged/screens/home/home_screen.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';

class ItemScreen extends StatefulWidget {
  const ItemScreen({Key? key, required this.item}) : super (key: key);
  final AppItemData item;


  @override
  _ItemScreenState createState() {
    return _ItemScreenState(item: item);
  }
}

class _ItemScreenState extends State {
  final AuthenticationService _auth = AuthenticationService();
  _ItemScreenState({Key? key, required this.item}) : super ();
  final AppItemData item;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = DatabaseService(uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2', uidItem: item.uid);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: Text("Vêtement"),
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ]),
      body: SingleChildScrollView(
          child: Column(
              children: [
                Text(item.taille),
                StreamBuilder<Basket> (
                  stream: _database.basketItem,
                  builder: (context, snapshot) {
                    return TextButton.icon (
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text('Ajouter au panier'),
                      onPressed: () async {
                        if(snapshot.hasData) {
                          Basket? basket =snapshot.data;
                          basket!.quantity++;
                          await _database.changeBasket(basket);
                        } else {
                          await _database.changeBasket(Basket(item.uid, item.titre, item.image, item.taille, item.prix, 1));
                        }
                      },
                    );
                  }
                ),
              ]
          ),
      ),
    );
  }

}

