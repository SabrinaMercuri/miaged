import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/common/loading.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State {
    @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUserData?>(context);

    if (user==null) {
      return const Loading();
    }
    else {
      final AuthenticationService _auth = AuthenticationService();
      final DatabaseService _data = DatabaseService(uid: user.uid, uidItem: '');
      final passwordController = TextEditingController(text: user.password);
      final adresseController = TextEditingController(text: user.adresse);
      final codePostalController = TextEditingController(text: user.codePostal);
      final villeController = TextEditingController(text: user.ville);
      initializeDateFormatting();
      return SingleChildScrollView (
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          child: Column(
            children: <Widget> [
              const SizedBox(height: 20.0),
              const Text(
                'Modifier votre profil',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                initialValue: user.login,
                readOnly: true,
                decoration:
                textInputDecoration.copyWith(hintText: "Login", labelText: 'Login'),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: passwordController,
                decoration:
                textInputDecoration.copyWith(hintText: "Password", labelText: 'Password'),
                obscureText: true, //pour cacher le mdp
                validator: (value) => value!.length < 6
                    ? "Veuillez entrer un password valide"
                    : null,
              ),
              SizedBox(
                child: Row (
                  children: [
                    const Text(" Anniversaire :   "),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey[50],

                      ),
                      onPressed: (){
                        DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1900, 1, 1),
                            maxTime: DateTime(2021, 12, 12),
                            onChanged: (date){
                            },
                            onConfirm: (date){
                              setState(() {
                                user.anniversaire = date;
                              });
                            },
                            currentTime: user.anniversaire,
                            locale: LocaleType.fr
                        );
                      },
                      child: Text(
                        DateFormat.yMd('fr').format(user.anniversaire),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              ///Text("Anniversaire :"),
              /*TextButton(
              onPressed: (){
                DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime(2021, 12, 12),
                    onChanged: (date){
                    },
                    onConfirm: (date){
                      setState(() {
                        user.anniversaire = date;
                      });
                    },
                    currentTime: user.anniversaire,
                    locale: LocaleType.fr
                );
              },
              child: Text(
                DateFormat.yMd('fr').format(user.anniversaire),
                style: const TextStyle(color: Colors.black),
              ),
            ),*/
              TextFormField(
                controller: adresseController,
                decoration:
                textInputDecoration.copyWith(hintText: "Adresse", labelText: 'Adresse'),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: codePostalController,
                decoration:
                textInputDecoration.copyWith(hintText: "Code Postale", labelText: 'Code Postale'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                controller: villeController,
                decoration:
                textInputDecoration.copyWith(hintText: "Ville", labelText: 'Ville'),
              ),
              const SizedBox(height: 10.0),
              ElevatedButton(
                child: const Text(
                  "Sauvegarder",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  var password = passwordController.value.text;
                  var adresse = adresseController.value.text;
                  var codePostal = codePostalController.value.text;
                  var ville = villeController.value.text;

                  await _data.saveUser(user.login, password, user.anniversaire, adresse, codePostal, ville);  //sauvegarde firebase
                  await _auth.changePassword(user.password, password);
                },
              ),
            ],
          )
      );
    }
  }


}

