import 'package:flutter/material.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/common/loading.dart';
import 'package:miaged/services/authentication.dart';

class AuthentificationScreen extends StatefulWidget {
  const AuthentificationScreen({Key? key}) : super(key: key);
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

  void toggleView() {
    setState(() {
      _formKey.currentState?.reset();
      error = '';
      login.text = '';
      password.text = '';
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : //pour le chargement pour afficher un loader en attedant la requete à firebase sinon scaffold
        Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blueGrey,
              elevation: 0.0,
              title: Text(showSignIn ? 'Connexion' : 'Créer un compte'),
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  label: Text(showSignIn ? "Créer un compte" : 'Connexion',
                      style: const TextStyle(color: Colors.white)),
                  onPressed: () => toggleView(),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png'),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: login,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Login"),
                      validator: (value) => value!.isEmpty
                          ? "Veuillez entrer un login valide"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: password,
                      decoration:
                          textInputDecoration.copyWith(hintText: "Password"),
                      obscureText: true, //pour cacher le mdp
                      validator: (value) => value!.length < 6
                          ? "Veuillez entrer un password valide"
                          : null,
                    ),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      child: Text(
                        showSignIn ? "Connexion" : "Créer un compte",
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() == true) {
                          setState(() => loading = true);
                          var mdp = password.value.text;
                          var nom = login.value.text;

                          dynamic result = showSignIn
                              ? await _auth.signInWithLoginAndPassword(nom, mdp)
                              : await _auth.registerWithLoginAndPassword(nom, mdp);  //authentification firebase
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
                    const SizedBox(height: 10.0),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
