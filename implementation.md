# iGuide Implementation Guide

This guide provides a comprehensive walkthrough of the iGuide project, from environment setup to core module architecture.

## Visual Overview

<p align="center">
  <img src="assets/Screenshot_20260214-024721.png" width="150" alt="Splash">
  <img src="assets/Screenshot_20260214-194309.png" width="150" alt="IMEI Entry">
  <img src="assets/Screenshot_20260214-194326.png" width="150" alt="Emergency Steps">
  <img src="assets/Screenshot_20260214-194337.png" width="150" alt="Contacts">
  <img src="assets/Screenshot_20260214-194346.png" width="150" alt="Settings">
</p>

Follow these steps to rebuild or extend the application.

## 1. Development Environment Setup

### Tools & Requirements

- **Flutter SDK**: `^3.10.7` (Current version used in development).
- **Dart SDK**: Extracted from the Flutter bundle.
- **IDE**: VS Code or Android Studio with Flutter/Dart plugins installed.
- **Development OS**: Windows (used during implementation).

### Initializing the Project

1. Create a new Flutter project:
   ```bash
   flutter create iguide
   ```
2. Update `pubspec.yaml` with required dependencies:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     cupertino_icons: ^1.0.8
     shared_preferences: ^2.2.2
     url_launcher: ^6.2.1
     path_provider: ^2.1.1

   dev_dependencies:
     flutter_test:
       sdk: flutter
     flutter_lints: ^3.0.0
     flutter_launcher_icons: ^0.13.1
     flutter_native_splash: ^2.3.13
   ```

3. Run `flutter pub get` to install tools.

---

## 2. Project Structure

The project follows a clean separation of concerns:

```text
lib/
├── main.dart                 # App entry point & theme configuration
├── screens/                  # UI Screens (Pages)
│   ├── splash_screen.dart    # Animated intro
│   ├── imei_entry_screen.dart # Data entry for phone details
│   ├── emergency_steps.dart   # Informational checklist
│   ├── contacts_screen.dart   # Management & Export
│   └── settings_screen.dart   # Security & PIN config
├── services/                 # Business logic & Persistence
│   └── storage_service.dart   # Shared Preferences wrapper
└── widgets/                  # Reusable components
    └── pin_lock_screen.dart   # Security overlay logic
```

---

## 3. Core Modules & Implementation

### A. Data Persistence (`storage_service.dart`)

Uses the `shared_preferences` package to store small amounts of data locally.

- **Key Logic**: Every screen that requires data access interacts with the `StorageService` class, which handles `get` and `save` operations for IMEI, Phone Details, PIN, and Contacts.

### B. Security & PIN Lock (`pin_lock_screen.dart`)

Instead of locking individual screens, we use a **Wrapper Pattern**:

- A `PinLockScreen` widget listens to app lifecycle events.
- If the app is resumed or a PIN is required, it overlays a numeric keypad over the current navigation stack.
- This ensures that sensitive data (like IMEI) is never visible without authorization.

### C. Splash Screen & Navigation Flow

- **Splash**: A simple `StatefulWidget` using `Timer` to navigate to the next screen after 2-3 seconds.
- **Flow**: `Splash` → `IMEI Entry` (if empty) or `Emergency Steps` (if data exists).

### D. Emergency Contacts & Export

- Located in `contacts_screen.dart`.
- Uses `url_launcher` to trigger external email apps.
- **Implementation**: It gathers all stored strings (IMEI, Contacts) and formats them into a `mailto:` URI.

---

## 4. Branding & Customization

### App Icon Generation

We use `flutter_launcher_icons`. To update:

1. Place a new image at `assets/app_icon.png`.
2. Configure `pubspec.yaml` with `flutter_launcher_icons` block.
3. Run:
   ```bash
   dart run flutter_launcher_icons:main
   ```

### Splash Screen Update

1. Configure `flutter_native_splash` in `pubspec.yaml`.
2. Run:
   ```bash
   dart run flutter_native_splash:create
   ```

---

## 5. Storage Summary Table

| Data Type | Key Name             | Format            | Store Method    |
| --------- | -------------------- | ----------------- | --------------- |
| IMEI      | `imei`               | String            | `setString`     |
| Details   | `phone_details`      | String            | `setString`     |
| PIN       | `app_pin`            | String (4 digits) | `setString`     |
| Contacts  | `emergency_contacts` | List<String>      | `setStringList` |

---

> [!IMPORTANT]
> To avoid caching issues during branding updates, always run `flutter clean` before building a release APK.
