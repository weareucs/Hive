import 'dart:async';

import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/screens/auth/auth.dart';
import 'package:demo_ucs/screens/homepage/homepage.dart';
import 'package:demo_ucs/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

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
    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Auth()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}
