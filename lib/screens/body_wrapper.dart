import 'package:flutter/material.dart';
import 'package:miaged/common/loading.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/profile/profile_infos.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';
import 'basket/basket_screen.dart';
import 'items/item_list.dart';

class BodyWrapper extends StatelessWidget {
  const BodyWrapper({Key? key, required this.selectedIndex}) : super (key: key);
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final userApp = Provider.of<AppUser?>(context);
    if (userApp ==null) {
      return const Loading();
    }
    else {
      switch(selectedIndex) {
        case 1:
          {
              return StreamProvider<Iterable<Basket>>.value(
                value: DatabaseService(uid: userApp.uid, uidItem: '').basket,
                initialData: const [],
                child: Scaffold(
                    body: BasketScreen(uid: userApp.uid)
                ),
              );

          }
        case 2:
          {
              return ProfilInfo(uid: userApp.uid);
          }
        default:
          {
              return StreamProvider<Iterable<AppItemData>>.value(
                value: DatabaseService(uid: userApp.uid, uidItem: '').items,
                initialData: const [],
                child: Scaffold(
                    body: ItemList(uid :userApp.uid)
                ),
              );
          }
      }
    }
  }
}

