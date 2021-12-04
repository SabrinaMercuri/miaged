import 'package:flutter/material.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/screens/basket/basket_screen.dart';
import 'package:miaged/screens/home/home_screen.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';

class ItemScreen extends StatefulWidget {
  final String uid;

  const ItemScreen({Key? key, required this.item, required this.uid}) : super (key: key);
  final AppItemData item;


  @override
  _ItemScreenState createState() {

    return _ItemScreenState(item: item, uid: uid);

  }
}

class _ItemScreenState extends State {
  final AuthenticationService _auth = AuthenticationService();
  _ItemScreenState({Key? key, required this.item, required this.uid}) : super ();
  final AppItemData item;
  final String uid;

  @override
  Widget build(BuildContext context) {
    final DatabaseService _database = DatabaseService(uid: uid, uidItem: item.uid);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: const Text("Détails vêtement"),
          actions: <Widget>[
            TextButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ]),
      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10.0),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child:
                  Image.network(item.image, width: 350,
                      height: 350),
                ),

                Text(item.titre),
                Text("taille : "+item.taille),
                Text("marque : "+item.marque),
                Text("prix : "+item.prix.toString()+"€"),
                StreamBuilder<Basket> (
                  stream: _database.basketItem,
                  builder: (context, snapshot) {
                    return TextButton.icon (
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Ajouter au panier'),
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

