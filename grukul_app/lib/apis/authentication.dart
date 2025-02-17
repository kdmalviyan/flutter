import 'package:http/http.dart' as http;

Future<void> login(String username, String password, String apiEndpoint) async {
  final response = await http.post(
    Uri.parse('$apiEndpoint/login'),
    body: {'username': username, 'password': password},
  );
  if (response.statusCode == 200) {
    // Navigate to home screen
  } else {
    throw Exception('Login failed');
  }
}
