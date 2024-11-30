import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_hk/app_state.dart';

class CreateRoomTask {
  final String cookie;
  final String? id;
  final String purpose;
  final String room;
  final String employee;
  final String employeeName;
  final String? date;

  CreateRoomTask({
    required this.cookie,
    this.id,
    required this.purpose,
    required this.room,
    required this.employee,
    required this.employeeName,
    this.date,
  });

  Map<String, String> formatHeader() {
    return {'Cookie': cookie};
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
      'to_be_completed_at': date,
    };

    data.removeWhere((key, value) => value == null);
    return data;
  }

  Map<String, dynamic> toJsonSubmit() {
    final data = {
      'docstatus': 1,
    };
    return data;
  }
}

Future<Map<String, dynamic>> request(
    {required CreateRoomTask requestQuery}) async {
  String url;
  http.Response response;

  if (requestQuery.getParamID() != null) {
    url =
        '${AppState().domain}/api/resource/Room Task/${requestQuery.getParamID()}';
  } else {
    url = '${AppState().domain}/api/resource/Room Task';
  }

  if (requestQuery.getParamID() != null) {
    response = await http.put(
      Uri.parse(url),
      headers: requestQuery.formatHeader(),
      body: json.encode(requestQuery.toJsonSubmit()),
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
