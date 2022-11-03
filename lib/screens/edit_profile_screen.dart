import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../model/model.dart';
import 'package:flutter/material.dart';

import '../data/utilisateur_data.dart';
import '../widgets/image_de_edit_profile.dart';
import 'nouvelle_prestation_screen.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? _pfpImage;
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        foregroundColor: Colors.indigo,
        title: const Text(
          'Modifier mon profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      title: const Text('Select image source:'),
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt_outlined),
                          title: const Text('Camera'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: const Icon(Icons.image),
                          title: const Text('Gallery'),
                          onTap: () async {
                            pickImage(ImageSource.gallery);
                            String? pfpUrl =
                                await uploadpImage(XFile(_pfpImage!.path));
                            await FirebaseFirestore.instance
                                .collection('utilisateurs')
                                .doc(FirebaseAuth.instance.currentUser?.uid)
                                .update({
                              'image': pfpUrl,
                            });
                            currentUserInfo.image = _pfpImage.toString();
                            print('hello' + currentUserInfo.image!);
                          },
                        )
                      ],
                    ),
                  );
                },
                child: _pfpImage != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(_pfpImage.toString()),
                        radius: 100,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            AssetImage(currentUserInfo.image.toString()),
                        radius: 100,
                      )),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                children: [
                  buildcurrentUserInfoInfoDisplay(
                      currentUserInfo.nom ?? '',
                      'Name',
                      Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Nom'),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _username,
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('utilisateurs')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .set({
                                    'nom': _username,
                                  });
                                  Navigator.of(context).pop();
                                },
                                child: Text('Valider'))
                          ],
                        ),
                      )),
                  buildcurrentUserInfoInfoDisplay(
                      currentUserInfo.numeroTelephone ?? '',
                      'Phone',
                      Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Telephone'),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextFormField(
                                controller: _phoneNumber,
                              ),
                            ),
                            TextButton(

                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('utilisateurs')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .set({
                                    'numeroTelephone': _phoneNumber,
                                  });
                                },
                                child: Text('Valider'))
                          ],
                        ),
                      )),
                  buildcurrentUserInfoInfoDisplay(
                      currentUserInfo.email ?? '',
                      'Email',
                      Scaffold(
                        appBar: AppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        body: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Email'),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                style: Theme.of(context).textTheme.bodyText2,
                                controller: _email,
                                decoration: const InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffFB6161),
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color(0xffFB6161),
                                      width: 2,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(16)),
                                  ),
                                ),
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('utilisateurs')
                                      .doc(FirebaseAuth
                                          .instance.currentUser?.uid)
                                      .set({
                                    'email': _email,
                                  });
                                },
                                child: Text('Valider'))
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildcurrentUserInfoInfoDisplay(
          String getValue, String title, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                height: 1,
              ),
              Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ))),
                  child: Row(children: [
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              navigateSecondPage(editPage);
                            },
                            child: Text(
                              getValue,
                              style: TextStyle(fontSize: 16, height: 1.4),
                            ))),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                      size: 40.0,
                    )
                  ]))
            ],
          ));

  // Widget builds the About Me Section

  // Refrshes the Page after updating currentUserInfo info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }

  Future pickImage(ImageSource source) async {
    try {
      var selectedImage = await ImagePicker().pickImage(source: source);
      if (selectedImage == null) {
        return;
      }
      final imageTemp = File(selectedImage.path);
      setState(() {
        this._pfpImage = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Filed to pick image: $e');
    }
  }
}

Future<String?> uploadpImage(XFile image) async {
  try {
    String path =
        "profilesImages/${FirebaseAuth.instance.currentUser!.uid}/${image.name}";
    File file = File(image.path);

    var ref = FirebaseStorage.instance.ref().child(path);
    TaskSnapshot ss = (await ref.putFile(file));

    // var s = await uploadTask!.whenComplete(() => null);
    String url = await ss.ref.getDownloadURL();
    print(url);
    return url;
  } catch (e) {
    print(e);
  }
}
