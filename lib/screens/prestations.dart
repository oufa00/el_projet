import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/model/prestation_model.dart';
import 'package:el_project/screens/catigories_screen.dart';

import '../constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/text.dart';
import '../data/catigories_data.dart';
import '../data/prestations_data.dart';
import '../data/utilisateur_data.dart';
import '../widgets/catigories.dart';
import 'details_screen.dart';
import 'nouvelle_prestation_screen.dart';

class prestations_screen extends StatefulWidget {
  const prestations_screen({
    Key? key,
  }) : super(key: key);

  @override
  State<prestations_screen> createState() => _prestations_screenState();
}

class _prestations_screenState extends State<prestations_screen> {



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height*0.0155,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Card(
                child: Container(
                  height: MediaQuery.of(context).size.height*0.22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Catigories(catigories: catigory),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Center(
                child: IconButton(
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: 30,
                    ),
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CatigoriesScreen(),
                        ));}),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),

              // Catigories(catigories: catigories),
              SizedBox(height: MediaQuery.of(context).size.height*0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppText.topDoctors,
                    style: Theme.of(context).textTheme.headline3,
                  ),

                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03),
              FutureBuilder(
                future: getActivePrestations(),
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

              SizedBox(height: MediaQuery.of(context).size.height*0.02),
            ],
          ),
        ),
      ),
    );
  }
}
