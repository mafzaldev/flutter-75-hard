import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class APIEndpoints {
  static const String basUrl = "https://api.api-ninjas.com/v1/quotes?category=";
  static const String apiKey = "ltpUPVUajjNmYjxzcRZe9w==CT5BHIj1NjJs5MDu";
  static const List<String> categories = [
    'failure',
    'god',
    'faith',
    'hope',
    'health',
    'life',
    'experience',
    'freedom',
    'success',
    'inspirational'
  ];
}

class APIServices {
  static APIServices? _instance;

  APIServices._();

  static APIServices get instance {
    _instance ??= APIServices._();
    return _instance!;
  }

  Future<String> fetchQuote() async {
    String quote = "";
    String apiEndpoint = APIEndpoints.basUrl +
        APIEndpoints.categories[DateTime.now().millisecondsSinceEpoch %
            APIEndpoints.categories.length];
    try {
      final response = await http.get(Uri.parse(apiEndpoint), headers: {
        'X-Api-Key': APIEndpoints.apiKey,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        quote = body[0]["quote"];
      } else {
        throw '${response.statusCode}: Error Occurred';
      }
    } catch (e) {
      log(e.toString());
    }
    return quote;
  }
}
