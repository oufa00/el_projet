import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Utils/utils.dart';
import '../constants/constants.dart';
import '../data/data.dart';
import '../data/prestations_data.dart';
import '../model/model.dart';
import '../screens/details_screen.dart';
import '../screens/market_page.dart';
import '../screens/nouvelle_prestation_screen.dart';
import '../screens/prestations.dart';
import '../screens/rencontre_page.dart';
import '../widgets/drawer.dart';
import '../widgets/widgets.dart';
import 'package:flutter/material.dart';

import 'calling_screen/pickup_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  UtilisateurModel CurrentUser = currentUserInfo;
  final screens = [
    const MarketPage(),
    const prestations_screen(),
    const RencontrePage()
  ];
  final List<String> titles = ["Market", "Prestation", "Meet"];
  var currentPage = 1;

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Fiberchat.getNTPWrappedWidget(Scaffold(
      key: _scaffoldkey,
      drawer: Theme(
        child: CustomDrawer(),
        data: ThemeData(primaryColor: Colors.black),
      ),
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(190),
        child: CustomAppBar(
            scaffoldKey: _scaffoldkey,
            titles: titles,
            currentPage: currentPage),
      ),
      body: screens[currentPage],
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.textIn,
        onTap: (index) => setState(() {
          currentPage = index;
        }),
        backgroundColor: Colors.white,
        activeColor: Colors.indigo,
        color: Colors.grey,
        items: const [
          TabItem(
            icon: Icons.store,
            title: 'Market',
          ),
          TabItem(icon: Icons.grid_view, title: 'Prestation'),
          TabItem(icon: Icons.people, title: 'Meet'),
        ],
        initialActiveIndex: 1,
      ),
    )));
  }
}
