import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:el_project/model/call.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:el_project/messenger/providers/chat_provider.dart';
import 'package:el_project/messenger/providers/home_provider.dart';
import 'package:el_project/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:async';
import 'dart:io';
import 'package:bringtoforeground/bringtoforeground.dart';

import 'package:callkeep/callkeep.dart';
import 'package:uuid/uuid.dart';
import 'authentication.dart';

import 'model/utilisateur_model.dart';

Future myFunction() async {
  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  final docRef = FirebaseFirestore.instance
      .collection('call')
      .doc(FirebaseAuth.instance.currentUser!.uid);
  docRef.snapshots().listen(
    (event) {
      final source = (event.metadata.hasPendingWrites) ? "Local" : "Server";
      if (event.data() != null) {
        Timer.periodic(Duration(seconds: 3), (t) {
          Bringtoforeground.bringAppToForeground();
        });
        Call call = Call.fromMap(event.data() as Map<dynamic, dynamic>);
      }
      print("$source data: ${event.data()}");
    },
    onError: (error) => print("Listen failed: $error"),
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  myFunction();

  // runApp(const MyApp()
  //     // DevicePreview(
  //     //   enabled: !kReleaseMode,
  //     //   builder: (context) => const MyApp(), // Wrap your app
  //     // ),
  //     );

  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 823),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => StreamProvider<UtilisateurModel>.value(
        initialData: UtilisateurModel(
            nom: null.toString(),
            id: null.toString(),
            psudo: null.toString(),
            address: null.toString(),
            image: null.toString(),
            password: null.toString(),
            numeroTelephone: null.toString(),
            prenom: null.toString(),
            email: null.toString()),
        value: authService().user,
        child: MultiProvider(
          providers: [
            Provider<HomeProvider>(
                create: (_) =>
                    HomeProvider(firebaseFirestore: firebaseFirestore)),
            Provider<ChatProvider>(
              create: (_) => ChatProvider(
                  prefs: prefs,
                  firebaseStorage: firebaseStorage,
                  firebaseFirestore: firebaseFirestore),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'EL Project',
            theme: AppTheme.appTheme,
            home: const wrapper(),
          ),
        ),
      ),
    );
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('backgroundMessage: message => ${message.toString()}');
  if (message.data['type'] == 'call') {
    Map<String, dynamic> bodyMap = jsonDecode(message.data['body']);
  }
}
