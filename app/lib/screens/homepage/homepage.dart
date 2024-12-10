import 'package:demo_ucs/ChangeCredentialsPage.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/models/user_data.dart';
import 'package:demo_ucs/utils/screen_size.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class ESP32ControllerApp extends StatefulWidget {
  const ESP32ControllerApp({Key? key}) : super(key: key);

  @override
  _ESP32ControllerAppState createState() => _ESP32ControllerAppState();
}

class _ESP32ControllerAppState extends State<ESP32ControllerApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String esp32Url = 'http://192.168.4.1';
  List<Map<String, dynamic>> devices = [];
  bool isLoading = false;
  String? currentSSID;
  final wifiInfo = NetworkInfo();
  String ssid = '';

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
    _initializeEsp32Url();
    fetchStatus();
    fetchSSID();
  }

  Future<void> fetchSSID() async {
    try {
      // Request location permissions
      bool hasPermission = await requestLocationPermissions();
      if (!hasPermission) {
        showError('Location permission is required to fetch Wi-Fi SSID');
        return;
      }

      final wifiInfo = NetworkInfo();
      String? ssid = await wifiInfo.getWifiIP();
      print(await wifiInfo.getWifiName());
      setState(() {
        currentSSID = ssid ?? 'Unknown SSID'; // Remove quotes
      });
    } catch (e) {
      showError('Error fetching SSID: $e');
    }
  }

  Future<bool> requestLocationPermissions() async {
    // Check if permissions are granted
    if (await Permission.location.isGranted) {
      return true;
    }

    // Request permissions
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _initializeEsp32Url() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4) {
            String currentIP = addr.address;
            String modifiedIP =
                currentIP.substring(0, currentIP.lastIndexOf('.')) + '.1';
            setState(() {
              esp32Url = 'http://$modifiedIP';
            });
            return;
          }
        }
      }
    } catch (e) {
      showError('Error fetching device IP: $e');
    }
  }

  void refresh() {
    _initializeEsp32Url();
    fetchStatus();
  }

  Future<void> toggleDevice(int deviceId) async {
    setState(() => isLoading = true);
    try {
      final response =
          await http.get(Uri.parse('$esp32Url/toggle?button_id=$deviceId'));
      if (response.statusCode == 200) {
        fetchStatus();
      } else {
        showError('Failed to toggle device $deviceId');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> resetDevices() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$esp32Url/reset'));
      if (response.statusCode == 200) {
        fetchStatus();
      } else {
        showError('Failed to reset devices');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchStatus() async {
    setState(() => isLoading = true); // Show loading indicator
    try {
      // Make the HTTP GET request to fetch status
      final response = await http.get(Uri.parse('$esp32Url/status'));

      if (response.statusCode == 200) {
        // Parse the response JSON
        Map<String, dynamic> data = json.decode(response.body);

        // Extract the SSID from the response
        String ssid = data['ssid'];

        // Extract the devices list
        setState(() {
          devices = List<Map<String, dynamic>>.from(data['devices']);
          this.ssid = ssid; // Store SSID in a state variable
        });
      } else {
        showError('Failed to fetch device status');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isLoading = false); // Hide loading indicator
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final screenSize = ScreenSize(context);

    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
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
        actions: [
          IconButton(
            onPressed: () {
              refresh();
            },
            icon: Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(userData.currentUser!.name),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ssid,
                          style: GoogleFonts.epilogue(
                              fontSize: w * 0.04, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentSSID!,
                          style: GoogleFonts.epilogue(fontSize: w * 0.03),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeCredentialsPage(
                              esp32Url: esp32Url,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    )
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      final deviceId = device['id'];
                      final isOn = device['status'] == 1;
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(
                            isOn ? Icons.toggle_on : Icons.toggle_off,
                            size: 36,
                            color: isOn ? Colors.green : Colors.grey,
                          ),
                          title: Text('Device $deviceId'),
                          subtitle: Text(isOn ? 'Status: ON' : 'Status: OFF'),
                          trailing: ElevatedButton(
                            onPressed: () => toggleDevice(deviceId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  isOn ? Colors.green : Colors.grey,
                            ),
                            child: const Text('Toggle'),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: resetDevices,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset All Devices'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: fetchStatus,
                  icon: const Icon(Icons.sync),
                  label: const Text('Refresh Status'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
              ],
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
