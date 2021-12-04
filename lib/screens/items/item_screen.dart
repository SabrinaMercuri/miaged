import 'package:flutter/material.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';

class ItemScreen extends StatefulWidget {
  final String uid;

  const ItemScreen({Key? key, required this.item, required this.uid}) : super (key: key);
  final AppItemData item;


  @override
  _ItemScreenState createState() {

    return _ItemScreenState(item, uid);

  }
}

class _ItemScreenState extends State {
  final AuthenticationService _auth = AuthenticationService();
  _ItemScreenState(this.item, this.uid) : super ();
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
                icon: const Icon(Icons.person, color: Colors.white,),
                label: const Text('logout', style: TextStyle(color: Colors.white)),
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
                  padding: const EdgeInsets.only(top: 10),
                  child:
                  Image.network(item.image, width: 350,
                      height: 350),
                ),
                const SizedBox(height: 20.0),
                Text(item.titre, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(height: 15.0),
                Text("taille : "+item.taille),
                const SizedBox(height: 10.0),
                Text("marque : "+item.marque),
                const SizedBox(height: 10.0),
                Text("prix : "+item.prix.toString()+"€"),
                const SizedBox(height: 20.0),
                StreamBuilder<Basket> (
                  stream: _database.basketItem,
                  builder: (context, snapshot) {
                    return TextButton.icon (
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text('Ajouter au panier'),
                      onPressed: () async {
                        if(snapshot.hasData) {
                          showDialog(context: context, builder: (context) {
                            return const AlertDialog(
                              title: Text('Attention !'),
                              content: Text('Vous avez déjà ajouté cet article dans votre panier'),
                            );
                          }
                          );
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

