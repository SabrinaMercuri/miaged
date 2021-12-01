import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaged/common/constants.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/authentication.dart';
import 'package:miaged/services/database.dart';
import 'package:provider/provider.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State {

    @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUserData?>(context);
    final AuthenticationService _auth = AuthenticationService();
    final DatabaseService _data = DatabaseService(uid: user!.uid, uidItem: '');
    final passwordController = TextEditingController(text: user!.password);
    final adresseController = TextEditingController(text: user!.adresse);
    final codePostalController = TextEditingController(text: user!.codePostal);
    final villeController = TextEditingController(text: user!.ville);

    initializeDateFormatting();
    return SingleChildScrollView (
        child: Column(
          children: <Widget> [
            TextFormField(
              initialValue: user!.login,
              readOnly: true,
              decoration:
              textInputDecoration.copyWith(hintText: "Login", labelText: 'Login'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: passwordController,
              decoration:
              textInputDecoration.copyWith(hintText: "Password", labelText: 'Password'),
              obscureText: true, //pour cacher le mdp
              validator: (value) => value!.length < 6
                  ? "Veuillez entrer un password valide"
                  : null,
            ),
            SizedBox(height: 10.0),
            TextButton(
              onPressed: (){
                DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(1900, 1, 1),
                    maxTime: DateTime(2021, 12, 12),
                    onChanged: (date){
                      print('change $date');
                    },
                    onConfirm: (date){
                      print('confirm $date');
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
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextFormField(
              controller: adresseController,
              decoration:
              textInputDecoration.copyWith(hintText: "Adresse", labelText: 'Adresse'),
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: codePostalController,
              decoration:
              textInputDecoration.copyWith(hintText: "Code Postale", labelText: 'Code Postale'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10.0),
            TextFormField(
              controller: villeController,
              decoration:
              textInputDecoration.copyWith(hintText: "Ville", labelText: 'Ville'),
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              child: Text(
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

