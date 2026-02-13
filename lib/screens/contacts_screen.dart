import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/storage_service.dart';
import 'settings_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final StorageService _storageService = StorageService();
  final List<String> _contacts = [];
  final TextEditingController _contactController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final savedContacts = await _storageService.getContacts();
    setState(() {
      _contacts.addAll(savedContacts);
      _isLoading = false;
    });
  }

  Future<void> _addContact() async {
    if (_contactController.text.isNotEmpty) {
      setState(() {
        _contacts.add(_contactController.text);
        _contactController.clear();
      });
      await _storageService.saveContacts(_contacts);
    }
  }

  Future<void> _removeContact(int index) async {
    setState(() {
      _contacts.removeAt(index);
    });
    await _storageService.saveContacts(_contacts);
  }

  Future<void> _exportToEmail() async {
    final imei = await _storageService.getIMEI() ?? 'Not provided';
    final details = await _storageService.getPhoneDetails() ?? 'Not provided';

    String body = 'Phone Theft Emergency Details:\n\n';
    body += 'IMEI: $imei\n';
    body += 'Phone Details: $details\n\n';
    body += 'Emergency Contacts:\n';
    for (var contact in _contacts) {
      body += '- $contact\n';
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: '',
      query: encodeQueryParameters(<String, String>{
        'subject': 'My Phone Emergency Details',
        'body': body,
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open email app')),
        );
      }
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _contactController,
                          decoration: const InputDecoration(
                            hintText: 'Add name & number (e.g. Dad: 080...)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(
                          Icons.add_circle,
                          color: Colors.blueAccent,
                          size: 40,
                        ),
                        onPressed: _addContact,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _contacts.isEmpty
                      ? const Center(child: Text('No contacts added yet.'))
                      : ListView.builder(
                          itemCount: _contacts.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(_contacts[index]),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _removeContact(index),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    onPressed: _exportToEmail,
                    icon: const Icon(Icons.email),
                    label: const Text('Export Details to Email'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
