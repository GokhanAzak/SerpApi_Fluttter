import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiGet {
  static const String apiKey = "";
  static const String baseUrl = "https://serpapi.com/search.json";

  static Future<List<dynamic>> getPhonePrices(String query) async {
    final Uri url =
        Uri.parse("$baseUrl?engine=google_shopping&q=$query&api_key=$apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["shopping_results"] ?? [];
    } else {
      throw Exception("API isteği başarısız oldu!");
    }
  }
}
