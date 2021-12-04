import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/models/basket.dart';
import 'package:miaged/models/items.dart';
import 'package:miaged/models/user.dart';

class DatabaseService {
  final String uid;
  final String uidItem;
  DatabaseService({required this.uidItem, required this.uid});


  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference vetementsCollection =
      FirebaseFirestore.instance.collection("items");
  final CollectionReference basketCollection =
      FirebaseFirestore.instance.collection("basket");

  Future<void> saveUser(String login, String password, DateTime anniversaire,
      String adresse, String codePostal, String ville) async {
    Timestamp anniv = Timestamp.fromDate(anniversaire);
    return await userCollection.doc(uid).set({
      'login': login,
      'password': password,
      'anniversaire': anniv,
      'adresse': adresse,
      'codePostal': codePostal,
      'ville': ville,
    });
  }

  Future<void> changeBasket(Basket basket) async {   //ajouter un item au panier
      return await basketCollection.doc(uid).collection('basket de :' +uid).doc(uidItem).set({
        'titre': basket.titre,
        'image': basket.image,
        'taille':basket.taille,
        'prix': basket.prix,
        'quantity': basket.quantity}); //récupérer l'item qu'on va ajouter au panier
  }

  Future<void> removeItem() async {   //ajouter un item au panier
    basketCollection.doc(uid).collection('basket de :' +uid).doc(uidItem).delete();
  }

  Future<void> favoriteItem(AppItemData fav) async {
    return await vetementsCollection.doc(uidItem).set({
      'titre': fav.titre,
      'image': fav.image,
      'taille': fav.taille,
      'prix': fav.prix,
      'marque': fav.marque,
      'categorie': fav.categorie,
      'favoris': fav.favoris,
    });
  }

  AppUserData _userFromSnapshot(DocumentSnapshot snapshot) {
    DateTime anniversaire = snapshot.data()['anniversaire'].toDate();
    return AppUserData(
      uid: uid,
      login: snapshot.data()['login'],
      password: snapshot.data()['password'],
      anniversaire: anniversaire,
      adresse: snapshot.data()['adresse'],
      codePostal: snapshot.data()['codePostal'],
      ville: snapshot.data()['ville'],
    );
  }

  Stream<AppUserData> get user {
    return userCollection.doc(uid).snapshots().map(_userFromSnapshot);
  }

  AppItemData _itemFromSnapshot(DocumentSnapshot snapshot) {
    return AppItemData(
      uid: snapshot.id,
      image: snapshot.data()['image'],
      titre: snapshot.data()['titre'],
      taille: snapshot.data()['taille'],
      prix: snapshot.data()['prix'],
      marque: snapshot.data()['marque'],
      categorie: snapshot.data()['categorie'],
      favoris: snapshot.data()['favoris'],
    );
  }

  Iterable<AppItemData> _itemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return _itemFromSnapshot(doc);
    });
  }

  Stream<Iterable<AppItemData>> get items {
    return vetementsCollection.snapshots().map(_itemListFromSnapshot);
  }

  Basket _basketFromSnapshot(DocumentSnapshot snapshot){ //ajouter un item au panier
    return Basket(snapshot.id,
        snapshot.data()['titre'],
        snapshot.data()['image'],
        snapshot.data()['taille'],
        snapshot.data()['prix'],
        snapshot.data()['quantity'],
    );
  }

  Iterable<Basket> _basketListFromSnapshot(QuerySnapshot snapshot) { //récupérer tous les items du panier
    return snapshot.docs.map((doc){
      return _basketFromSnapshot(doc);
    });
  }

  Stream<Basket> get basketItem{ //ajouter un item au panier
    return basketCollection.doc(uid).collection('basket de :' +uid).doc(uidItem).snapshots().map(_basketFromSnapshot);
  }

  Stream<Iterable<Basket>> get basket { //récupérer tous les items du panier
    return basketCollection.doc(uid).collection('basket de :' +uid).snapshots().map(_basketListFromSnapshot);
  }

}
