import '../constants/constants.dart';
import 'package:flutter/material.dart';

import '../screens/search_screen.dart';

class CustomTextBox extends StatelessWidget {
  const CustomTextBox({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height/15,
      width: MediaQuery.of(context).size.width-10,
    child:
        Card(shadowColor: Colors.indigo,elevation: 6,
        child: InkWell(
          onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SearchScreen()));},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6,horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              Text('Rechercher...',style: TextStyle(color: Colors.black54),),
              Icon(Icons.search,color: Colors.black54,),
            ],),
          ),
        ),),
    );

  }
}
