import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jc_hk/app_state.dart';

class EmployeeDetailRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;

  EmployeeDetailRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
  });

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
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<List<dynamic>> requestEmployee({
  required EmployeeDetailRequest requestQuery,
}) async {
  String url =
      '${AppState().domain}/api/resource/Employee?${queryParams(requestQuery.formatRequest())}';

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
    throw Exception('System unknown error code ${response.statusCode}');
  }
}
