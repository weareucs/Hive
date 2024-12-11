import 'package:demo_ucs/components/esp/esp.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/models/user_data.dart';
import 'package:demo_ucs/utils/screen_size.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Homepage extends StatefulWidget {
  final Map<String, dynamic> data;
  const Homepage({super.key, required this.data});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _controller.addListener(() {
      setState(() {});
    });
  }

  String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good morning,";
    } else if (hour < 17) {
      return "Good afternoon,";
    } else {
      return "Good evening,";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize(context);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        surfaceTintColor: white,
        toolbarHeight: screenSize.heightPercentage(10),
        backgroundColor: white,
        title: Stack(children: [
          Column(
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
        ]),
        actions: const [
          // IconButton(
          //   onPressed: () {
          //     refresh();
          //   },
          //   icon: Icon(Icons.sync),
          // ),
          Icon(EneftyIcons.setting_outline),
          SizedBox(
            width: 10,
          ),
          Icon(EneftyIcons.notification_outline),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   getGreeting(),
                //   style: GoogleFonts.epilogue(
                //     color: grey,
                //   ),
                // ),
                // Text(
                //   widget.data["name"],
                //   overflow: TextOverflow.ellipsis,
                //   style: GoogleFonts.epilogue(
                //     fontWeight: FontWeight.bold,
                //     fontSize: screenSize.widthPercentage(8),
                //   ),
                // ),
                // const SizedBox(
                //   height: 15,
                // ),

                Container(
                  height: screenSize.heightPercentage(80),
                  child: const ESP32ControllerApp(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
