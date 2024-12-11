#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <WiFiUdp.h>
#include <Preferences.h>

// Default Hotspot credentials
const char *defaultSSID = "ESP32_Hotspot";
const char *defaultPassword = "12345678";

// Current Hotspot credentials
String ssid;
String password;

// Preferences for storing credentials persistently
Preferences preferences;

// UDP settings
WiFiUDP udp;
const int udpPort = 4210;

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);
AsyncEventSource events("/events");

// Structure to represent a device
struct Device {
  const int id;
  const int pin;
  int status; // 0: off, 1: on
  String name; // Name of the device
};


// Initialize devices
Device d1 = {1, 16, 0, "Switch 1"};
Device d2 = {2, 17, 0, "Switch 2"};
Device d3 = {3, 18, 0, "Switch 3"};
Device d4 = {4, 19, 0, "Switch 4"}; 

void saveDeviceName(int id, const String &name) {
    String key = "name" + String(id);
    preferences.putString(key.c_str(), name);
}

void loadDeviceNames() {
    d1.name = preferences.getString("name1", "Switch 1");
    d2.name = preferences.getString("name2", "Switch 2");
    d3.name = preferences.getString("name3", "Switch 3");
    d4.name = preferences.getString("name4", "Switch 4");
}


// LED to indicate connection status
const int statusLedPin = 21; // Change pin number based on your setup
bool isClientConnected = false;

// Function declarations
void toggleDevice(Device *d);
void resetAll();
String getStatusJson();
void handleUDPDiscovery();
void checkClientConnection();

void setup() {
  Serial.begin(115200);

  // Initialize Preferences
  preferences.begin("hotspot", false);
  preferences.begin("device_names", false);
  loadDeviceNames();

  // Load saved credentials or use default ones
  ssid = preferences.getString("ssid", defaultSSID);
  password = preferences.getString("password", defaultPassword);

  // Start the ESP32 in Access Point mode
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid.c_str(), password.c_str());
  Serial.printf("Hotspot started with SSID: %s and Password: %s\n", ssid.c_str(), password.c_str());
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());

  // Set pin modes and initialize from hardware state
  pinMode(d1.pin, OUTPUT);
  pinMode(d2.pin, OUTPUT);
  pinMode(d3.pin, OUTPUT);
  pinMode(d4.pin, OUTPUT);

  // Initialize status LED pin
  pinMode(statusLedPin, OUTPUT);
  digitalWrite(statusLedPin, LOW);

  // Start UDP listener for discovery
  udp.begin(udpPort);
  Serial.println("UDP listener started");

  // Start the HTTP server
  server.addHandler(&events);

  // Handle toggle requests
  server.on("/toggle", HTTP_GET, [](AsyncWebServerRequest *request) {
    if (request->hasParam("button_id")) {
      int idValue = request->getParam("button_id")->value().toInt();
      if (idValue == d1.id) toggleDevice(&d1);
      if (idValue == d2.id) toggleDevice(&d2);
      if (idValue == d3.id) toggleDevice(&d3);
      if (idValue == d4.id) toggleDevice(&d4);
      request->send(200, "text/plain", "Toggled");
    } else {
      request->send(400, "text/plain", "Missing button_id");
    }
  });

  server.on("/updateName", HTTP_POST, [](AsyncWebServerRequest *request) {
        if (request->hasParam("id", true) && request->hasParam("name", true)) {
            int id = request->getParam("id", true)->value().toInt();
            String name = request->getParam("name", true)->value();

            if (id == d1.id) { d1.name = name; saveDeviceName(d1.id, name); }
            if (id == d2.id) { d2.name = name; saveDeviceName(d2.id, name); }
            if (id == d3.id) { d3.name = name; saveDeviceName(d3.id, name); }
            if (id == d4.id) { d4.name = name; saveDeviceName(d4.id, name); }

            request->send(200, "text/plain", "Name updated successfully");
        } else {
            request->send(400, "text/plain", "Missing id or name");
        }
    });


  // Endpoint to update the hotspot credentials
  server.on("/updateCredentials", HTTP_POST, [](AsyncWebServerRequest *request) {
    if (request->hasParam("ssid", true) && request->hasParam("password", true)) {
      String newSSID = request->getParam("ssid", true)->value();
      String newPassword = request->getParam("password", true)->value();

      // Save new credentials to Preferences
      preferences.putString("ssid", newSSID);
      preferences.putString("password", newPassword);
      preferences.end(); // Ensure changes are saved and Preferences is closed

      // Restart AP with new credentials
      WiFi.softAP(newSSID.c_str(), newPassword.c_str());
      ssid = newSSID;
      password = newPassword;

      Serial.printf("Updated SSID: %s, Password: %s\n", ssid.c_str(), password.c_str());
      request->send(200, "text/plain", "Credentials updated successfully. Reconnect to the new network.");
    } else {
      request->send(400, "text/plain", "Missing ssid or password");
    }
  });

  // Handle reset request
  server.on("/reset", HTTP_GET, [](AsyncWebServerRequest *request) {
    resetAll();
    request->send(200, "text/plain", "All LEDs reset");
  });

  // Handle status request
  server.on("/status", HTTP_GET, [](AsyncWebServerRequest *request) {
    String statusJson = getStatusJson();
    request->send(200, "application/json", statusJson);
  });

  server.begin();
  Serial.println("HTTP server started");
}

void loop() {
  handleUDPDiscovery();
  checkClientConnection();
}

// Function to handle UDP discovery
void handleUDPDiscovery() {
  int packetSize = udp.parsePacket();
  if (packetSize) {
    char incomingPacket[255];
    int len = udp.read(incomingPacket, sizeof(incomingPacket));
    if (len > 0) {
      incomingPacket[len] = '\0';
    }
    Serial.printf("Received UDP packet: %s\n", incomingPacket);

    if (String(incomingPacket) == "DISCOVER_ESP32") {
      udp.beginPacket(udp.remoteIP(), udp.remotePort());
      udp.print(WiFi.softAPIP().toString());
      udp.endPacket();
      Serial.println("Sent IP address to client");
    }
  }
}

// Function to check if any client is connected to the hotspot
void checkClientConnection() {
  if (WiFi.softAPgetStationNum() > 0) {
    if (!isClientConnected) {
      Serial.println("Client connected to the hotspot.");
      isClientConnected = true;
      digitalWrite(statusLedPin, HIGH); // Turn LED ON when connected
    }
  } else {
    if (isClientConnected) {
      Serial.println("Client disconnected from the hotspot.");
      isClientConnected = false;
    }
    // Blink LED if no client is connected
    static unsigned long lastBlinkTime = 0;
    if (millis() - lastBlinkTime >= 500) {
      digitalWrite(statusLedPin, !digitalRead(statusLedPin));
      lastBlinkTime = millis();
    }
  }
}

void toggleDevice(Device *d) {
  d->status = !d->status;
  digitalWrite(d->pin, d->status == 1 ? HIGH : LOW);
  char data[100];
  snprintf(data, sizeof(data), "{\"id\":%d, \"status\":%d}", d->id, d->status);
  events.send(data, "toggleState", millis());
}

void resetAll() {
  if (d1.status == 1) toggleDevice(&d1);
  if (d2.status == 1) toggleDevice(&d2);
  if (d3.status == 1) toggleDevice  (&d3);
  if (d4.status == 1) toggleDevice(&d4);
}

String getStatusJson() {
    char data[500];
    snprintf(data, sizeof(data),
             "{\"ssid\":\"%s\",\"devices\":[{\"id\":1,\"name\":\"%s\",\"status\":%d},{\"id\":2,\"name\":\"%s\",\"status\":%d},{\"id\":3,\"name\":\"%s\",\"status\":%d},{\"id\":4,\"name\":\"%s\",\"status\":%d}]}",
             ssid.c_str(), d1.name.c_str(), d1.status, d2.name.c_str(), d2.status,
             d3.name.c_str(), d3.status, d4.name.c_str(), d4.status);
    return String(data);
}