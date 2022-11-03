import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/constants/constants.dart';
import 'package:el_project/data/data.dart';
import 'package:el_project/messenger/dm_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/colors.dart';
import '../constants/text.dart';
import '../model/prestation_model.dart';
import 'package:flutter/material.dart';

import '../widgets/image.dart';
import 'google_maps.dart';

class DetailPage extends StatefulWidget {
  PrestationsModel prestationSelectione;
  DetailPage({Key? key, required this.prestationSelectione}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Future getOwner() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('utilisateurs')
        .doc(widget.prestationSelectione.owner)
        .get();
    if (data.exists)
      return data;
    else
      return null;
  }

  Future getCurrentPrestation() async {
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore
        .instance
        .collection('Prestations')
        .doc(widget.prestationSelectione.id)
        .get();
    if (data.exists)
      return data;
    else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    print(widget.prestationSelectione.geoAddress);
    return Scaffold(
        body: FutureBuilder(
            future: getCurrentPrestation(),
            builder: (context, AsyncSnapshot snapshot) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 260,
                      child: Stack(
                        children: <Widget>[
                          Expanded(
                            child: widget.prestationSelectione.imagepath!= null ? InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ImageShow(
                                        PrestationSelectione:
                                            widget.prestationSelectione),
                                  )),
                              child: Image(
                                fit: BoxFit.fitWidth,
                                image: NetworkImage(
                                    widget.prestationSelectione.imagepath),
                              ),
                            ) : SizedBox(height: 20,),
                          ),
                          Positioned(
                            top: 30,
                            left: 30,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 6.0),
                                height: 32,
                                width: 32,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0.0, 2.0), //(x,y)
                                      blurRadius: 2.0,
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(2.0),
                                  child: ImageIcon(
                                    AssetImage("assets/images/backicon2.png"),
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                      snapshot.data['titre'],
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Text(
                                  widget.prestationSelectione.price,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ]),
                          const SizedBox(
                            height: 8,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Text("Description",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 18)),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            snapshot.data['description'],
                            style: const TextStyle(fontWeight: FontWeight.w300),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            const Text("Catigorie: ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 18)),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              snapshot.data['catigory'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                              textAlign: TextAlign.start,
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0, bottom: 10.0),
                              child: FutureBuilder(
                                  future: getOwner(),
                                  builder: (context, AsyncSnapshot snapshot) {
                                    return Row(
                                      children: [
                                        Container(
                                          height: 48,
                                          width: 48,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child: snapshot.data != null
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      snapshot.data['image']),
                                                  // AssetImage(
                                                  //     widget.prestationSelectione.owner.image ??
                                                  //         ''),
                                                )
                                              : const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'assets/images/profile.jpg'),
                                                  // AssetImage(
                                                  //     widget.prestationSelectione.owner.image ??
                                                  //         ''),
                                                ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              snapshot.data != null
                                                  ? Text(
                                                      snapshot.data['nom'] +
                                                          ' ' +
                                                          snapshot
                                                              .data['prenom'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    )
                                                  : Text(
                                                      'Utilisateur suprimee',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 16),
                                                    ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                widget.prestationSelectione
                                                    .addresse,
                                                style: const TextStyle(
                                                    color: Color(0xffFB6161)),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  })),
                          const Divider(
                            thickness: 1,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              const Text("Location",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18)),
                              const SizedBox(
                                height: 14,
                              ),
                              widget.prestationSelectione.geoAddress != LatLng(0,0)? Tooltip(
                                message: 'double tap to open',
                                preferBelow: false,
                                child: InkWell(
                                  onTap: (){ Fluttertoast.showToast(
                                      msg: 'Cliquer deux fois pour ouvrir',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);},
                                  onDoubleTap: () {MapsLauncher.launchCoordinates(widget.prestationSelectione.geoAddress.latitude, widget.prestationSelectione.geoAddress.longitude);},
                                  child: Container(
                                    height: 200,
                                    width:
                                        MediaQuery.of(context).size.width - 60,
                                    decoration: const BoxDecoration(
                                        color: Colors.green),
                                    child: const Image(
                                        image: AssetImage(
                                            "assets/images/googlemaps.png"),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ):const Text("Il n'y a pas des donnes de localisation"),
                              Container(
                                height: 80,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
