import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/constants/constants.dart';
import 'package:el_project/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/prestations_data.dart';
import '../screens/nouvelle_prestation_screen.dart';
import '../widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/images.dart';
import '../screens/details_screen.dart';
import 'catigories.dart';
import '../model/prestation_model.dart';

class prestationsList extends StatefulWidget {
  prestationsList({Key? key}) : super(key: key);

  @override
  State<prestationsList> createState() => _prestationsListState();
}

class _prestationsListState extends State<prestationsList> {

  Future<List<PrestationsModel>> getActivePrestationsPerCat(String catName)async{
    List<PrestationsModel> prestations = [];
    QuerySnapshot<Map<String, dynamic>> data =
    await FirebaseFirestore.instance.collection("Prestations").get();

    data.docs.forEach((element) {
      if(element.data()['isOn'] == true && element.data()['catigory'] == catName){
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      appBar:
      AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,

        foregroundColor: AppColors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.sort,
            size: 30,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NouvellePrestationScreen(),
                ));
          }, icon: Icon(Icons.add,color: AppColors.black,)),

          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: FutureBuilder(
          future: getActivePrestationsPerCat(Catigories.TappedCat),
          builder: (context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) return Text('Loading ');
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 0.0),
                child: GridView.count(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: MediaQuery.of(context).size.height*0.001,
                  children: List.generate(
                    snapshot.data.length,
                        (index) {
                      return Column(
                        children: [
                          Card(
                            child: InkWell(
                              onTap: (() =>
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(
                                              prestationSelectione: snapshot
                                                  .data[index],
                                            ),
                                      ))),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:  EdgeInsets.fromLTRB(5, 5, 5, 0),
                                    child: Container(
                                      height: MediaQuery.of(context).size.height*0.155,
                                      width: MediaQuery.of(context).size.width*0.4,
                                      decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        image:  DecorationImage(
                                          image: snapshot.data[index].imagepath != null ?
                                          NetworkImage(snapshot.data[index].imagepath,)
                                              : NetworkImage('url'),fit: BoxFit.cover,
                                        ),
                                      ),

                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.01),
                                  Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.28,
                                          child: Text(
                                            snapshot.data[index].titre,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 18),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width*0.144,
                                          child: Text(
                                            snapshot.data[index].price,
                                            overflow: TextOverflow
                                                .ellipsis,),
                                        ),
                                      ]),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            }
            else {
              return const Text('NO DATA');
            }
          }
      ),

    );}
}