import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ucs/components/loading/loading.dart';
import 'package:demo_ucs/components/navigation/navigation.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/models/user_data.dart';
import 'package:demo_ucs/models/usermodel.dart';
import 'package:demo_ucs/screens/auth/login.dart';
import 'package:demo_ucs/screens/homepage/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    Future<void> fetchAndStoreUserData(String email) async {
      try {
        setState(() {
          isLoading = true;
        });
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(email)
            .get();

        if (snapshot.exists) {
          userData.currentUser =
              UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
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

    return Scaffold(
      backgroundColor: transparent,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(
              color: Colors.black,
            );
          } else {
            if (snapshot.hasData) {
              return const Navigation();
            } else {
              return const Login();
            }
          }
        },
      ),
    );
  }
}
