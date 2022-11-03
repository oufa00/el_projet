import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/constants.dart';
import '../data/data.dart';
import '../model/model.dart';

import '../model/prestation_model.dart';

List<PrestationsModel> prestations = [];
List<PrestationsModel> prestationsActives = [];

Future<List<PrestationsModel>> getPrestations() async {
  List<PrestationsModel> prestations = [];
  QuerySnapshot<Map<String, dynamic>> data =
      await FirebaseFirestore.instance.collection("Prestations").get();

  data.docs.forEach((element) {
    late List<String> images = [];
    element.data()['images'].forEach((element) {
      images.add(element);
    });
    if(images.isEmpty){images.add('assets/images/no_image.jpg');}
    prestations.add(PrestationsModel(
      addresse: '',
      description: element.data()['description'],
      imageList: images,
      imagepath: element.data()['images'][0].toString(),
      catigory: element.data()['catigory'],
      owner: element.data()['owner'],
      titre: element.data()['titre'],
      price: element.data()['prix'],
      id: element.id, isOn: element.data()['isOn'], geoAddress: LatLng(element.data()['geoAddressLat'].toDouble(), element.data()['geoAddressLng'].toDouble()),
      //  owner: AppUser()
    ));
  });

  return prestations;
}
Future<List<PrestationsModel>> getActivePrestations()async{
  List<PrestationsModel> prestations = [];
  QuerySnapshot<Map<String, dynamic>> data =
  await FirebaseFirestore.instance.collection("Prestations").get();

  data.docs.forEach((element) {
    if(element.data()['isOn'] == true){
      late List<String> images = [];
      element.data()['images'].forEach((element) {
        images.add(element);
      });
      if (images.isEmpty) {
        images.add('assets/images/no_image.jpg');
      }
      prestations.add(PrestationsModel(
        addresse: '',
        description: element.data()['description'],
        imageList: images,
        imagepath: element.data()['images'][0].toString(),
        catigory: element.data()['catigory'],
        owner: element.data()['owner'],
        titre: element.data()['titre'],
        price: element.data()['prix'],
        id: element.id,
        isOn: element.data()['isOn'],
        geoAddress: LatLng(element.data()['geoAddressLat'].toDouble(),
            element.data()['geoAddressLng'].toDouble()),
        //  owner: AppUser()
      ));
    }
  });

  return prestations;
}
