import 'package:el_project/data/catigories_data.dart';
import 'package:el_project/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../data/catigories_data.dart';
import '../widgets/prestations_list.dart';

class CatigoriesScreen extends StatelessWidget {
  const CatigoriesScreen({Key? key}) : super(key: key);
  static String TappedCat='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back)),
        title: Text(
          'Catigories',style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo,
      ),
        body:
        ListView(
          children: catigory
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: ListTile(
                    onTap: (){Catigories.TappedCat = e.title;
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>prestationsList()));},
                    leading: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.0),
                        border: Border.all(color: e.color),
                        color: AppColors.white,
                      ),
                      child: Image.asset(
                        e.image,
                        color: e.color,
                      ),
                    ),
                  title: Text(e.title,style: TextStyle(fontSize: 16),),
                  ),
                ),
          )
              .toList(),
        )
    );
  }
}
