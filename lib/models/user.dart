import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppUser {
  final String uid;

  AppUser({required this.uid});
}

class AppUserData {
  final String uid;
  final String login;
  final String password;
  DateTime anniversaire;
  final String adresse;
  final String codePostal;
  final String ville;

  AppUserData({
    required this.uid,
    required this.login,
    required this.password,
    required this.anniversaire,
    required this.adresse,
    required this.codePostal,
    required this.ville,
  });
}
