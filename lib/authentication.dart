import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/data/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nb_utils/nb_utils.dart';

import 'model/utilisateur_model.dart';

class authService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UtilisateurModel _userFromFirebase(User? user) {
    return UtilisateurModel(
      nom: '',
      id: user!.uid,
      psudo: user.displayName!,
      address: '',
      image: user.photoURL!,
      password: '',
      numeroTelephone: '',
      email: user.email!,
      prenom: '',
    );
  }

  Stream<UtilisateurModel> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signUp(String email, String pw) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pw);
      return getCU();
    } catch (e) {
      return Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.yellow);
    }
  }

  Future<UtilisateurModel?> signIn(String email, String pw) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: pw);
      User? user = result.user;
/*
      setValue('userId', user!.uid.validate());
      setValue('userDisplayName', user.displayName.validate());
      setValue('userEmail', user.email.validate());
      setValue('userPhotoUrl', user.photoURL.validate());
      setValue('userMobileNumber', user.phoneNumber.validate());
      setValue('isEmailLogin', user.emailVerified.validate());*/
      return getCU();
      // return _userFromFirebase(user!);
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.yellow);
    }
  }

  Future<UtilisateurModel?> getCU() async {
    Map<String, dynamic>? data = (await FirebaseFirestore.instance
            .collection('utilisateurs')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get())
        .data();
    if (data != null) {
      UtilisateurModel currentUser = UtilisateurModel.fromJson(data);
      currentUserInfo = currentUser;
      print(currentUserInfo.toJson());
      return currentUser;
    }
  }

  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      currentUserInfo.psudo = user!.uid;
      currentUserInfo.nom = 'Utilisateur anonyme';
      return user;
    } catch (e) {
      return Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.yellow);
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
