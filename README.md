# 🚀 AI-Powered Lending Bot using Flutter, GenUI & Gemini 2.5 Pro

This project is an **AI-driven Lending Assistant** built using **Flutter**, **GenUI (Generative UI)**, and **Google Gemini 2.5 Pro via Firebase AI**.  
The bot dynamically renders UI components using **A2UI tool calls** and guides the user through a complete loan application flow.

---

## 🎯 Features

- 🧠 AI-powered lending conversation
- CIF ID validation
- Customer details preview
- Loan product selection (Home, Car, Personal)
- Bureau score simulation
- Adjustable loan parameters using sliders
- Loan application submission
- Fully dynamic GenUI surfaces
- Firebase AI + Gemini 2.5 Integrated

---

## 🧰 Tech Stack

### **Framework**

- Flutter 3.22+
- Dart 3.x

### **AI / GenUI**

- GenUI 0.5.1
- GenUI Firebase AI Adapter
- Google Gemini 2.5 Pro or Flash (via Firebase AI)

## 🔧 **Firebase Setup (Flutter)**

This project uses **Firebase AI + Gemini 2.5 Pro** for all generative responses.

### 1️. Add Firebase to your Flutter app  
Follow official docs:  
https://firebase.google.com/docs/flutter/setup

### 2️. Install Firebase CLI and run the below commands to keep connect with firebase 
```bash
npm install -g firebase-tools
dart pub global activate flutterfire_cli
firebase login
firebase init
flutterfire configure
```
After the above commands need to select a firebase project from the flutter project's directory that will automatically add a firebaseoptions.dart file inside the 'lib' folder.

### 3. **Dependencies (pubspec.yaml)**

```yaml
dependencies:
  flutter:
    sdk: flutter
  genui: ^0.5.1 # To use a generative UI Feature
  genui_firebase_ai: ^0.5.1 #To connect the genUI with firebase AI
  json_schema_builder: ^0.1.3 #To create a custom catalog item
  firebase_ai: ^0.1.0  #required for using firebase ai
  firebase_core: ^3.6.0 #required for firebase core setup
```
### 4. **Make sure to initialize a Firebase in Main.dart file**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```

## 📁 Folder Structure

lib/
│
├── widgets/
│ ├── bot_message.dart
│ ├── user_message.dart
│ ├── bureau_card.dart
│ ├── customer_details_card.dart
│ ├── choose_loan_product_card.dart
│ ├── set_loan_details_card.dart
│
├── schemas/
│ ├── message_schema.dart
│ ├── bureau_schema.dart
│ ├── customer_schema.dart
│ ├── loanprod_schema.dart
│ ├── loandetails_schema.dart
│
├── main.dart
└── home.dart (GenUI setup + Conversation Engine)

## 🛠 Installation

### 1. Clone the repository
```bash
git clone https://github.com/SheikMohideen007/AI-Powered-Lending-Bot-using-Flutter-GenUI-GenAI.git
cd AI-Powered-Lending-Bot-using-Flutter-GenUI-GenAI
```
### 2. Install dependencies
```bash
flutter pub get
```
### 3. Install dependencies
```bash
flutter run
```

⭐ Contribute

Feel free to open issues or PRs if you want to enhance the bot or extend its UI logic.
