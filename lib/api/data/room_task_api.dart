import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateRoomTaskRequest {
  final String cookie;
  final String? id;
  final String purpose;
  final String room;
  final String employee;
  final String employeeName;

  CreateRoomTaskRequest({
    required this.cookie,
    this.id,
    required this.purpose,
    required this.room,
    required this.employee,
    required this.employeeName,
  });
  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  String? getParamID() {
    return id;
  }

  Map<String, dynamic> toJson() {
    final data = {
      'purpose': purpose,
      'room': room,
      'company': 'KONTENA BATU',
      'employee': employee,
      'employee_name': employeeName,
    };
    data.removeWhere((key, value) => value == null);
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required CreateRoomTaskRequest requestQuery}) async {
  String url;
  http.Response response;

  if (requestQuery.getParamID() != null) {
    url =
        'https://erp2.hotelkontena.com/api/resource/room-task/view/list${requestQuery.getParamID()}';
  } else {
    url = 'https://erp2.hotelkontena.com/api/resource/Room Task';
  }
  if (requestQuery.getParamID() != null) {
    response = await http.put(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJson()),
    );
  } else {
    response = await http.post(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJson()),
    );
  }

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    print('respon data, ${responseBody}');
    print('respon data, ${requestQuery.toJson()}');
    if (requestQuery.getParamID() != null) {
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        return requestQuery.toJson();
      }
    } else {
      if (responseBody.containsKey('data')) {
        return responseBody['data'];
      } else {
        throw Exception(responseBody);
      }
    }
  } else {
    final responseBody = json.decode(response.body);
    final message;
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
