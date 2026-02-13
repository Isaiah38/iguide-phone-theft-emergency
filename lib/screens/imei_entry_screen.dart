import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'emergency_steps_screen.dart';

class IMEIEntryScreen extends StatefulWidget {
  const IMEIEntryScreen({super.key});

  @override
  State<IMEIEntryScreen> createState() => _IMEIEntryScreenState();
}

class _IMEIEntryScreenState extends State<IMEIEntryScreen> {
  final StorageService _storageService = StorageService();
  final TextEditingController _imeiController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final imei = await _storageService.getIMEI();
    final details = await _storageService.getPhoneDetails();
    setState(() {
      _imeiController.text = imei ?? '';
      _detailsController.text = details ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await _storageService.saveIMEI(_imeiController.text);
    await _storageService.savePhoneDetails(_detailsController.text);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Details saved successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _imeiController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EmergencyStepsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Card(
                color: Colors.amberAccent,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'IMPORTANT: Keep these details safe. You will need them to report your phone as stolen.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _imeiController,
                decoration: const InputDecoration(
                  labelText: 'IMEI Number',
                  border: OutlineInputBorder(),
                  helperText: 'Dial *#06# on your phone to find your IMEI',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Phone Model & Other Details',
                  border: OutlineInputBorder(),
                  hintText: 'e.g. iPhone 13, Space Gray, 128GB',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveData,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Save Details'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EmergencyStepsScreen(),
                    ),
                  );
                },
                child: const Text('What to do after theft? ->'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
