import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_hk/app_state.dart';

class LoginRequest {
  final String username;
  final String password;
  LoginRequest({
    required this.username,
    required this.password,
  });
  static const String thunderAppHeader = 'JC-CORP-3.0.0';
  Map<String, String> get headers => {
        'thunderapp': 'JC-CORP-3.0.0',
        'Access-Control-Allow-Credentials': 'true',
        'Access-Control-Allow-Headers': '*',
      };
  Map<String, dynamic> get body => {
        'usr': username,
        'pwd': password,
      };
}

Future<Map<String, dynamic>> login(LoginRequest requestBody) async {
  final uri = Uri.parse('${AppState().domain}/api/method/login');
  final response = await http.post(
    uri,
    headers: requestBody.headers,
    body: requestBody.body,
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody['message'] == 'Logged In') {
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        AppState().update(() {
          AppState().cookieData = setCookie;
        });
      }
      return responseBody;
    } else {
      throw Exception(responseBody['message'] ?? 'Unknown error');
    }
  } else {
    final responseBody = json.decode(response.body);
    dynamic message;
    if (responseBody.containsKey('exception')) {
      message = responseBody['exception'];
    } else if (responseBody.containsKey('message')) {
      message = responseBody['message'];
    } else {
      message = responseBody;
    }
    throw Exception(message);
  }
}
