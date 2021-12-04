import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/authentication.dart';
import 'package:provider/provider.dart';
import '../body_wrapper.dart';



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
                icon: const Icon(Icons.person, color: Colors.white),
                label: const Text('logout', style: TextStyle(color: Colors.white)),
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




