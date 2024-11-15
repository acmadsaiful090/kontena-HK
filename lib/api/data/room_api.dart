import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jc_housekeeping/app_state.dart';

class RoomRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;
  final String? id;

  RoomRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
    this.id,
  });

  Map<String, dynamic> toRequestParams() {
    return {
      if (fields != null && fields!.isNotEmpty) 'fields': fields,
      if (limitStart != null && limitStart!.isNotEmpty)
        'limit_start': limitStart,
      if (limit != null) 'limit': limit,
      if (filters != null && filters!.isNotEmpty) 'filters': filters,
    };
  }

  Map<String, String> toHeaders() => {'Cookie': cookie};

  Map<String, String> paramDetail() {
    return {
      'doctype': 'Room Detail',
      'name': id ?? '',
    };
  }
}

String queryParams(Map<String, dynamic> map) => map.entries
    .map((e) =>
        '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value.toString())}')
    .join('&');

Future<List<dynamic>> requestItem({required RoomRequest requestQuery}) async {
  String url =
      'https://erp2.hotelkontena.com/api/resource/Room?${queryParams(requestQuery.toRequestParams())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.toHeaders(),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody is Map<String, dynamic> &&
        responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception('Unexpected response format: $responseBody');
    }
  } else {
    throw Exception(
        'System unknown error, status code: ${response.statusCode}');
  }
}

Future<Map<String, dynamic>> requestDetail(
    {required RoomRequest requestQuery}) async {
  String url =
      'https://erp2.hotelkontena.com/api/method/frappe.desk.form.load.getdoc?${queryParams(requestQuery.paramDetail())}';
  print('URL: $url');

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.toHeaders(),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody is Map<String, dynamic> &&
        responseBody.containsKey('docs') &&
        responseBody['docs'] is List) {
      return responseBody['docs'][0];
    } else {
      throw Exception('Unexpected response format: $responseBody');
    }
  } else {
    throw Exception(
        'System unknown error, status code: ${response.statusCode}');
  }
}
