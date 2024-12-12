import 'dart:async';

import 'package:demo_ucs/ChangeCredentialsPage.dart';
import 'package:demo_ucs/components/loading/loading.dart';
import 'package:demo_ucs/constants/colors/colors.dart';
import 'package:demo_ucs/utils/screen_size.dart';
import 'package:enefty_icons/enefty_icons.dart';
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
    executeIfWifiConnected(() async {
      await _initializeEsp32Url();
      await fetchStatus();
      await fetchSSID();
    });
  }

  Future<bool> requestLocationPermissions() async {
    if (await Permission.location.isGranted) {
      return true;
    }

    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<void> fetchSSID() async {
    try {
      setState(() {
        isLoading = true;
      });
      bool hasPermission = await requestLocationPermissions();
      if (!hasPermission) {
        showError('Location permission is required to fetch Wi-Fi SSID');
        return;
      }

      final wifiInfo = NetworkInfo();
      String? ssid = await wifiInfo.getWifiIP().timeout(
            const Duration(seconds: 3),
            onTimeout: () => throw TimeoutException('No devices found'),
          );

      setState(() {
        currentSSID = ssid ?? 'Unknown SSID';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error fetching SSID: $e');
    }
  }

  Future<void> _initializeEsp32Url() async {
    try {
      setState(() {
        isLoading = true;
      });

      final List<NetworkInterface> interfaces =
          await NetworkInterface.list().timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('No devices found'),
      );

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
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error fetching device IP: $e');
    }
  }

  Future<void> fetchStatus() async {
    try {
      setState(() => isLoading = true);

      final response = await http.get(Uri.parse('$esp32Url/status')).timeout(
            const Duration(seconds: 3),
            onTimeout: () => throw TimeoutException('No devices found'),
          );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        String ssid = data['ssid'];

        setState(() {
          devices = List<Map<String, dynamic>>.from(data['devices']);
          this.ssid = ssid;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showError('Failed to fetch device status');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error: $e');
    }
  }

  Future<void> toggleDevice(int deviceId) async {
    try {
      setState(() => isLoading = true);

      final response = await http
          .get(Uri.parse('$esp32Url/toggle?button_id=$deviceId'))
          .timeout(
            const Duration(seconds: 3),
            onTimeout: () => throw TimeoutException('No devices found'),
          );

      if (response.statusCode == 200) {
        fetchStatus();
      } else {
        showError('Failed to toggle device $deviceId');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error: $e');
    }
  }

  Future<void> resetDevices() async {
    try {
      setState(() => isLoading = true);

      final response = await http.get(Uri.parse('$esp32Url/reset')).timeout(
            const Duration(seconds: 3),
            onTimeout: () => throw TimeoutException('No devices found'),
          );

      if (response.statusCode == 200) {
        fetchStatus();
      } else {
        showError('Failed to reset devices');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showError('Error: $e');
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

  Future<bool> isWifiConnected() async {
    try {
      final wifiInfo = NetworkInfo();
      final wifiName = await wifiInfo.getWifiBSSID();
      return wifiName != null && wifiName.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> executeIfWifiConnected(Function action) async {
    bool connected = await isWifiConnected();
    if (connected) {
      await action();
    } else {
      // showError('Please connect to Wi-Fi to continue.');
    }
  }

  Future<void> changeDeviceName(int id, String newName) async {
    try {
      final response = await http.post(
        Uri.parse('$esp32Url/updateName'),
        body: {"id": id.toString(), "name": newName},
      );
      if (response.statusCode == 200) {
        await fetchStatus();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Device name updated successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update device name')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> showRenameDialog(int id, String currentName) async {
    TextEditingController nameController =
        TextEditingController(text: currentName);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rename Device'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(
              labelText: 'New Device Name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                if (nameController.text.isNotEmpty) {
                  await changeDeviceName(id, nameController.text);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void refresh() {
    _initializeEsp32Url();
    fetchStatus();
    fetchSSID();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final screenSize = ScreenSize(context);
    return isLoading
        ? const Loading()
        : Scaffold(
            backgroundColor: white,
            body: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Smart Bees",
                      style: GoogleFonts.epilogue(
                        fontSize: screenSize.widthPercentage(7),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        refresh();
                      },
                      icon: const Icon(
                        EneftyIcons.rotate_left_outline,
                      ),
                    )
                  ],
                ),
                if (ssid.isEmpty)
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          EneftyIcons.slash_bold,
                          color: primary,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "No Smart Bee Connected.",
                          style: GoogleFonts.epilogue(),
                        )
                      ],
                    ),
                  ),
                if (ssid.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 70, bottom: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ssid,
                                  style: GoogleFonts.epilogue(
                                      fontSize: w * 0.05,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  currentSSID!,
                                  style:
                                      GoogleFonts.epilogue(fontSize: w * 0.03),
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
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Two items per row
                              crossAxisSpacing: 8.0, // Spacing between columns
                              mainAxisSpacing: 8.0, // Spacing between rows
                              childAspectRatio: 3 / 4,
                            ),
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final device = devices[index];
                              final deviceId = device['id'];
                              final isOn = device['status'] == 1;

                              return Card(
                                color: white,
                                margin: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        toggleDevice(deviceId);
                                      },
                                      child: Icon(
                                        !isOn
                                            ? Icons.toggle_on
                                            : Icons.toggle_off,
                                        size: 48,
                                        color: !isOn ? primary : Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(height: 8.0),
                                    Text(
                                      device['name'],
                                      style: GoogleFonts.epilogue(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      !isOn ? 'Status: ON' : 'Status: OFF',
                                      style: GoogleFonts.epilogue(
                                        color: grey,
                                      ),
                                    ),
                                    // const SizedBox(height: 8.0),
                                    // ElevatedButton(
                                    //   onPressed: () => toggleDevice(deviceId),
                                    //   style: ElevatedButton.styleFrom(
                                    //     backgroundColor:
                                    //         !isOn ? primary : white,
                                    //   ),
                                    //   child: Text(
                                    //     'Toggle',
                                    //     style: GoogleFonts.epilogue(
                                    //       color: !isOn ? white : black,
                                    //     ),
                                    //   ),
                                    // ),
                                    const SizedBox(height: 8.0),
                                    ElevatedButton(
                                      onPressed: () => showRenameDialog(
                                          deviceId, device['name']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primary,
                                      ),
                                      child: Text(
                                        'Rename',
                                        style:
                                            GoogleFonts.epilogue(color: white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Text(
                          "#ControlWithEase",
                          style: GoogleFonts.epilogue(
                            fontSize: screenSize.widthPercentage(8),
                            fontWeight: FontWeight.bold,
                            color: grey,
                          ),
                        ),
                        // ElevatedButton.icon(
                        //   onPressed: resetDevices,
                        //   icon: const Icon(
                        //     EneftyIcons.rotate_right_outline,
                        //     color: white,
                        //   ),
                        //   label: Text(
                        //     'Reset All Devices',
                        //     style: GoogleFonts.epilogue(color: white),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.red),
                        // ),
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
