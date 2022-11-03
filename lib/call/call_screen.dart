import 'package:flutter/material.dart';

class CallScreen extends StatefulWidget {
  static const APP_ID = '5e63c7885f4f4b149d741060375593f4';
  static const Token =
      '0065e63c7885f4f4b149d741060375593f4IADLpzyrDwmiF0IO0ra8Tz3Md0H+98vgSh6VVSUWX4X5ox4LZ3EAAAAAEABiLYCEeov7YgEAAQB7i/ti';
  final String target_id;
  final String target_name;
  final String target_pic;
  const CallScreen({
    Key? key,
    required this.target_name,
    required this.target_id,
    required this.target_pic,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  bool _joined = false;
  int _remoteUid = 0;
  bool _switch = false;
  bool speaker_on = false;
  bool muted = false;
  Color sc = Colors.black;
  IconData mi = Icons.mic;


  @override
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:
      Stack(
        fit: StackFit.expand,
        children: [
          // Image
          widget.target_pic != ''
              ? Image.network(
                  widget.target_pic,
                  fit: BoxFit.fitHeight,
                )
              : Image.asset(
                  'assets/images/profile.jpg',
                  fit: BoxFit.fitHeight,
                ),
          // Black Layer
          DecoratedBox(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Text(
                      "${widget.target_name}",
                      style: Theme.of(context)
                          .textTheme
                          .headline1
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "connextion...".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {if(muted){muted = false;}else{muted=true;}setState(() {});
                          if(muted){mi = Icons.mic_off;}else{mi = Icons.mic;}setState(() {

                          });},
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            mi,
                            size: 35,
                            color: Colors.black,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            shape: CircleBorder(), primary: Colors.white),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.call_end,
                            size: 50,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: CircleBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {if(speaker_on){speaker_on = false;}else{speaker_on=true;};setState(() {});
                          if(speaker_on){sc = Colors.blue;}else{sc = Colors.black;}},
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Icon(
                            Icons.volume_up,
                            size: 35,
                            color: sc,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(side: BorderSide(width: 60)),
                          primary: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}