import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleUserInfo {
  final String id;
  final String email;
  final String name;
  final String picture;

  GoogleUserInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
  });

  factory GoogleUserInfo.fromJson(Map<String, dynamic> json) {
    return GoogleUserInfo(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
    );
  }
}

Future<Map<String, dynamic>?> fetchGoogleUserInfo(String idToken) async {
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/oauth2/v3/userinfo'),
    headers: {'Authorization': 'Bearer $idToken'},
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Failed to fetch user info: ${response.statusCode}');
    return null;
  }
}
