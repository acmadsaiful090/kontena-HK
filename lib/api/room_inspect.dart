import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jc_housekeeping/app_state.dart';

class RoomInspect {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;
  final String? id;
  // late http.Client client;

  RoomInspect({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
    this.id,
  }) {
    // client = http.Client();
  }

  Map<String, dynamic> formatRequest() {
    Map<String, dynamic> requestMap = {};

    if (fields != null && fields!.isNotEmpty) {
      requestMap['fields'] = fields;
    }

    if (limitStart != null && limitStart!.isNotEmpty) {
      requestMap['limit_start'] = limitStart;
    }

    if (limit != null) {
      requestMap['limit'] = limit;
    }

    if (filters != null && filters!.isNotEmpty) {
      requestMap['filters'] = filters;
    }

    return requestMap;
  }

  Map<String, String> formatHeader() {
    return {
      'Cookie': cookie,
    };
  }

  String? getParamID() {
    return id;
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

// print('check url, $cookie');
Future<List<dynamic>> request({required RoomInspect requestQuery}) async {
  String url;

  if (requestQuery.getParamID() != null) {
    url =
        '${AppState().domain}/api/resource/Room Inspect/${requestQuery.getParamID()}';
  } else {
    url =
        '${AppState().domain}/api/resource/Room Inspect?${queryParams(requestQuery.formatRequest())}';
  }

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeader(),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception(responseBody);
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
