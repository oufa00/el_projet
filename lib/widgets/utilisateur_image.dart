import '../constants/constants.dart';
import '../model/model.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

class UtilisateurImage extends StatelessWidget {
  final UtilisateurModel utilisateurInformationModel;

  const UtilisateurImage({
    Key? key,
    required this.utilisateurInformationModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 375.h,
      child: Stack(
        children: [
          Hero(
            tag: "doctor-hero-${utilisateurInformationModel.id}",
            child: Container(
              height: 350,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    utilisateurInformationModel.image!,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: const SizedBox(height: 20),
            ),
          ),

        ],
      ),
    );
  }
}
