import 'package:el_project/messenger/massenger_screen.dart';

import '../authentication.dart';
import '../data/data.dart';
import '../model/model.dart';
import 'package:flutter/material.dart';

import '../screens/catigories_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/welcome_screen.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({Key? key}) : super(key: key);
  UtilisateurModel CurrentUser = currentUserInfo;
  final authService _auth = authService();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Column(children: [
            InkWell( onTap: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ProfileScreen()));},
              child: FutureBuilder(future: getCurrentUserInfos(),builder: (context, AsyncSnapshot snapshot) {
                return snapshot.data!=null? CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(snapshot.data['image']),
                ):CircleAvatar(radius: 70,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),);})
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              CurrentUser.nom??'',
              style: const TextStyle(fontSize: 20),
            )
          ]),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Divider(
                color: Colors.black,
              )),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.home),
            title: const Text('Acceil'),
          ),
          ListTile(
            onTap: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CatigoriesScreen(),
                ));},
            leading: const Icon(Icons.grid_view),
            title: const Text('Catigories'),
          ),
          ListTile(
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MassengerScreen()));},
            leading: const Icon(Icons.message),
            title: const Text('Messages'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.shield_moon),
            title: const Text('Privacy Policy'),
          ),
          ListTile(
            onTap: () async {
              await _auth.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => WelcomeScreen(),
                ),
                (route) => false,
              );
            },
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
