import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/items/itemList.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

class ProfilInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUserData?>.value(
        initialData: null,
        value: DatabaseService(uid: 'wYoxYBW3niU1XzEI0GxLVa4lIeb2', uidItem: '').user,
        child: Scaffold(
          body: ProfileScreen()
        ),
    );
  }

}