import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/screens/items/item_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:provider/provider.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  /*final AuthenticationService _auth = AuthenticationService();*/
  String selectedValue = "Tous";
  @override
  Widget build(BuildContext context) {
    final items = Provider.of<Iterable<AppItemData>>(context) ?? [];

    return SingleChildScrollView(
        child: Column(
      children: [
        DropdownButton(
            value: selectedValue,
            onChanged: (String? newValue){
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems
        ),
        ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ItemTile(item: items.elementAt(index),filtre: selectedValue);
            },
            shrinkWrap: true,
            physics: ScrollPhysics()),
      ],
    ));
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Tous"),value: "Tous"),
      DropdownMenuItem(child: Text("short"),value: "short"),
      DropdownMenuItem(child: Text("pantalon"),value: "pantalon"),
      DropdownMenuItem(child: Text("haut"),value: "haut"),
    ];
    return menuItems;
  }

}


class ItemTile extends StatelessWidget {
  final AppItemData item;
  final String filtre;

  ItemTile({required this.item, required this.filtre});

  @override
  Widget build(BuildContext context) {
    if(item.categorie==filtre || filtre=="Tous") {
      return Padding(
        padding: const EdgeInsets.only(top: 1.0),
        child: Card(
          margin: EdgeInsets.only(top: 1.0, bottom: 1.0, left: 1.0, right: 1.0),
          child: ListTile(
              title: Text(item.categorie),
              subtitle: Container(
                child: Image(image: NetworkImage(item.image)),
              ),
              onTap: () {
                //pas onPressed car pas bouton mais widget
                //méthode navigator pour aller à la page détails
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ItemScreen(item: item)));
              }),
        ),
      );
    }else {
      return Text("");
    }
  }
}
