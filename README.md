# Hive: Your Smart Home Solution

Hive is an innovative project that enables you to control home appliances, whether smart or not, using a mobile application. It combines the power of a Flutter-based application and Arduino hardware to bring smart functionality to every corner of your home.

---

## 📁 Repository Structure

This repository contains the following directories:
- **`mark-I`**: Arduino code written in `.ino` format to manage the hardware functionalities.
- **`app`**: A Flutter application that serves as the user interface for controlling the appliances.

---

## 🔧 Features

- **Universal Control**: Manage both smart and non-smart appliances using the Hive application.
- **Intuitive UI**: Flutter app designed for seamless user experience.
- **Hardware Integration**: Arduino-powered system for reliable performance.
- **Smart Home Ready**: Make your home smarter without replacing existing appliances.

---

## 🚀 Getting Started

### 1. Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Arduino IDE ([Download Here](https://www.arduino.cc/en/software))
- Basic hardware setup with Arduino, relays, and appliances.

---

### 2. Setting Up the Application
1. Navigate to the `app` folder.
2. Run the following commands:
    ```bash
    flutter pub get
    flutter run
    ```
3. Ensure the app is connected to the correct network and linked to the Arduino setup.

---

### 3. Setting Up the Hardware
1. Open the `mark-I` folder in Arduino IDE.
2. Connect your Arduino board and upload the `.ino` file.
3. Ensure the relays and appliances are connected as per the circuit diagram.

---

## 📚 How It Works
1. The mobile application communicates with the Arduino system over Wi-Fi or Bluetooth.
2. The Arduino receives commands to toggle relays connected to the appliances.
3. Appliances can be turned ON or OFF from anywhere via the app.

---

## 🛠️ Tools and Technologies
- **Flutter**: For building the mobile application.
- **Arduino**: For hardware integration and appliance control.
- **Relays**: To manage the appliances.

---

## 🤝 Contribution
Contributions are welcome!  
Feel free to fork this repository, make changes, and create a pull request.

---

## 📜 License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## 💬 Contact
For any questions or feedback, please reach out at weareucs.solutions@gmail.com

