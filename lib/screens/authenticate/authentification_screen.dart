import 'package:flutter/material.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/common/loading.dart';
import 'package:miaged/services/authentication.dart';

class AuthentificationScreen extends StatefulWidget {
  @override
  _AuthentificationScreenState createState() => _AuthentificationScreenState();
}

class _AuthentificationScreenState extends State<AuthentificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();
  String error = '';
  bool loading = false;
  final login = TextEditingController();
  final password = TextEditingController();
  bool showSignIn = true;

  @override
  void dispose() {
    login.dispose();
    password.dispose();
    super.dispose(); //
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : //pour le chargement pour afficher un loader en attedant la requete à firebase sinon scaffold
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              elevation: 0.0,
              title: Text('Connexion'),
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: login,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Login"),
                      validator: (value) => value!.isEmpty
                          ? "Veuillez entrer un login valide"
                          : null,
                    ),
                    SizedBox(height: 10.0),
                    TextFormField(
                      controller: password,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Password"),
                      obscureText: true, //pour cacher le mdp
                      validator: (value) => value!.length < 6
                          ? "Veuillez entrer un password valide"
                          : null,
                    ),
                    SizedBox(height: 10.0),
                    ElevatedButton(
                      child: Text(
                        "Se connecter",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => loading = true);
                          var mdp = password.value.text;
                          var nom = login.value.text;

                          dynamic result = await _auth.signInWithLoginAndPassword(nom, mdp);  //authentification firebase
                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = "Veuillez entrer un login valide";
                              print(error);
                            });
                          }
                        }
                      },
                    ),
                    /*SizedBox(height: 10.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 15.0),
                    ),*/
                  ],
                ),
              ),
            ),
          );
  }
}
