import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/model.dart';
import 'package:flutter/material.dart';
import 'catigories_model.dart';

class PrestationsModel {
  final String titre,
      description,
      imagepath,owner,
      price;
  final String catigory;
  final String id,addresse;
  final LatLng geoAddress;
  final List<String> imageList;
  final bool isOn;

  PrestationsModel({
    required this.geoAddress,
    required this.isOn,
    required this.addresse,
    required this.titre,
    required this.description,
    required this.owner,
    required this.imagepath,
    required this.price,
    required this.catigory,
    required this.id,
    required this.imageList,
  });
}
