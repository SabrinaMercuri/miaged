import 'package:flutter/material.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/basket/basket_screen.dart';
import 'package:miaged/screens/items/item_screen.dart';
import 'package:miaged/screens/profile/profile_infos.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

import '../body_wrapper.dart';
import '../items/item_list.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}


class _HomeScreenState extends State {
  final AuthenticationService _auth = AuthenticationService();
  Text title = const Text("Boutique");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0.0,
          title: title,
          actions: <Widget>[
            TextButton.icon(
                icon: const Icon(Icons.person),
                label: const Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                }),
          ],
        ),
      body: //ItemList(),
        StreamProvider<AppUser?>.value(   ///transmission au body wrapper du user actuel
          value: AuthenticationService().user,
          initialData: null,
          child: BodyWrapper(selectedIndex: _selectedIndex),
        ),
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
        fixedColor: Colors.white,
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch(index){
        case 1:{
          title = const Text('Panier');
          break;
        }
        case 2:{
          title = const Text('Profil');
          break;
        }
        default:{
          title = const Text('Boutique');
        }
      }
    });
  }

}




