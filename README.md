# iGuide - Phone Theft Emergency Guide App

iGuide is a simple but powerful mobile application designed to help users prepare for and manage phone theft emergencies. It allows users to store critical phone information securely and provides a clear guide on the steps to take if their phone is stolen.

## Key Features

- **Store IMEI and Phone Details**: Keep your phone's unique identification number and description safe within the app.
- **Emergency Steps Guide**: A step-by-step checklist of what to do immediately after a theft.
- **Emergency Contacts**: Store names and numbers of people to contact in an emergency.
- **Export to Email**: Easily export your IMEI, phone details, and emergency contacts to an email address for safe keeping.
- **PIN Lock**: Secure the app with a 4-digit PIN to prevent unauthorized access to your stored information.

## Folder Structure

- `lib/main.dart`: Entry point of the app, handles theme and root widget.
- `lib/screens/`: Contains all the app screens.
  - `splash_screen.dart`: Animated entry screen.
  - `imei_entry_screen.dart`: Storage for phone identification details.
  - `emergency_steps_screen.dart`: Informational guide for theft recovery.
  - `contacts_screen.dart`: Management of emergency numbers and export feature.
  - `settings_screen.dart`: Security settings for PIN lock.
- `lib/services/`:
  - `storage_service.dart`: Handles local data persistence using `shared_preferences`.
- `lib/widgets/`:
  - `pin_lock_screen.dart`: Security wrapper to lock the app.

## Installation Steps

1.  Ensure you have [Flutter](https://docs.flutter.dev/get-started/install) installed on your machine.
2.  Clone this repository or download the source code.
3.  Navigate to the project directory:
    ```bash
    cd iguide
    ```
4.  Install dependencies:
    ```bash
    flutter pub get
    ```

## How to Run the App

- To run on a connected device or emulator:
  ```bash
  flutter run
  ```
- To build for Android:
  ```bash
  flutter build apk
  ```
- To build for iOS:
  ```bash
  flutter build ios
  ```

## Security Note

The PIN lock feature provides a layer of security within the app. However, it is always recommended to use system-level locks (biometrics, passcodes) on your mobile device for maximum protection.
