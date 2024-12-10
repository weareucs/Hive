import 'package:demo_ucs/screens/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChangeCredentialsPage extends StatefulWidget {
  final String esp32Url;

  const ChangeCredentialsPage({Key? key, required this.esp32Url})
      : super(key: key);

  @override
  _ChangeCredentialsPageState createState() => _ChangeCredentialsPageState();
}

class _ChangeCredentialsPageState extends State<ChangeCredentialsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> updateCredentials() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${widget.esp32Url}/updateCredentials'),
        body: {
          'ssid': _ssidController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        showMessage('Credentials updated successfully!');
      } else {
        showMessage('Failed to update credentials: ${response.body}');
      }
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const ESP32ControllerApp()));
    } catch (e) {
      showMessage('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Hotspot Credentials'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _ssidController,
                    decoration: const InputDecoration(labelText: 'New SSID'),
                    validator: (value) =>
                        value!.isEmpty ? 'SSID is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) => value!.length < 8
                        ? 'Password must be at least 8 characters'
                        : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: updateCredentials,
                    icon: const Icon(Icons.save),
                    label: const Text('Update'),
                  ),
                ],
              ),
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
