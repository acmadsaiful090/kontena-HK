import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kontena_hk/app_state.dart';

class CompanyRequest {
  final String cookie;
  final String? fields;
  final String? limitStart;
  final int? limit;
  final String? filters;

  CompanyRequest({
    required this.cookie,
    this.fields,
    this.limit,
    this.limitStart,
    this.filters,
  });

  Map<String, dynamic> formatRequestCompany() {
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

  Map<String, String> formatHeaderCompany() {
    return {
      'Cookie': cookie,
    };
  }
}

String queryParams(Map<String, dynamic> map) =>
    map.entries.map((e) => '${e.key}=${e.value}').join('&');

Future<List<dynamic>> requestCompany(
    {required CompanyRequest requestQuery}) async {
  String url =
      '${AppState().domain}/api/resource/Company?${queryParams(requestQuery.formatRequestCompany())}';

  final response = await http.get(
    Uri.parse(url),
    headers: requestQuery.formatHeaderCompany(),
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