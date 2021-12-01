import 'package:flutter/material.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/authenticate/authentification_screen.dart';
import 'package:miaged/screens/profile/profile_infos.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';
import 'basket/basket_screen.dart';
import 'home/home_screen.dart';
import 'items/itemList.dart';

class BodyWrapper extends StatelessWidget {
  const BodyWrapper({Key? key, required this.selectedIndex}) : super (key: key);
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    switch(selectedIndex) {
      case 1:
        {
          return StreamProvider<Iterable<Basket>>.value(
            value: DatabaseService(uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2', uidItem: '').basket,
            initialData: [],
            child: Scaffold(
                body: BasketScreen()
            ),
          );
        }
      case 2:
        {
          return ProfilInfo();
        }
      default:
        {
          return StreamProvider<Iterable<AppItemData>>.value(
            value: DatabaseService(uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2',
                uidItem: '').items,
            initialData: [],
            child: Scaffold(
                body: ItemList()
            ),
          );
        }
    }
  }
}

