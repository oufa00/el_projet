//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:el_project/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/MyElevatedButton.dart';

class OpenSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Fiberchat.getNTPWrappedWidget(Material(
        color: Colors.green,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                'We respect your decission. But neccessary Permission needed so that app can work. If you still wish to Allow Permission, you may follow these steps:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(30),
              child: Text(
                '1. Open App Settings.\n\n2. Go to Permissions.\n\n3.Allow permission for the required service.\n\n4. Return to app & reload the page.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: myElevatedButton(
                    color: Colors.green,
                    onPressed: () {
                      openAppSettings();
                    },
                    child: const Text(
                      'Open App Settings',
                      style: TextStyle(color: Colors.white),
                    ))),
            const SizedBox(height: 20),
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 30.0),
            //     // ignore: deprecated_member_use
            //     child: RaisedButton(
            //         elevation: 0.5,
            //         color: Colors.green,
            //         textColor: fiberchatWhite,
            //         onPressed: () {
            //           Navigator.of(context).pop();
            //         },
            //         child: Text(
            //           'Go Back',
            //           style: TextStyle(color: fiberchatWhite),
            //         ))),
          ],
        ))));
  }
}
