import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _imeiKey = 'imei';
  static const String _detailsKey = 'phone_details';
  static const String _pinKey = 'app_pin';
  static const String _contactsKey = 'emergency_contacts';

  // Get IMEI
  Future<String?> getIMEI() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_imeiKey);
  }

  // Save IMEI
  Future<void> saveIMEI(String imei) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imeiKey, imei);
  }

  // Get Phone Details
  Future<String?> getPhoneDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_detailsKey);
  }

  // Save Phone Details
  Future<void> savePhoneDetails(String details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_detailsKey, details);
  }

  // Get PIN
  Future<String?> getPIN() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  // Save PIN
  Future<void> savePIN(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
  }

  // Get Contacts (as a simple string for this MVP or JSON)
  Future<List<String>> getContacts() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_contactsKey) ?? [];
  }

  // Save Contacts
  Future<void> saveContacts(List<String> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_contactsKey, contacts);
  }
}
