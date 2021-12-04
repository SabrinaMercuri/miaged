

class AppItemData {
  final String uid;
  final String image;
  final String titre;
  final String taille;
  final num prix;
  final String marque;
  final String categorie;
  bool favoris;

  AppItemData({
    required this.uid,
    required this.image,
    required this.titre,
    required this.taille,
    required this.prix,
    required this.marque,
    required this.categorie,
    required this.favoris,
  });
}