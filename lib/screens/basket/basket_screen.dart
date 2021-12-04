import 'package:flutter/material.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

class BasketScreen extends StatefulWidget {
  final String uid;
  const BasketScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _BasketScreenState createState() {
    return _BasketScreenState(uid);
  }
}

class _BasketScreenState extends State {
  //
  final String uid;

  _BasketScreenState(this.uid);

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Iterable<Basket>>(context);
    return SingleChildScrollView(
        child: Column(
      children: [
        ListView.builder(
            itemCount: basket.length,
            itemBuilder: (context, index) {
              return BasketTile(
                  basket: basket.elementAt(index),
                  uid: uid); //tous les items (appelés en bas)
            },
            shrinkWrap: true,
            physics: const ScrollPhysics()),
        Padding(
            //padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            padding: const EdgeInsets.only(top: 20.0),
            child: Text('Total : ' + prixTotal(basket),
                style: const TextStyle(fontSize: 20))),
      ],
    ));
  }

  String prixTotal(Iterable<Basket> basket) {
    //string car affiché dans un text
    double total = 0.0;
    for (var item in basket) {
      total += item.prix;
    }
    return double.parse(total.toStringAsFixed(2)).toString();
  }
}

class BasketTile extends StatelessWidget {
  const BasketTile({Key? key, required this.basket, required this.uid})
      : super(key: key);
  //chaque items du panier
  final Basket basket;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0.5),
      child: Card(
        margin: const EdgeInsets.only(
            top: 12.0, bottom: 0.5, left: 20.0, right: 20.0),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Image.network(basket.image, width: 90,
              height: 90),
          ),
          Expanded(
              child: Column(
            children: [
              Text(basket.titre+" - "+basket.taille),
              const SizedBox(height: 14.0),
              Text("prix : "+ basket.prix.toString()+"€"),    /// +basket.taille),
              const SizedBox(height: 4.0),
            ],
          )),
          TextButton.icon(
            icon: const Icon(Icons.delete),
            label: const Text(''),
            onPressed: () async {
              await DatabaseService(uid: uid, uidItem: basket.uid)
                    .removeItem();
            },
          )
        ]),
      ),
    );
  }
}
