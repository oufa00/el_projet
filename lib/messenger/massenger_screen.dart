import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_project/constants/constants.dart';
import 'package:el_project/data/data.dart';
import 'package:el_project/messenger/providers/home_provider.dart';
import 'package:el_project/model/utilisateur_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/firestore_constants.dart';
import '../widgets/kboards.dart';
import 'dm_screen.dart';

class MassengerScreen extends StatefulWidget {
  const MassengerScreen({Key? key}) : super(key: key);

  @override
  State<MassengerScreen> createState() => _MassengerScreenState();
}


class _MassengerScreenState extends State<MassengerScreen> {
  late HomeProvider homeProvider;
  final ScrollController scrollController = ScrollController();
  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();
  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }
  @override
  void initState(){
    super.initState();
    homeProvider = context.read<HomeProvider>();

    scrollController.addListener(scrollListener);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.indigo,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      body: Stack(
        children: [Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.all(10),
                height: 50,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.person_search,
                      color: AppColors.white,
                      size: 24,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: TextFormField(
                        textInputAction: TextInputAction.search,
                        controller: searchTextEditingController,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            buttonClearController.add(true);
                            setState(() {
                              _textSearch = value;
                            });
                          } else {
                            buttonClearController.add(false);
                            setState(() {
                              _textSearch = "";
                            });
                          }
                        },
                        decoration: const InputDecoration.collapsed(
                          hintText: 'Search here...',
                          hintStyle: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                    StreamBuilder(
                        stream: buttonClearController.stream,
                        builder: (context, snapshot) {
                          return snapshot.data == true
                              ? GestureDetector(
                                  onTap: () {
                                    searchTextEditingController.clear();
                                    buttonClearController.add(false);
                                    setState(() {
                                      _textSearch = '';
                                    });
                                  },
                                  child: const Icon(
                                    Icons.clear_rounded,
                                    color: AppColors.grey,
                                    size: 20,
                                  ),
                                )
                              : const SizedBox.shrink();
                        })
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(0xFF39393A),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: homeProvider.getFirestoreData(
                    FirestoreConstants.pathUserCollection,
                    _limit,
                    _textSearch),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if ((snapshot.data?.docs.length ?? 0) > 0) {
                      return ListView.separated(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) => buildItem(
                            context, snapshot.data?.docs[index]),
                        controller: scrollController,
                        separatorBuilder:
                            (BuildContext context, int index) =>
                        const Divider(),
                      );
                    } else {
                      return const Center(
                        child: Text('No user found...'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),

          ],
        ),]
      ),
    );
  }Widget buildItem(BuildContext context, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null  ) {
      UtilisateurModel user = UtilisateurModel.fromDocument(documentSnapshot);
      if (user.id == FirebaseAuth.instance.currentUser!.uid) {
        return SizedBox();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                      peerId: user.id!,
                      peerAvatar: user.image!,
                      peerNickname: user.psudo!,
                      userAvatar:user.image!,
                    )));
          },
          child: ListTile(
            leading: user.image!.isNotEmpty
                ? ClipRRect(
              borderRadius: BorderRadius.circular( 50),
              child: Image.network(
                user.image!,
                fit: BoxFit.cover,
                width: 50,
                height: 50,
                loadingBuilder: (BuildContext ctx, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                          color: Colors.grey,
                          value: loadingProgress.expectedTotalBytes !=
                              null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null),
                    );
                  }
                },
                errorBuilder: (context, object, stackTrace) {
                  return const Icon(Icons.account_circle, size: 66.66);
                },
              ),
            )
                : const Icon(
              Icons.account_circle,
              size: 66.666666,
            ),
            title: Container(
              height: 50,
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children:[ Text(
                  user.nom!,
                  style: const TextStyle(color: Colors.black,fontSize: 16),
                ),
                  Text(
                    user.psudo!,
                    style: const TextStyle(color: Colors.blueGrey),
                  ),
                ]
              ),
            ),
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

}
