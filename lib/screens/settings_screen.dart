import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _pinController = TextEditingController();
  bool _isPinSet = false;

  @override
  void initState() {
    super.initState();
    _checkPin();
  }

  Future<void> _checkPin() async {
    final pin = await _storageService.getPIN();
    setState(() {
      _isPinSet = pin != null && pin.isNotEmpty;
    });
  }

  Future<void> _savePin() async {
    if (_pinController.text.length == 4) {
      await _storageService.savePIN(_pinController.text);
      _pinController.clear();
      _checkPin();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN saved successfully!')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('PIN must be 4 digits')));
      }
    }
  }

  Future<void> _clearPin() async {
    await _storageService.savePIN('');
    _checkPin();
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('PIN removed')));
    }
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Security',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text('App Lock (PIN)'),
              subtitle: Text(
                _isPinSet ? 'Status: ENABLED' : 'Status: DISABLED',
              ),
              trailing: _isPinSet
                  ? TextButton(
                      onPressed: _clearPin,
                      child: const Text(
                        'Disable',
                        style: TextStyle(color: Colors.red),
                      ),
                    )
                  : null,
            ),
            if (!_isPinSet) ...[
              const SizedBox(height: 20),
              TextField(
                controller: _pinController,
                decoration: const InputDecoration(
                  labelText: 'Set 4-digit PIN',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _savePin,
                child: const Text('Enable PIN Lock'),
              ),
            ],
            const Spacer(),
            const Center(
              child: Text(
                'iGuide v1.0.0',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
