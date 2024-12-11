import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_ucs/components/navigation/navigation.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/models/user_data.dart';
import 'package:demo_ucs/models/usermodel.dart';
import 'package:demo_ucs/screens/auth/signup.dart';
import 'package:demo_ucs/screens/homepage/homepage.dart';
import 'package:demo_ucs/utils/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isLoading = false;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool isObcsure = true;

  Future<void> fetchAndStoreUserData(String email) async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(email).get();

      if (snapshot.exists) {
        userData.currentUser =
            UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
        print('User data fetched and stored successfully.');
      } else {
        print('No user found with email $email.');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text(
          'Login successfully',
          style: GoogleFonts.epilogue(),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
      setState(() {
        isLoading = false;
      });
      await fetchAndStoreUserData(email);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const Navigation(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      toastification.show(
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(
          'Something went wrong.',
          style: GoogleFonts.epilogue(),
        ),
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.bottomCenter,
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);
    return isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.epilogue(color: black),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Signup(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            return FadeTransition(
                              opacity: animation,
                              child: child,
                            );
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.epilogue(color: Colors.amber),
                    ),
                  ),
                ],
              ),
            ),
            appBar: AppBar(
              surfaceTintColor: transparent,
              toolbarHeight: screenSize.heightPercentage(15),
              backgroundColor: white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) {
                      return LinearGradient(
                        colors: [
                          primary,
                          Colors.amber,
                          const Color.fromARGB(255, 254, 255, 179),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: GradientRotation(
                            _controller.value * 2 * 3.14159), // Single rotation
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Hive.",
                      style: GoogleFonts.epilogue(
                        fontSize: screenSize.widthPercentage(8),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    "Control with ease.",
                    style: GoogleFonts.epilogue(
                      fontSize: screenSize.widthPercentage(3.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: white,
            body: Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              // height: screenSize.heightPercentage(85),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome back.",
                        style: GoogleFonts.epilogue(
                            fontSize: screenSize.widthPercentage(13),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _email,
                        style: GoogleFonts.epilogue(),
                        cursorColor: black,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: primary),
                          ),
                          labelText: "Email",
                          labelStyle: GoogleFonts.epilogue(color: black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: grey),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: isObcsure,
                        style: GoogleFonts.epilogue(),
                        cursorColor: black,
                        decoration: InputDecoration(
                          suffixIcon: isObcsure
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObcsure = false;
                                    });
                                  },
                                  icon: const Icon(Icons.visibility),
                                )
                              : IconButton(
                                  onPressed: () {
                                    setState(() {
                                      isObcsure = true;
                                    });
                                  },
                                  icon: const Icon(Icons.visibility_off),
                                ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(color: primary),
                          ),
                          labelText: "Password",
                          labelStyle: GoogleFonts.epilogue(color: black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: const BorderSide(color: grey),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          if (_email.text.isEmpty || _password.text.isEmpty) {
                            toastification.show(
                              type: ToastificationType.error,
                              style: ToastificationStyle.fillColored,
                              context: context,
                              title: Text(
                                'Please provide all required details',
                                style: GoogleFonts.epilogue(),
                              ),
                              autoCloseDuration: const Duration(seconds: 5),
                              alignment: Alignment.bottomCenter,
                            );
                          } else {
                            login(_email.text, _password.text);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 22,
                            right: 22,
                            top: 15,
                            bottom: 15,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            gradient: LinearGradient(colors: [
                              Colors.amber,
                              primary,
                            ]),
                          ),
                          child: Center(
                            child: Text(
                              "Login",
                              style: GoogleFonts.epilogue(
                                  fontSize: screenSize.widthPercentage(4),
                                  color: white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
