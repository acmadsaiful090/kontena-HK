import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jc_hk/app_state.dart';

class UserDetailRequest {
  final String cookie;
  final String id;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;
  // late http.Client client;

  UserDetailRequest({
    required this.cookie,
    required this.id,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
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

  String paramID() {
    return id;
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<Map<String, dynamic>> requestuser(
    {required UserDetailRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/User/${requestQuery.paramID()}?${queryParams(requestQuery.formatRequest())}';

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

// void cancelRequest(ItemRequest requestQuery) {
//   requestQuery.client.close();
// }

// Example of using the cancellation function
// void main() async {
//   final requestQuery = ItemRequest(cookie: 'your_token_here');
//   final future = requestItem(requestQuery: requestQuery);

//   // Cancel the request after 5 seconds (as an example)
//   Future.delayed(Duration(seconds: 5), () {
//     cancelRequest(requestQuery);
//   });

//   try {
//     final result = await future;
//     print(result);
//   } catch (e) {
//     print('Error: $e');
//   }
// }