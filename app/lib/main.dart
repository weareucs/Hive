import 'package:demo_ucs/ChangeCredentialsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() {
  runApp(const ESP32ControllerApp());
}

class ESP32ControllerApp extends StatefulWidget {
  const ESP32ControllerApp({Key? key}) : super(key: key);

  @override
  _ESP32ControllerAppState createState() => _ESP32ControllerAppState();
}

class _ESP32ControllerAppState extends State<ESP32ControllerApp> {
  String esp32Url = 'http://192.168.4.1'; // Default URL (placeholder)
  Map<int, bool> deviceStatus = {1: false, 2: false, 3: false, 4: false};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeEsp32Url();
    fetchStatus();
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
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$esp32Url/status'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          for (var device in data['devices']) {
            deviceStatus[device['id']] = device['status'] == 1;
          }
        });
      } else {
        showError('Failed to fetch device status');
      }
    } catch (e) {
      showError('Error: $e');
    } finally {
      setState(() => isLoading = false);
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
    return MaterialApp(
      title: 'ESP32 Controller',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ESP32 Device Controller'),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: deviceStatus.keys.length,
                      itemBuilder: (context, index) {
                        final deviceId = deviceStatus.keys.elementAt(index);
                        final isOn = deviceStatus[deviceId] ?? false;
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
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: fetchStatus,
                    icon: const Icon(Icons.sync),
                    label: const Text('Refresh Status'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChangeCredentialsPage(esp32Url: esp32Url),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Update",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      );
                    },
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
      ),
    );
  }
}
