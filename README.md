# Elaros - Mobile Health Application

**Figma Design:** https://www.figma.com/design/RLXFKz5XpCqOszv0DccnJs/Untitled?node-id=0-1&t=ZZKUOqnthqXHwHb0-1

---

## Project Overview

Elaros is a mobile application built with Flutter that provides meaningful, user-friendly insights from wearable device data. It is designed for individuals with energy-limiting conditions such as **Long Covid**, **ME/CFS**, and **Fibromyalgia**.

The app helps users manage exertion, pace their activity, and understand their physiological responses by visualising metrics like heart rate, heart rate variability (HRV), step count, sleep patterns, and personalised activity zones.

### Key Features

- **Authentication** - Secure login and signup with a multi-step registration flow (account credentials, personal information, health baseline)
- **Dashboard** - Daily snapshot showing current heart rate zone, key metrics (resting HR, steps, average HR, calories), heart rate trends, step charts, calorie charts, and sleep summary
- **Insights** - Weekly summaries, heart rate trends, and step trends displayed as interactive charts
- **Activity Zones** - Five personalised heart rate zones (Recovery, Sustainable, Caution, Risk, Overexertion) calculated from each user's resting and maximum heart rate
- **Profile Management** - View and edit personal information, health baseline, fitness goals, zone explanations, and privacy settings
- **Local Data Storage** - All health data stored locally on device using SQLite (no cloud dependency)
- **Accessibility** - Clean UI with colour-blind friendly options, large text, and minimal navigation for users with cognitive fatigue

---

## Tech Stack

- **Framework:** Flutter (Dart)
- **Database:** SQLite via `sqflite`
- **State Management:** Provider
- **Charts:** Cristalyse
- **Platforms:** Android & iOS

---

## Project Structure

```
lib/
  main.dart                          # App entry point
  app.dart                           # MaterialApp with auth routing
  data/local/
    model/                           # Data models (HeartRate, UserProfile, HRV, etc.)
    repository/                      # Repository layer
    services/
      database_helper.dart           # SQLite CRUD operations (16 tables)
      auth_service.dart              # Authentication logic
      health_data_service.dart       # Health data queries
  ui/
    auth/
      login_screen.dart              # Login page
      signup_screen.dart             # Multi-step signup
    home/wigets/
      home_screen.dart               # Main screen with bottom navigation
      Home_Page.dart                 # Dashboard / Today screen
      insights_screen.dart           # Trends and charts
      zones_screen.dart              # Activity zone explanations
      profile_screen.dart            # User profile management
    common/widgets/
      bottom_navbar.dart             # Bottom navigation bar
    core/graphs/                     # Chart widgets (bar, line, pie, etc.)
  utils/database/                    # Platform-specific DB helpers
assets/database/
  main.db                            # Writable app database (16 tables)
  health_lite.db                     # Read-only historical health dataset
```

---

## Prerequisites

- **Flutter SDK** (3.11.0 or higher) - [Install Flutter](https://docs.flutter.dev/get-started/install)
- **Android Studio** or **VS Code** with Flutter extensions
- **Xcode** (for iOS builds, Mac only)
- A physical device or emulator/simulator

---

## Getting Started

### 1. Clone the Repository
```bash
git clone git@github.com:Abdur765/Elaros-App.git
cd Elaros-App
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Verify Setup
```bash
flutter doctor
```
Make sure there are no critical issues for your target platform.

---

## Running on Android

### Using an Emulator
1. Open **Android Studio** -> **Virtual Device Manager**
2. Create a new virtual device (recommended: Pixel 7 with API 34)
3. Start the emulator
4. Run:
   ```bash
   flutter devices         # verify emulator is detected
   flutter run             # builds and launches on emulator
   ```

### Using a Physical Device (USB)
1. On your Android phone, go to **Settings -> About Phone**
2. Tap **Build Number** 7 times to enable Developer Mode
3. Go back to **Settings -> Developer Options**
4. Enable **USB Debugging**
5. Connect your phone to your computer via USB cable
6. Accept the USB debugging prompt on your phone
7. Run:
   ```bash
   flutter devices         # verify your phone appears
   flutter run             # builds and installs on your phone
   ```

### Using a Physical Device (Wireless - Android 11+)
1. Enable Developer Options and USB Debugging as above
2. Go to **Developer Options -> Wireless Debugging** and enable it
3. Tap **Pair device with pairing code**
4. Run:
   ```bash
   adb pair <ip>:<port>    # enter the pairing code when prompted
   adb connect <ip>:<port> # use the port shown under Wireless Debugging
   flutter run
   ```

### Building an APK
```bash
flutter build apk --debug
```
The APK will be at `build/app/outputs/flutter-apk/app-debug.apk`. Transfer it to your phone and install.

---

## Running on iOS

### Using the iOS Simulator (Mac only)
1. Install **Xcode** from the Mac App Store
2. Open Xcode -> **Settings -> Platforms** -> install iOS Simulator
3. Run:
   ```bash
   open -a Simulator       # launch iOS Simulator
   flutter pub get
   cd ios && pod install && cd ..
   flutter run
   ```

### Using a Physical iPhone (USB)
1. Connect your iPhone to your Mac via USB/Lightning cable
2. On your iPhone, go to **Settings -> Privacy & Security -> Developer Mode** and enable it
3. Trust the computer when prompted on your iPhone
4. Open the project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```
5. In Xcode, select your iPhone as the run destination
6. Go to **Runner -> Signing & Capabilities** and select your Apple Developer Team
7. Run from terminal:
   ```bash
   flutter run
   ```

### Building for iOS
```bash
flutter build ios
```

> **Note:** iOS builds require a Mac with Xcode installed. You need an Apple Developer account (free or paid) for device testing. The free account allows testing on your own devices for 7 days.

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| provider | ^6.1.5+1 | State management |
| sqflite | ^2.4.2 | SQLite database |
| path_provider | ^2.1.5 | File system paths |
| path | ^1.9.1 | Path manipulation |
| cristalyse | ^1.17.3 | Chart visualisations |
| crypto | ^3.0.6 | Password hashing |
| shared_preferences | ^2.3.4 | Session persistence |
| navbar_router | ^0.7.7 | Navigation |
| sqflite_common_ffi_web | ^1.1.1 | Web database support |
| cupertino_icons | ^1.0.8 | iOS-style icons |
