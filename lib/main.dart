import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'widgets/pin_lock_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iGuide - Phone Theft Emergency Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      // Wrap the app with PinLockScreen to handle security
      home: const PinLockScreen(child: SplashScreen()),
    );
  }
}
