import 'package:flutter/cupertino.dart';

import '../constants/constants.dart';
import '../model/model.dart';
import '../widgets/prestations_list.dart';
import 'package:flutter/material.dart';

class Catigories extends StatefulWidget {
   Catigories({
    Key? key,
    required this.catigories,
  }) : super(key: key);

  final List<CatigoriesModel> catigories;
  static String TappedCat='';
  @override
  State<Catigories> createState() => _CatigoriesState();
}

class _CatigoriesState extends State<Catigories> {

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      scrollDirection: Axis.horizontal,
      crossAxisCount: 2,
      children: List.generate(

        widget.catigories.length,
        (index) {
          return InkWell(
            onTap: (){Catigories.TappedCat = widget.catigories[index].title;
              Navigator.push(context, MaterialPageRoute(builder: (context) =>prestationsList()));},
            child: Column(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    border: Border.all(color: widget.catigories[index].color),
                    color: AppColors.white,
                  ),
                  child: Image.asset(
                    widget.catigories[index].image,
                    color: widget.catigories[index].color,
                  ),
                ),const SizedBox(height: 5,),
                Expanded(
                  child: Text(
                    widget.catigories[index].title,textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
