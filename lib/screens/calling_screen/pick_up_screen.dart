//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/screens/calling_screen/video_call.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';

import '../../Services/call_history_provider.dart';
import '../../Utils/open_settings.dart';
import '../../Utils/permissions.dart';
import '../../Utils/utils.dart';
import '../../main.dart';
import '../../model/call.dart';
import '../../model/call_methods.dart';
import '../../widgets/cached_image.dart';
import 'audio_call.dart';

// ignore: must_be_immutable
class PickupScreen extends StatelessWidget {
  final Call call;
  final String? currentuseruid;
  final CallMethods callMethods = CallMethods();

  PickupScreen({
    required this.call,
    required this.currentuseruid,
  });
  ClientRole _role = ClientRole.Broadcaster;
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Colors.green,
                height: h / 4,
                width: w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 7,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          call.isvideocall == true
                              ? Icons.videocam
                              : Icons.mic_rounded,
                          size: 40,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        SizedBox(
                          width: 7,
                        ),
                        Text(
                          call.isvideocall == true ? 'incomingaudio' : '',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.green.withOpacity(0.5),
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: h / 9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 7),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Text(
                              call.callerName!,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.green,
                                fontSize: 27,
                              ),
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            call.callerId!,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.green.withOpacity(0.34),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: h / 25),

                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              call.callerPic == null || call.callerPic == ''
                  ? Container(
                      height: w + (w / 140),
                      width: w,
                      color: Colors.white12,
                      child: Icon(
                        Icons.person,
                        size: 140,
                        color: Colors.green,
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                            height: w + (w / 140),
                            width: w,
                            color: Colors.white12,
                            child: CachedNetworkImage(
                              imageUrl: call.callerPic!,
                              fit: BoxFit.cover,
                              height: w + (w / 140),
                              width: w,
                              placeholder: (context, url) => Center(
                                  child: Container(
                                height: w + (w / 140),
                                width: w,
                                color: Colors.white12,
                                child: Icon(
                                  Icons.person,
                                  size: 140,
                                  color: Colors.green,
                                ),
                              )),
                              errorWidget: (context, url, error) => Container(
                                height: w + (w / 140),
                                width: w,
                                color: Colors.white12,
                                child: Icon(
                                  Icons.person,
                                  size: 140,
                                  color: Colors.green,
                                ),
                              ),
                            )),
                        Container(
                          height: w + (w / 140),
                          width: w,
                          color: Colors.black.withOpacity(0.18),
                        ),
                      ],
                    ),
              Container(
                height: h / 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () async {
                        flutterLocalNotificationsPlugin.cancelAll();
                        await callMethods.endCall(call: call);
                        FirebaseFirestore.instance
                            .collection('utilisateurs')
                            .doc(call.callerId)
                            .collection('callhistory')
                            .doc(call.timeepoch.toString())
                            .set({
                          'STATUS': 'rejected',
                          'ENDED': DateTime.now(),
                        }, SetOptions(merge: true));
                        FirebaseFirestore.instance
                            .collection('utilisateurs')
                            .doc(call.receiverId)
                            .collection('callhistory')
                            .doc(call.timeepoch.toString())
                            .set({
                          'STATUS': 'rejected',
                          'ENDED': DateTime.now(),
                        }, SetOptions(merge: true));
                        //----------
                        await FirebaseFirestore.instance
                            .collection('utilisateurs')
                            .doc(call.receiverId)
                            .collection('recent')
                            .doc('callended')
                            .set({
                          'id': call.receiverId,
                          'ENDED': DateTime.now().millisecondsSinceEpoch
                        }, SetOptions(merge: true));

                        /* firestoreDataProviderCALLHISTORY.fetchNextData(
                                    'CALLHISTORY',
                                    FirebaseFirestore.instance
                                        .collection('utilisateurs')
                                        .doc(call.receiverId)
                                        .collection('callhistory')
                                        .orderBy('TIME', descending: true)
                                        .limit(14),
                                    true);*/
                      },
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      shape: CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.redAccent,
                      padding: const EdgeInsets.all(15.0),
                    ),
                    SizedBox(width: 45),
                    RawMaterialButton(
                      onPressed: () async {
                        flutterLocalNotificationsPlugin.cancelAll();
                        await Permissions
                                .cameraAndMicrophonePermissionsGranted()
                            .then((isgranted) async {
                          if (isgranted == true) {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => call.isvideocall == true
                                    ? VideoCall(
                                        currentuseruid: currentuseruid,
                                        call: call,
                                        channelName: call.channelId,
                                        role: _role,
                                      )
                                    : AudioCall(
                                        currentuseruid: currentuseruid,
                                        call: call,
                                        channelName: call.channelId,
                                        role: _role,
                                      ),
                              ),
                            );
                          } else {
                            Fiberchat.showRationale('pmc');
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OpenSettings()));
                          }
                        }).catchError((onError) {
                          Fiberchat.showRationale('pmc');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OpenSettings()));
                        });
                      },
                      child: const Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 35.0,
                      ),
                      shape: const CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.green[400],
                      padding: const EdgeInsets.all(15.0),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
    /*
            : Scaffold(
                backgroundColor: Colors.green,
                body: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: w > h ? 60 : 100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        w > h
                            ? const SizedBox(
                                height: 0,
                              )
                            : Icon(
                                call.isvideocall == true
                                    ? Icons.videocam_outlined
                                    : Icons.mic,
                                size: 80,
                                color: Colors.green.withOpacity(0.3),
                              ),
                        w > h
                            ? const SizedBox(
                                height: 0,
                              )
                            : const SizedBox(
                                height: 20,
                              ),
                        Text(
                          call.isvideocall == true
                              ? 'incomingvideo'
                              : 'incomingaudio',
                          style: TextStyle(
                            fontSize: 19,
                            color: Colors.green.withOpacity(0.54),
                          ),
                        ),
                        SizedBox(height: w > h ? 16 : 50),
                        CachedImage(
                          call.callerPic,
                          isRound: true,
                          height: w > h ? 60 : 110,
                          width: w > h ? 60 : 110,
                          radius: w > h ? 70 : 138,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          call.callerName!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: w > h ? 30 : 75),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await callMethods.endCall(call: call);
                                FirebaseFirestore.instance
                                    .collection('utilisateurs')
                                    .doc(call.callerId)
                                    .collection('callhistory')
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                FirebaseFirestore.instance
                                    .collection('utilisateurs')
                                    .doc(call.receiverId)
                                    .collection('callhistory')
                                    .doc(call.timeepoch.toString())
                                    .set({
                                  'STATUS': 'rejected',
                                  'ENDED': DateTime.now(),
                                }, SetOptions(merge: true));
                                //----------
                                await FirebaseFirestore.instance
                                    .collection('utilisateurs')
                                    .doc(call.receiverId)
                                    .collection('recent')
                                    .doc('callended')
                                    .set({
                                  'id': call.receiverId,
                                  'ENDED': DateTime.now().millisecondsSinceEpoch
                                }, SetOptions(merge: true));

                                firestoreDataProviderCALLHISTORY.fetchNextData(
                                    'CALLHISTORY',
                                    FirebaseFirestore.instance
                                        .collection('utilisateurs')
                                        .doc(call.receiverId)
                                        .collection('callhistory')
                                        .orderBy('TIME', descending: true)
                                        .limit(14),
                                    true);
                              },
                              child: const Icon(
                                Icons.call_end,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.redAccent,
                              padding: const EdgeInsets.all(15.0),
                            ),
                            SizedBox(width: 45),
                            RawMaterialButton(
                              onPressed: () async {
                                flutterLocalNotificationsPlugin.cancelAll();
                                await Permissions
                                        .cameraAndMicrophonePermissionsGranted()
                                    .then((isgranted) async {
                                  if (isgranted == true) {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => call
                                                    .isvideocall ==
                                                true
                                            ? AudioCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              )
                                            : AudioCall(
                                                currentuseruid: currentuseruid,
                                                call: call,
                                                channelName: call.channelId,
                                                role: _role,
                                              ),
                                      ),
                                    );
                                  } else {
                                    Fiberchat.showRationale('pmc');
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OpenSettings()));
                                  }
                                }).catchError((onError) {
                                  Fiberchat.showRationale('pmc');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OpenSettings()));
                                });
                              },
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                                size: 35.0,
                              ),
                              shape: CircleBorder(),
                              elevation: 2.0,
                              fillColor: Colors.green,
                              padding: const EdgeInsets.all(15.0),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ));
              */
  }
}
