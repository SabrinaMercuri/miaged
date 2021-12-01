import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miaged/screens/authenticate/authentification_screen.dart';
import 'package:miaged/screens/auth_home_wrapper.dart';
import 'package:miaged/services/authentication.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthenticationService().user,
      initialData: null,
      child : MaterialApp (
        home: AuthHomeWrapper(),
        theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
      ),//themeData
    );
  } //materialApp
}
