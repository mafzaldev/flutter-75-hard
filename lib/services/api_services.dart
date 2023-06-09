import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:seventy_five_hard/utils/utils.dart';

class APIConstants {
  static String quotesBaseUrl =
      "https://api.api-ninjas.com/v1/quotes?category=";
  static String booksBaseUrl = "https://www.googleapis.com/books/v1/volumes";
  static String quotesApiKey = "ltpUPVUajjNmYjxzcRZe9w==CT5BHIj1NjJs5MDu";
  static String booksApiKey = "AIzaSyBDAM7_BTitEcSUebbFZDUlVrG2_Ip02sk";
}

class APIServices {
  static APIServices? _instance;
  APIServices._();

  static APIServices get instance {
    _instance ??= APIServices._();
    return _instance!;
  }

  Future<List<String>> fetchQuotes() async {
    List<String> quotes = [];
    int categoryIndex =
        Utils.generateRandomNumber(0, Utils.quoteCategories.length - 1);
    String apiEndpoint =
        "${APIConstants.quotesBaseUrl}${Utils.quoteCategories[categoryIndex]}&limit=5";
    try {
      final response = await http.get(Uri.parse(apiEndpoint), headers: {
        'X-Api-Key': APIConstants.quotesApiKey,
      });

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        quotes = body.map((e) => e["quote"]).toList().cast<String>();
      } else {
        throw '${response.statusCode}: Error Occurred';
      }
    } catch (e) {
      log(e.toString());
    }
    return quotes;
  }
}
