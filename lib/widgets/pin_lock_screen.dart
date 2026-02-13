import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class PinLockScreen extends StatefulWidget {
  final Widget child;
  const PinLockScreen({super.key, required this.child});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _pinController = TextEditingController();
  bool _isLocked = true;
  String? _savedPin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    _savedPin = await _storageService.getPIN();
    if (_savedPin == null || _savedPin!.isEmpty) {
      setState(() {
        _isLocked = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _unlock() {
    if (_pinController.text == _savedPin) {
      setState(() {
        _isLocked = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Incorrect PIN')));
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_isLocked) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock, size: 80, color: Colors.amberAccent),
              const SizedBox(height: 20),
              const Text(
                'iGuide Locked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Enter your 4-digit PIN to continue',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 10),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _unlock,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 50),
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
