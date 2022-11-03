import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants/constants.dart';
import '../model/model.dart';

UtilisateurModel currentUserInfo = UtilisateurModel(
    id: ('1919'),
    numeroTelephone: '',
    email: '',
    image: 'assets/images/profile.jpg',
    nom: '',
    prenom: '',
    psudo: '',
    address: '',
    password: '',
);


List<UtilisateurModel> utilisateursInformation = [
  UtilisateurModel(
    id: '1',
    image: AppImages.doctor1,
    nom: 'mohamed',
    address: 'Tripolis, Alger',
    prenom: 'sasi',
    psudo: 'mo7a23',
    numeroTelephone: '02153516',
    email: 'lkuxh@gmail.com', password: '',
  ),
  UtilisateurModel(
    id: '2',
    image: AppImages.doctor2,
    nom: 'Toufik',
    address: 'Batiment casse 231, Beb Eloued',
    psudo: 'toutou',
    prenom: 'nadji',
    numeroTelephone: '5165265',
    email: 'dsdsd@gmail.com', password: '',
  ),
  UtilisateurModel(
    id: '3',
    address: 'quartier Elnnaser, Boufarik',
    image: "assets/images/doctor3.png",
    nom: 'Iman',
    prenom: 'aasi',
    psudo: 'imano16',
    email: 'ukysg@gmail.com',
    numeroTelephone: '5156551515', password: '',
  ),
  UtilisateurModel(
    id: '4',
    address: 'cartier les poulets, Ouled Fayet',
    image: AppImages.doctor4,
    nom: 'Amine',
    prenom: 'Brahimi',
    psudo: 'AminBMR',
    numeroTelephone: '10561653156',
    email: 'ggss@gmail.com', password: '',
  ),
];
