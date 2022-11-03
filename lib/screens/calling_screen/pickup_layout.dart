//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/data/data.dart';
import 'package:el_project/screens/calling_screen/pick_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../Services/user_provider.dart';
import '../../model/call.dart';
import '../../model/call_methods.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods = CallMethods();

  PickupLayout({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    //final UserProvider userProvider = Provider.of<UserProvider>(context);
    print(FirebaseAuth.instance.currentUser!.uid);
    // ignore: unnecessary_null_comparison
    return StreamBuilder<DocumentSnapshot>(
      stream:
          callMethods.callStream(uid: FirebaseAuth.instance.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          print('3afssa');
          Call call =
              Call.fromMap(snapshot.data!.data() as Map<dynamic, dynamic>);

          if (!call.hasDialled!) {
            return PickupScreen(
              call: call,
              currentuseruid: FirebaseAuth.instance.currentUser!.uid,
            );
          }
        }
        return scaffold;
      },
    );
  }
}
