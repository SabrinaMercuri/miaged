import 'package:flutter/material.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/screens/basket/basket_screen.dart';
import 'package:miaged/screens/items/item_screen.dart';
import 'package:miaged/screens/profile/profile_infos.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

import '../body_wrapper.dart';
import '../items/itemList.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}


class _HomeScreenState extends State {
  final AuthenticationService _auth = AuthenticationService();
  Text title = Text("Accueil");

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Iterable<AppItemData>>.value(
      initialData: [],
      value: DatabaseService(uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2',uidItem: '').items,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: title,
          actions: <Widget>[
            TextButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ]),
      body: //ItemList(),
        BodyWrapper(selectedIndex: _selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey,
        elevation: 0.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Acheter',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Panier',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
    )
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 1:{
          title = Text('Panier');
          break;
        }
        case 2:{
          title = Text('Profile');
          break;
        }
        default:{
          title = Text('Accueil');
        }
      }
    });
  }

}




