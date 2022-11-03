import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/data.dart';
import '../data/prestations_data.dart';
import '../model/prestation_model.dart';
import '../screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    // initdata();
    getCurrentUserInfos();
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool fav = false;

    setState(() {});
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          !FirebaseAuth.instance.currentUser!.isAnonymous
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(),
                        ));
                  },
                  icon: const Icon(Icons.edit))
              : SizedBox(),
        ],
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: FutureBuilder(
          future: getCurrentUserInfos(),
          builder: (context, AsyncSnapshot snapshot) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: <Widget>[
                      Container(
                        height: 160,
                        color: Colors.indigo,
                      ),
                      Positioned(
                          bottom: -60.0,
                          child: snapshot.data != null
                              ? CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      NetworkImage(snapshot.data['image']),
                                )
                              : CircleAvatar(
                                  radius: 70,
                                  backgroundImage:
                                      AssetImage('assets/images/profile.jpg'),
                                )),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  ListTile(
                    title: Center(
                        child: snapshot.data != null
                            ? Text(
                                snapshot.data['nom'] +
                                    ' ' +
                                    snapshot.data['prenom'],
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                'Utilisateur Annonyme',
                                style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              )),
                    subtitle: Center(
                        child: snapshot.data != null
                            ? Text('@' + (snapshot.data['psudo'] ?? ''),
                                style: const TextStyle(fontFamily: 'Poppins'))
                            : Text(
                                '@' + (FirebaseAuth.instance.currentUser!.uid),
                                style: const TextStyle(fontFamily: 'Poppins'))),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 32, right: 32, bottom: 16),
                      child: snapshot.data != null
                          ? Text(
                              snapshot.data['address'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w200),
                            )
                          : Text(
                              '',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w200),
                            )),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 32,
                      right: 32,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Contact",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.phone,
                                          color: Colors.indigo,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  snapshot.data != null
                                      ? Text(
                                          snapshot.data['numeroTelephone'],
                                          style: const TextStyle(),
                                        )
                                      : Text(
                                          ' ',
                                          style: const TextStyle(),
                                        )
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 32,
                                    width: 32,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 2,
                                          offset: const Offset(0, 4),
                                        )
                                      ],
                                    ),
                                    child: const Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Icon(
                                          Icons.mail_outlined,
                                          color: Colors.indigo,
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  snapshot.data != null
                                      ? Text(
                                          snapshot.data['email'],
                                          style: const TextStyle(),
                                        )
                                      : Text(
                                          '',
                                          style: const TextStyle(),
                                        )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(
                    indent: 30,
                    endIndent: 30,
                    thickness: 1,
                    color: Color(0xffC4C4C4),
                  ),
                  Container(
                    height: 600,
                    child: FutureBuilder(
                        future: getPrestationsPerUser(
                            FirebaseAuth.instance.currentUser!.uid),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) return Text('Loading ');
                          if (snapshot.hasData) {
                            return GridView.count(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              crossAxisCount: 2,
                              mainAxisSpacing: 100,
                              crossAxisSpacing: 2,
                              children: List.generate(
                                snapshot.data.length,
                                (index) {
                                  fav = snapshot.data[index].isOn;
                                  return Column(children: [
                                    Expanded(
                                      child: Card(
                                        child: Column(
                                          children: [
                                            InkWell(
                                              onTap: (() => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        DetailPage(
                                                      prestationSelectione:
                                                          snapshot.data[index],
                                                    ),
                                                  ))),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.fromLTRB(
                                                            5, 5, 5, 0),
                                                    child: Container(
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.155,
                                                      width: MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                          10.0,
                                                        ),
                                                        image: DecorationImage(
                                                          image: NetworkImage(
                                                            snapshot.data[index]
                                                                .imagepath,
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.01),
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        SizedBox(
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.28,
                                                          child: Text(
                                                            snapshot
                                                                .data[index].titre,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: const TextStyle(
                                                                fontSize: 18),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width *
                                                                  0.144,
                                                          child: Text(
                                                            snapshot
                                                                .data[index].price,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                          ),
                                                        ),
                                                      ]),

                                                ],
                                              ),
                                            ),
                                            Switch(
                                                activeColor: Colors.indigo,
                                                value: fav,
                                                onChanged: (value) async {
                                                  setState(() {
                                                    fav = value;

                                                    print(fav.toString() +
                                                        '      ' +
                                                        snapshot
                                                            .data[index].id);
                                                  });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'Prestations')
                                                      .doc(snapshot
                                                      .data[index].id)
                                                      .update({
                                                    'isOn': fav,
                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]);
                                },
                              ),
                            );
                          } else {
                            return const Text('NO DATA');
                          }
                        }),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

Future getCurrentUserInfos() async {
  if (!FirebaseAuth.instance.currentUser!.isAnonymous) {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('utilisateurs')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();

    return data;
  }
  return null;
}

Future<List<PrestationsModel>> getPrestationsPerUser(String User) async {
  List<PrestationsModel> prestations = [];
  QuerySnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore.instance.collection("Prestations").get();
  data.docs.forEach((element) {
    if (element.data()['owner'] == FirebaseAuth.instance.currentUser!.uid) {
      late List<String> images = [];
      element.data()['images'].forEach((element) {
        images.add(element);
      });
      prestations.add(PrestationsModel(
        isOn: element.data()['isOn'],
        addresse: '',
        description: element.data()['description'],
        imageList: images,
        imagepath: element.data()['images'][0].toString(),
        catigory: element.data()['catigory'],
        owner: element.data()['owner'],
        titre: element.data()['titre'],
        price: element.data()['prix'],
        id: element.id,
        geoAddress: LatLng(0, 0),
      ));
    }
  });

  return prestations;
}
