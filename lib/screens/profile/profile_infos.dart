import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/profile/profile_screen.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';

class ProfilInfo extends StatelessWidget {
  final String uid;
  const ProfilInfo({Key? key, required this.uid}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUserData?>.value(
        initialData: null,
        value: DatabaseService(uid: uid, uidItem: '').user,
        child: const Scaffold(
          body: ProfileScreen()
        ),
    );
  }

}