import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiNinjaService {
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/nutrition?query=';
  static const String _apiKey = 'eYwaRWiSVt7lfCkgMEdPKw==NLQHe2nKjut6gdVz'; // Replace with your API key

  // Function to fetch food info using the API
  static Future<Map<String, dynamic>> getFoodInfo(String query) async {
    // URL encode the query string to handle spaces or special characters
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse('$_baseUrl$encodedQuery');

    try {
      final response = await http.get(
        url,
        headers: {
          'X-Api-Key': _apiKey,
        },
      );

      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // Return the first entry in the list
          return data[0];
        } else {
          throw Exception("No food data found for '$query'.");
        }
      } else {
        // Handle HTTP errors more gracefully
        throw Exception("Failed to fetch data: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      // Handle errors like no internet connection or bad response
      throw Exception("Error fetching data: $e");
    }
  }
}
