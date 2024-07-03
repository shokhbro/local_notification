import 'package:local_notification/services/motivation_api_service.dart';

class MotivationController {
  final MotivationApiService quoteApiController = MotivationApiService();

  Future<Map<String, String>> getRandomMotivation() async {
    final List<dynamic> quotes = await quoteApiController.getMotivationApi();
    final int randomIndex =
        DateTime.now().millisecondsSinceEpoch % quotes.length;
    final Map<String, String> selectedQuote = {
      'text': quotes[randomIndex]['text'],
      'author': quotes[randomIndex]['author'] ?? 'Unknown'
    };
    return selectedQuote;
  }
}
