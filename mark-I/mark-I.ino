#include <WiFi.h>
#include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>
#include <ESPmDNS.h>
#include <WiFiUdp.h>

// Hotspot credentials
const char *ssid = "ESP32_Hotspot";
const char *password = "12345678";

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
};

// Initialize devices
Device d1 = {1, 16, 0};
Device d2 = {2, 17, 0};
Device d3 = {3, 18, 0};
Device d4 = {4, 19, 0};

// Function declarations
void toggleDevice(Device *d);
void resetAll();
String getStatusJson();
void sendInitialStatus();
void handleUDPDiscovery();

void setup() {
  Serial.begin(115200);

  // Set pin modes and initialize from hardware state
  pinMode(d1.pin, OUTPUT);
  pinMode(d2.pin, OUTPUT);
  pinMode(d3.pin, OUTPUT);
  pinMode(d4.pin, OUTPUT);

  // Start the ESP32 in Access Point mode
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ssid, password);
  Serial.println("Hotspot started!");
  Serial.print("IP Address: ");
  Serial.println(WiFi.softAPIP());

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

  // Endpoint to update the hotspot credentials
server.on("/updateCredentials", HTTP_POST, [](AsyncWebServerRequest *request) {
  if (request->hasParam("ssid", true) && request->hasParam("password", true)) {
    String newSSID = request->getParam("ssid", true)->value();
    String newPassword = request->getParam("password", true)->value();

    // Restart AP with new credentials
    WiFi.softAP(newSSID.c_str(), newPassword.c_str());
    ssid = newSSID.c_str();
    password = newPassword.c_str();

    Serial.printf("Hotspot credentials updated! New SSID: %s, New Password: %s\n", ssid, password);
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
  if (d3.status == 1) toggleDevice(&d3);
  if (d4.status == 1) toggleDevice(&d4);
}

String getStatusJson() {
  char data[200];
  snprintf(data, sizeof(data),
           "{\"devices\":[{\"id\":1,\"status\":%d},{\"id\":2,\"status\":%d},{\"id\":3,\"status\":%d},{\"id\":4,\"status\":%d}]}",
           d1.status, d2.status, d3.status, d4.status);
  return String(data);
}
