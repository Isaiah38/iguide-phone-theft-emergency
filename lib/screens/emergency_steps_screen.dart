import 'package:flutter/material.dart';
import 'contacts_screen.dart';

class EmergencyStepsScreen extends StatelessWidget {
  const EmergencyStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Steps')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStep(
            '1',
            'Call your network provider',
            'Immediately block your SIM card to prevent unauthorized calls and data usage.',
            Icons.sim_card_alert,
          ),
          _buildStep(
            '2',
            'Report to the Police',
            'Provide them with your IMEI number. You will need a police report for insurance claims.',
            Icons.local_police,
          ),
          _buildStep(
            '3',
            'Lock your phone remotely',
            'Use "Find My Device" (Android) or "Find My" (iOS) to lock or wipe your phone.',
            Icons.phonelink_erase,
          ),
          _buildStep(
            '4',
            'Change your passwords',
            'Update passwords for your email, bank, and social media accounts.',
            Icons.password,
          ),
          _buildStep(
            '5',
            'Inform your bank',
            'If you have mobile banking, ask them to disable the app on your stolen device.',
            Icons.account_balance,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ContactsScreen()),
              );
            },
            icon: const Icon(Icons.contact_phone),
            label: const Text('View Emergency Contacts'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(15),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(
    String number,
    String title,
    String description,
    IconData icon,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          child: Text(number, style: const TextStyle(color: Colors.white)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: Icon(icon, color: Colors.blueAccent.withOpacity(0.5)),
      ),
    );
  }
}
