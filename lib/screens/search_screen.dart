import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../constants/colors.dart';
import '../data/prestations_data.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    Position _currentPosition;
    String _currentAddress = '';
    Future<void> _getCurrentPosition() async {
      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print('Current location: ' +
          _currentPosition.longitude.toString() +
          ' , ' +
          _currentPosition.latitude.toString());
      setState(() {
        _currentPosition;
        _currentAddress = _currentPosition.latitude.toString() +
            ' , ' +
            _currentPosition.longitude.toString();
      });
    }
    double calculateDistance(LatLng current_position, LatLng desired_position){
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 - c((desired_position.latitude - current_position.latitude) * p)/2 +
          c(current_position.latitude * p) * c(desired_position.latitude * p) *
              (1 - c((desired_position.longitude - desired_position.longitude) * p))/2;
      return 12742 * asin(sqrt(a));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: false,
            titleTextStyle: TextStyle(color: Colors.white),
            title: Text(_currentAddress),
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _getCurrentPosition();
                    });
                  },
                  icon: Icon(Icons.location_on))
            ],
            bottom: AppBar(
              leading: SizedBox(),
              title: Container(
                width: double.infinity,
                height: 40,
                color: Colors.white,
                child: const Center(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Search for something',
                        prefixIcon: Icon(Icons.search),
                        suffixIcon: Icon(Icons.camera_alt)),
                  ),
                ),
              ),
            ),
          ),
          // Other Sliver Widgets
          SliverList(
            delegate: SliverChildListDelegate([
              //place you widgets here
              Column(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                      future: getActivePrestations(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting) return Text('Loading ');
                        if (snapshot.hasData) {
                          return ListView.builder(itemCount: snapshot.data.length,itemBuilder: (BuildContext context,int index){
                            return Card(child: Container(height: 200,child: Column(children: [
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
                            ],),),);
                          });
                        }
                        else {
                          return const Text('NO DATA');
                        }
                      }
                  ),
                ),
              ],)
            ]),
          ),
        ],
      ),
    );
  }
}
