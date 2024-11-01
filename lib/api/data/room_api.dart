import 'dart:convert';
import 'package:http/http.dart' as http;

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
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<List<dynamic>> requestItem({required RoomRequest requestQuery}) async {
  String url =
      'https://erp2.hotelkontena.com/api/resource/Room?${queryParams(requestQuery.toRequestParams())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.toHeaders(),
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody.containsKey('data')) {
      return responseBody['data'];
    } else {
      throw Exception('Response does not contain data: $responseBody');
    }
  } else {
    throw Exception('System unknown error code ${response.statusCode}');
  }
}

