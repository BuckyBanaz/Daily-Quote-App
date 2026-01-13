import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../../constant/api_endpoints.dart';
import '../../core/utils/dev_utils.dart';
import '../models/quote_model.dart';
import '../models/category_model.dart';
import '../services/storage_service.dart';

class QuoteRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  final String _baseUrl = ApiEndpoints.baseUrl;
  final StorageService _storage = Get.find<StorageService>();

  Options get _authOptions {
    final token = _storage.getUserToken();
    return Options(headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });
  }

  Future<List<Category>> getCategories() async {
    final url = '$_baseUrl/categories';
    logApiRequest('GET', url);
    
    try {
      final response = await _dio.get(url, options: _authOptions);
      logApiResponse('GET', url, response.statusCode, response.data);
      
      final List<dynamic> data = response.data;
      return data.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      logApiError('GET', url, e);
      return [];
    }
  }

  Future<Quote?> getRandomQuote({String? categoryId}) async {
    final url = '$_baseUrl${ApiEndpoints.randomQuote}';
    final query = categoryId != null ? {'category_id': categoryId} : null;
    
    logApiRequest('GET', url, data: query);
    
    try {
      final response = await _dio.get(url, queryParameters: query, options: _authOptions);
      logApiResponse('GET', url, response.statusCode, response.data);
      
      return Quote.fromJson(response.data);
    } catch (e) {
      logApiError('GET', url, e);
      return null;
    }
  }

  Future<List<Quote>> getQuotes({int page = 1, String? categoryId}) async {
    final url = '$_baseUrl${ApiEndpoints.quotes}';
    final query = {
      'page': page,
      if (categoryId != null) 'category_id': categoryId,
    };
    
    logApiRequest('GET', url, data: query);
    
    try {
      final response = await _dio.get(url, queryParameters: query, options: _authOptions);
      logApiResponse('GET', url, response.statusCode, response.data);
      
      // Check if response.data is valid
      if (response.data == null) {
        return [];
      }
      
      // Handle pagination response
      if (response.data is Map && response.data.containsKey('data')) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          try {
            return Quote.fromJson(json);
          } catch (e) {
            print('Error parsing quote: $e');
            return null;
          }
        }).whereType<Quote>().toList();
      }
      
      return [];
    } catch (e) {
      logApiError('GET', url, e);
      return [];
    }
  }

  Future<Quote?> likeQuote(String quoteId) async {
    final url = '$_baseUrl/quotes/$quoteId/like';
    logApiRequest('POST', url);
    
    try {
      final response = await _dio.post(url, options: _authOptions);
      logApiResponse('POST', url, response.statusCode, response.data);
      
      if (response.data['quote'] != null) {
        return Quote.fromJson(response.data['quote']);
      }
      return null;
    } catch (e) {
      logApiError('POST', url, e);
      return null;
    }
  }

  Future<Quote?> unlikeQuote(String quoteId) async {
    final url = '$_baseUrl/quotes/$quoteId/unlike';
    logApiRequest('DELETE', url);
    
    try {
      final response = await _dio.delete(url, options: _authOptions);
      logApiResponse('DELETE', url, response.statusCode, response.data);
      
      if (response.data['quote'] != null) {
        return Quote.fromJson(response.data['quote']);
      }
      return null;
    } catch (e) {
      logApiError('DELETE', url, e);
      return null;
    }
  }

  Future<List<Quote>> getLikedQuotes({String? categoryId}) async {
    final url = '$_baseUrl/quotes/liked';
    final query = categoryId != null ? {'category_id': categoryId} : null;
    
    logApiRequest('GET', url, data: query);
    
    try {
      final response = await _dio.get(url, queryParameters: query, options: _authOptions);
      logApiResponse('GET', url, response.statusCode, response.data);
      
      // Check if response.data is valid
      if (response.data == null) {
        return [];
      }
      
      // Handle pagination response
      if (response.data is Map && response.data.containsKey('data')) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) {
          try {
            return Quote.fromJson(json);
          } catch (e) {
            print('Error parsing liked quote: $e');
            return null;
          }
        }).whereType<Quote>().toList();
      }
      
      return [];
    } catch (e) {
      logApiError('GET', url, e);
      return [];
    }
  }

  Future<List<Quote>> getFavorites({String? categoryId}) async {
    final url = '$_baseUrl/quotes/favorites';
    final query = categoryId != null ? {'category_id': categoryId} : null;
    
    logApiRequest('GET', url, data: query);
    
    try {
      final response = await _dio.get(url, queryParameters: query, options: _authOptions);
      logApiResponse('GET', url, response.statusCode, response.data);
      
      if (response.data == null) return [];
      
      if (response.data is Map && response.data.containsKey('data')) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Quote.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      logApiError('GET', url, e);
      return [];
    }
  }

  Future<Quote?> favoriteQuote(String quoteId) async {
    final url = '$_baseUrl/quotes/$quoteId/favorite';
    logApiRequest('POST', url);
    
    try {
      final response = await _dio.post(url, options: _authOptions);
      logApiResponse('POST', url, response.statusCode, response.data);
      
      if (response.data['quote'] != null) {
        return Quote.fromJson(response.data['quote']);
      }
      return null;
    } catch (e) {
      logApiError('POST', url, e);
      return null;
    }
  }

  Future<Quote?> unfavoriteQuote(String quoteId) async {
    final url = '$_baseUrl/quotes/$quoteId/unfavorite';
    logApiRequest('DELETE', url);
    
    try {
      final response = await _dio.delete(url, options: _authOptions);
      logApiResponse('DELETE', url, response.statusCode, response.data);
      
      if (response.data['quote'] != null) {
        return Quote.fromJson(response.data['quote']);
      }
      return null;
    } catch (e) {
      logApiError('DELETE', url, e);
      return null;
    }
  }
}
