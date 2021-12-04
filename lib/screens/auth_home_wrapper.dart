import 'package:flutter/material.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/screens/authenticate/authentification_screen.dart';
import 'package:provider/provider.dart';
import 'home/home_screen.dart';

class AuthHomeWrapper extends StatelessWidget {
  const AuthHomeWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    if (user == null) {
      return const AuthentificationScreen();
    } else {
      return const HomeScreen();
    }
  }
}

