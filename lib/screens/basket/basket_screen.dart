import 'package:flutter/material.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/screens/home/home_screen.dart';
import 'package:miaged/screens/items/item_screen.dart';
import 'package:miaged/screens/profile/profile_infos.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

class BasketScreen extends StatefulWidget {
  @override
  _BasketScreenState createState() {
    return _BasketScreenState();
  }
}

class _BasketScreenState extends State {
  //
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final basket = Provider.of<Iterable<Basket>>(context) ?? [];
    return SingleChildScrollView(
        child: Column(
      children: [
        ListView.builder(
            itemCount: basket.length,
            itemBuilder: (context, index) {
              return BasketTile(
                  basket.elementAt(index)); //tous les items (appelés en bas)
            },
            shrinkWrap: true,
            physics: ScrollPhysics()
            ),
        Text('Total:' + prixTotal(basket)),
      ],
    ));
  }

  String prixTotal(Iterable<Basket> basket) {
    //string car affiché dans un text
    double total = 0.0;
    basket.forEach((item) {
      total += item.prix * item.quantity;
    });
    return double.parse(total.toStringAsFixed(2)).toString();
  }
}

class BasketTile extends StatelessWidget {
  //chaque items du panier
  final Basket basket;

  BasketTile(this.basket);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin:
            EdgeInsets.only(top: 12.0, bottom: 6.0, left: 20.0, right: 20.0),
        child: Column(children: [
          Text('Vêtement : ${basket.titre}'),
          Text('Quantité : ${basket.quantity}'),
          Image(image: NetworkImage(basket.image, scale: 0.2)),
          TextButton.icon(
            icon: Icon(Icons.delete),
            label: Text(''),
            onPressed: () async {
              basket.quantity--;
              if (basket.quantity == 0) {
                await DatabaseService(
                        uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2',
                        uidItem: basket.uid)
                    .removeItem();
              } else {
                await DatabaseService(
                        uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2',
                        uidItem: basket.uid)
                    .changeBasket(basket);
              }
            },
          )
        ]),
      ),
    );
  }
}
