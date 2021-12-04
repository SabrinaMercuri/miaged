import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miaged/models/user.dart';
import 'package:miaged/services/database.dart';


class AuthenticationService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AppUser? _userFirebase(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  Stream<AppUser?> get user {
    //va servir à récup l'user courant et écouter si l'user se co et se déco
    return _auth.authStateChanges().map(_userFirebase);
  }

  Future signInWithLoginAndPassword(String login, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: login, password: password);
      User user = result.user;

      if (DatabaseService(uid: user.uid, uidItem: '').user.length == 0) {
        await DatabaseService(uid: user.uid, uidItem: '').saveUser(
            login, password, DateTime(1930, 1, 1), '', '', '');
      }

      return _userFirebase(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future registerWithLoginAndPassword(String login, String password) async {
    try {
      UserCredential result =
      await _auth.createUserWithEmailAndPassword(email: login, password: password);
      User? user = result.user;
      if (user == null) {
        throw Exception("No user found");
        } else {
        await DatabaseService(uid : user.uid, uidItem: '').saveUser(login, password, new DateTime.now(), '', '', '');

        return _userFirebase(user);
      }
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  Future changePassword(String current, String newP) async {
    final user = await FirebaseAuth.instance.currentUser;
    final credential = EmailAuthProvider.credential(
        email: user.email, password: current);

    user.reauthenticateWithCredential(credential).then((value) {
      user.updatePassword(newP).then((value) {
        print("succes");
      }).catchError((error) {
        print("erreur");
      });
    }).catchError((error) {
      print("erreur");
    });
  }
}