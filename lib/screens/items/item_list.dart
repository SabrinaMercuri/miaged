import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/screens/items/item_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:provider/provider.dart';

class ItemList extends StatefulWidget {
  final String uid;
  const ItemList({Key? key, required this.uid}) : super (key: key);


  @override
  _ItemListState createState() => _ItemListState(uid);
}

class _ItemListState extends State<ItemList> {
  /*final AuthenticationService _auth = AuthenticationService();*/
  final String uid;

  _ItemListState(this.uid);
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Iterable<AppItemData>>(context);

    return DefaultTabController(
       length: 3,
       child : Scaffold(
      appBar: new TabBar(
        labelColor: Colors.blueGrey,
        tabs: [
          Tab(text: "Tous"),
          Tab(text: "Femme"),
          Tab(text: "Homme"),
        ],
      ),
      body:  TabBarView (
        children: [
          SingleChildScrollView (
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemTile(item: items.elementAt(index),filtre: "Tous", uid: uid);
                },
                shrinkWrap: true,
                physics: const ScrollPhysics()
            ),
          ),
          SingleChildScrollView (
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemTile(item: items.elementAt(index),filtre: "Femme", uid: uid);
                },
                shrinkWrap: true,
                physics: const ScrollPhysics()
            ),
          ),
          SingleChildScrollView (
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ItemTile(item: items.elementAt(index),filtre: "Homme", uid: uid);
                },
                shrinkWrap: true,
                physics: const ScrollPhysics()
            ),
          ),
        ],

       ),
       ),
    );

  }

}


class ItemTile extends StatelessWidget {
  final AppItemData item;
  final String filtre;

  final String uid;
  const ItemTile({Key? key, required this.item, required this.filtre, required this.uid}) : super (key: key);


  @override
  Widget build(BuildContext context) {
    if(item.categorie==filtre || filtre=="Tous") {
      return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Card(
          //margin: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 1.0, right: 1.0),
          child: Padding (
            padding: EdgeInsets.only(top: 10),
            //padding: const EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
            child: Column (
              children: [
                ListTile(
                    title: Text(item.titre),
                    leading: Image.network(item.image),
                    subtitle: Text(item.taille+" - "+item.prix.toString()+"€"),
                    onTap: () {
                      //pas onPressed car pas bouton mais widget
                      //méthode navigator pour aller à la page détails
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ItemScreen(item: item, uid: uid)));
                    }),
              ],
            ),

        ),
        ),
      );
    }else {
      return const Padding(
        padding: const EdgeInsets.only(top: 0),
      );
    }
  }
}
