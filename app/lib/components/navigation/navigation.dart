import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ucs/components/loading/loading.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/screens/Help/help.dart';
import 'package:demo_ucs/screens/auth/login.dart';
import 'package:demo_ucs/screens/homepage/homepage.dart';
import 'package:demo_ucs/screens/profile/profile.dart';
import 'package:demo_ucs/screens/shop/shop.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentPageIndex = 0;
  Map<String, dynamic> data = {};

  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;
  Future<void> fetchAndStoreUserData(String email) async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (snapshot.exists) {
        setState(() {
          data = snapshot.data() as Map<String, dynamic>;
        });
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchAndStoreUserData(user!.email.toString());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return isLoading
        ? const Loading()
        : Scaffold(
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              indicatorColor: primary,
              selectedIndex: currentPageIndex,
              backgroundColor: white,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(EneftyIcons.home_wifi_bold),
                  icon: Icon(EneftyIcons.home_wifi_outline),
                  label: 'Home',
                ),
                NavigationDestination(
                  selectedIcon: Icon(EneftyIcons.bag_2_bold),
                  icon: Icon(EneftyIcons.bag_2_outline),
                  label: 'Shop',
                ),
                NavigationDestination(
                  selectedIcon: Icon(EneftyIcons.message_question_bold),
                  icon: Icon(EneftyIcons.message_question_outline),
                  label: 'Help',
                ),
                NavigationDestination(
                  selectedIcon: Icon(EneftyIcons.profile_bold),
                  icon: Icon(EneftyIcons.profile_outline),
                  label: 'Profile',
                ),
              ],
            ),
            body: <Widget>[
              /// Home page
              Homepage(
                data: data,
              ),

              /// Notifications page
              const Shop(),

              const Help(),

              /// Messages page
              const Profile(),
            ][currentPageIndex],
          );
  }
}
