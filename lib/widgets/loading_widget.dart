import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Center(
        child: Column(
          children:[ SpinKitChasingDots(
            color: Colors.indigo,
            size: 50,
          ),
          Text('Vouliez patienter')]
        ),
      ),
    );
  }
}
