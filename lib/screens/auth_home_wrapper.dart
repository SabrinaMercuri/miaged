import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/authenticate/authentification_screen.dart';
import 'package:provider/provider.dart';
import 'home/home_screen.dart';

class AuthHomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return AuthentificationScreen();
    } else {
      return HomeScreen();
    }
  }
}

