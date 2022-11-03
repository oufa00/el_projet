import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/data/data.dart';
import 'package:el_project/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:google_maps_webservice/places.dart';

import '../data/catigories_data.dart';
import '../model/catigories_model.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import '../widgets/map_location_picker.dart';
import '../widgets/location_picker.dart';

class NouvellePrestationScreen extends StatefulWidget {
  NouvellePrestationScreen({Key? key}) : super(key: key);
  final List<CatigoriesModel> catigories = catigory;
  @override
  State<NouvellePrestationScreen> createState() =>
      _NouvellePrestationScreenState();
}

class _NouvellePrestationScreenState extends State<NouvellePrestationScreen> {
  final _title = TextEditingController();
   LatLng geoAdd = LatLng(0,0);
  final _description = TextEditingController();
  bool loading = false;
  String address ='';
  late var _price = TextEditingController();
  List<XFile>? imagesFileList = [];
  static List<String> cats = catigory.map((e) => e.title).toList();
  final List<DropdownMenuItem<String>> dropItems = catigory
      .map((CatigoriesModel value) => DropdownMenuItem<String>(
            value: value.title,
            child: Text(value.title),
          ))
      .toList();
  String selectedItem = cats[0];
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Creer une nouvelle prestation'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black),
      body: loading ? Center(child: Loading()) :Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: ListView(
          children: [
            const Text(
              'Images',
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(children: [
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 500,
                                childAspectRatio: 1 / 2,
                                crossAxisSpacing: 0,
                                mainAxisSpacing: 0),
                        itemCount: imagesFileList!.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (imagesFileList!.length == index) {
                            return GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40)),
                                width: 50,
                                height: 50,
                                child: Card(
                                  elevation: 3,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(1, 5, 1, 5),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.indigo,
                                        ),
                                      ),
                                      Text("Ajouter des images",
                                          style: TextStyle(
                                              color: Colors.indigo,
                                              fontSize: 10)),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      SimpleDialog(
                                    title: const Text('Select image source:'),
                                    children: [
                                      ListTile(
                                        leading: const Icon(Icons.image),
                                        title: const Text('Gallery'),
                                        onTap: () {
                                          pickImage();
                                        },
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(16)),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 20),
                            child:
                                Image.file(File(imagesFileList![index].path)),
                          );
                        }),
                  ),
                ])),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _title,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Titre de prestation',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Catigorie',
                labelStyle: TextStyle(fontSize: 14),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              items: cats
                  .map((e) => DropdownMenuItem(
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 14),
                        ),
                        value: e,
                      ))
                  .toList(),
              value: selectedItem,
              onChanged: (item) {
                setState(() {
                  selectedItem = item!;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _price,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                labelText: 'Prix',
                suffixText: 'DZD',
                suffixStyle: TextStyle(color: Colors.indigo),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _description,
              keyboardType: TextInputType.multiline,
              maxLines: 8,
              style: const TextStyle(color: Colors.black, fontSize: 14),
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.indigo,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {

                    return LocationPicker(
                      onNextt: (String? adr){
                        if(adr != null){

                          setState(() {
                            address = adr;
                          });
                        }
                      },
                      apiKey: "AIzaSyDuqoT7uDrbN6C7apxh3FsQ-XSz6qmc6HY",
                      canPopOnNextButtonTaped: true,
                      onNext: (LatLng? result) {

                        if (result != null){
                          setState(()  {
                            geoAdd = result;

                            if (kDebugMode) {
                              print('hellllllllllllllllllllllom\n\n\n\n\n\n\n\n\n'+geoAdd.longitude.toString()+'heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'+geoAdd.latitude.toString());
                            }
                            if (kDebugMode) {
                              print(result.longitude);
                            }
                          });
                        }
                      },
                    );
                  },
                ),
              );
            }, child: const Text('selectionner la geo localisation')),
            if (geoAdd !=LatLng(0,0))  Center(child: Text('Localisation acctuelle:\n  ${address}')) else SizedBox(),

          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 73,
        child: BottomAppBar(
          color: Colors.white,
          elevation: 10.0,
          child: FittedBox(
            fit: BoxFit.none,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  List<String> urls = [];
                  for (int i = 0; i < imagesFileList!.length; i++) {
                    String? url = await uploadImage(imagesFileList![i]);
                    if (url != null) {
                      urls.add(url);
                    }
                  }
                  if(_title.text.isEmpty)_title.text =' ';
                  if(_description.text.isEmpty)_description.text =' ';
                  if(_price.toString().isEmpty)_price =0.toString() as TextEditingController;

                  await FirebaseFirestore.instance
                      .collection('Prestations')
                      .add({
                    'titre': _title.text.toString(),
                    'description': _description.text.toString(),
                    'prix': _price.text.toString(),
                    'owner': FirebaseAuth.instance.currentUser?.uid
                        .toString(),
                    'images': urls ,
                    'catigory': selectedItem.toString(),
                    'isOn': true,
                    'geoAddressLat': geoAdd.latitude,
                    'geoAddressLng': geoAdd.longitude,
                  });
                  Navigator.of(context).pop();
                  setState(() {
                    loading = false;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 6.0),
                  height: 46,
                  width: 186,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: const Text(
                    "Creer",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void pickImage() async {
    final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      setState(() {});
      imagesFileList?.addAll(selectedImages);
    }
  }
}
Future<String?> uploadImage(XFile image) async {
  try {
    String path =
        "offersImages/${FirebaseAuth.instance.currentUser!.uid}/${image.name}";
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