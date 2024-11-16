import 'dart:convert';
import 'package:http/http.dart' as http;

class RoomRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final String? orderBy;
  final int? limit;
  final String? filters;
  final String? id;

  RoomRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
    this.orderBy,
    this.id,
  });

  Map<String, dynamic> request() {
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

    if (orderBy != null && orderBy!.isNotEmpty) {
      requestMap['order_by'] = orderBy;
    }

    return requestMap;
    // return {
    //   if (fields != null && fields!.isNotEmpty) 'fields': fields,
    //   if (limitStart != null && limitStart!.isNotEmpty)
    //     'limit_start': limitStart,
    //   if (limit != null) 'limit': limit,
    //   if (filters != null && filters!.isNotEmpty) 'filters': filters,
    // };
  }

  Map<String, String> header() => {'Cookie': cookie};

  Map<String, String> detail() {
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
      'https://erp2.hotelkontena.com/api/resource/Room?${queryParams(requestQuery.request())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.header(),
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

Future<Map<String, dynamic>> detail({required RoomRequest requestQuery}) async {
  String url =
      'https://erp2.hotelkontena.com/api/method/frappe.desk.form.load.getdoc?${queryParams(requestQuery.detail())}';
  print('URL: $url');

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.header(),
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
