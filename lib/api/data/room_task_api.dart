import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateRoomTaskRequest {
  final String cookie;
  final String? id;
  final String purpose;
  final String room;
  // final String statusCurrent;
  // final String statusNext;
  final String employee;
  CreateRoomTaskRequest({
    required this.cookie,
    this.id,
    required this.purpose,
    required this.room,
    // required this.statusCurrent,
    // required this.statusNext,
    required this.employee,
  });
  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
      'Content-Type': 'application/json',
    };
  }
  Map<String, dynamic> toJson() {
    return {
      'purpose': purpose,
      'room': room,
      'company': 'KONTENA BATU',
      // 'status_current': statusCurrent,
      // 'status_next': statusNext,
      'employee': employee,
    };
  }
}
Future<Map<String, dynamic>> requestRoomTask({
  required CreateRoomTaskRequest requestQuery,
}) async {
  String url = 'https://erp2.hotelkontena.com/api/resource/room-task/view/list';
  print('Request URL: $url');
  print('Request JSON: ${json.encode(requestQuery.toJson())}');
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        throw Exception('Response format unexpected: ${response.body}');
      }
    } else {
      final responseBody = json.decode(response.body);
      throw Exception('Error ${response.statusCode}: $responseBody');
    }
  } catch (e) {
    throw Exception('Failed to send request: $e');
  }
}