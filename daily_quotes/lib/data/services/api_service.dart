import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/quote_model.dart';

class ApiService extends GetxService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  // ZenQuotes (Rate Limited) -> Switched to DummyJSON for reliability
  // final String _baseUrl = 'https://zenquotes.io/api/random';
  final String _baseUrl = 'https://dummyjson.com/quotes/random';

  final List<Quote> _fallbackQuotes = [
    Quote(text: "The only way to do great work is to love what you do.", author: "Steve Jobs"),
    Quote(text: "Believe you can and you're halfway there.", author: "Theodore Roosevelt"),
    Quote(text: "Everything you've ever wanted is on the other side of fear.", author: "George Addair"),
    Quote(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill"),
    Quote(text: "What lies behind us and what lies before us are tiny matters compared to what lies within us.", author: "Ralph Waldo Emerson"),
  ];

  Future<Quote> getRandomQuote() async {
    try {
      final response = await _dio.get(_baseUrl);
      
      if (response.statusCode == 200) {
        final dynamic data = response.data;
        print("DEBUG: API Data Type: ${data.runtimeType}");
        
        if (data is Map) {
          return Quote.fromJson(Map<String, dynamic>.from(data));
        } else if (data is List && data.isNotEmpty) {
           return Quote.fromJson(data[0]);
        }
      }
      return _getFallbackQuote();
    } catch (e) {
      print('API Error: $e. Using fallback.');
      return _getFallbackQuote();
    }
  }

  Quote _getFallbackQuote() {
    return (_fallbackQuotes..shuffle()).first;
  }
}
