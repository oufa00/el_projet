import 'package:el_project/screens/home_screen.dart';
import 'package:el_project/screens/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/utilisateur_model.dart';

class wrapper extends StatelessWidget {
  const wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    final user = Provider.of<UtilisateurModel>(context);
    print(auth.currentUser==null);
    if(auth.currentUser!=null){
      return HomeScreen();
    }else{
      return WelcomeScreen();
    }

  }
}
