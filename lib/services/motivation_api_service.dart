import 'dart:convert';
import 'package:http/http.dart' as http;

class MotivationApiService {
  Future<List<dynamic>> getMotivationApi() async {
    final url = Uri.parse("https://type.fit/api/quotes");
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    List motivationTexts = [];

    if (data != null && response.statusCode == 200) {
      for (var i in data) {
        motivationTexts.add(i);
      }
    }
    return motivationTexts;
  }
}
