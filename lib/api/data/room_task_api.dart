import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;

  ItemRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
  }) {
    // client = http.Client();
  }

  Map<String, dynamic> formatRequestSalesCatalog() {
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

  Map<String, String> formatHeaderItemPrice() {
    return {
      'Cookie': cookie,
    };
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

// print('check url, $cookie');
Future<List<dynamic>> requestItem({required ItemRequest requestQuery}) async {
  String url =
      'https://erp2.hotelkontena.com/api/resource/room-task/view/list?${queryParams(requestQuery.formatRequestSalesCatalog())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeaderItemPrice(),
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