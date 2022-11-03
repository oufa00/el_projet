import '../constants/constants.dart';
import '../data/data.dart';
import '../screens/profile_screen.dart';
import '../widgets/textbox.dart';
import 'package:flutter/material.dart';

import '../model/utilisateur_model.dart';

class CustomAppBar extends StatelessWidget {
  CustomAppBar({
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
    required this.titles,
    required this.currentPage,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;
  final List<String> titles;
  final int currentPage;
  UtilisateurModel currentUser = currentUserInfo;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 5,
      ),
      AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.black,
        leading: IconButton(
          icon: const Icon(
            Icons.sort,
            size: 30,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ));
            },
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                FutureBuilder(
                    future: getCurrentUserInfos(),
                    builder: (context, AsyncSnapshot snapshot) {
                      return snapshot.data != null
                          ? CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(snapshot.data['image']),
                            )
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/profile.jpg'),
                            );
                    }),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      Text(
        titles[currentPage],
        style: Theme.of(context).textTheme.headline1,
      ),
      SizedBox(height: 20.h),
      CustomTextBox(title: titles[currentPage]),
    ]);
  }
}
