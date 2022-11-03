import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../constants/firestore_constants.dart';

class UtilisateurModel {
  String? id;
  String? image;
  String? nom;
  String? prenom;
  String? psudo;
  String? address;
  String? email;
  String? numeroTelephone;
  String? password;

  UtilisateurModel({
    required this.email,
    required this.password,
    required this.numeroTelephone,
    required this.id,
    required this.image,
    required this.nom,
    required this.prenom,
    required this.psudo,
    required this.address,
  });
  Map<String, dynamic> toJson() => {
    FirestoreConstants.psudo: psudo,
    FirestoreConstants.photoUrl: image,
    FirestoreConstants.phoneNumber: numeroTelephone,
    FirestoreConstants.name: nom,
    FirestoreConstants.pnom: prenom,
    FirestoreConstants.address: address,
    FirestoreConstants.password: password,
    FirestoreConstants.email: email,
    FirestoreConstants.id: id,
  };
  UtilisateurModel.fromJson(Map<String, dynamic> data) {
    email = data['email'];
    password = data['password'];
    numeroTelephone = data['numeroTelephone'];
    id = data['id'];
    image = data['image'];
    nom = data['nom'];
    prenom = data['prenom'];
    psudo = data['psudo'];
    address = data['address'];
  }
  factory UtilisateurModel.fromDocument(DocumentSnapshot snapshot) {
    String photoUrl = "";
    String name = "";
    String phoneNumber = "";
    String psuedo = "";
    String mail = '';
    String fname = '';
    String adres = '';
    String pw = '';
    String uid = '';

    try {
      uid = snapshot.get(FirestoreConstants.id);
      photoUrl = snapshot.get(FirestoreConstants.photoUrl);
      name = snapshot.get(FirestoreConstants.name);
      mail = snapshot.get(FirestoreConstants.email);
      psuedo = snapshot.get(FirestoreConstants.psudo);
      phoneNumber = snapshot.get(FirestoreConstants.phoneNumber);
      pw = snapshot.get(FirestoreConstants.password);
      fname = snapshot.get(FirestoreConstants.pnom);
      adres = snapshot.get(FirestoreConstants.address);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return UtilisateurModel(
      id: uid,
      image: photoUrl,
      nom: name,
      numeroTelephone: phoneNumber,
      psudo: psuedo,
      email: mail,
      prenom: fname,
      address: adres,
      password: pw,
    );
  }

  UtilisateurModel copyWith({
    String? photoUrl,
    String? name,
    String? phoneNumber,
    String? psuedo,
    String? mail,
    String? fname,
    String? adres,
    String? pw,
    String? uid,
  }) =>
      UtilisateurModel(
          id: uid ?? this.id,
          nom: name??this.nom,
          prenom: fname??this.prenom,
          password: pw??this.password,
          address:  adres??this.address,
          image: photoUrl ?? this.image,
          psudo: psuedo ?? this.psudo,
          numeroTelephone: phoneNumber ?? this.numeroTelephone,
          email: mail ?? this.email);
}
