import 'package:shared_preferences/shared_preferences.dart';

class TenantConfig {
  final String id;
  final String name;
  final String address;
  final String grade;
  final String phone;
  final String email;
  final String website;
  final String schoolCode;

  TenantConfig({
    required this.id,
    required this.name,
    required this.address,
    required this.grade,
    required this.phone,
    required this.email,
    required this.website,
    required this.schoolCode,
  });

  // Factory constructor to parse JSON
  factory TenantConfig.fromJson(Map<String, dynamic> json) {
    return TenantConfig(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      grade: json['grade'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      schoolCode: json['schoolCode'],
    );
  }
}

Future<void> saveTenantConfig(TenantConfig config) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('schoolName', config.name);
}

Future<TenantConfig> getTenantConfig() async {
  final prefs = await SharedPreferences.getInstance();
  return TenantConfig(
    id: prefs.getString('id') ?? '',
    name: prefs.getString('name') ?? '',
    address: prefs.getString('address') ?? 'Welwyn Garden City',
    phone: prefs.getString('phone') ?? '',
    grade: prefs.getString('grade') ?? '',
    email: prefs.getString('email') ?? '',
    website: prefs.getString('website') ?? '',
    schoolCode: prefs.getString('schoolCode') ?? '',
  );
}
