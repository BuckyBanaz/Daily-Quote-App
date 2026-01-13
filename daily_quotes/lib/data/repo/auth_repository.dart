import 'package:dio/dio.dart';
import '../../constant/api_endpoints.dart';
import '../../core/utils/dev_utils.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));
  
  final String _baseUrl = ApiEndpoints.baseUrl;


  Future<Response> login(String email, String password) async {
    final url = '$_baseUrl${ApiEndpoints.login}';
    final data = {
      'email': email,
      'password': password,
      'fcm_token': 'dummy_fcm_token_for_now',
    };
    
    logApiRequest('POST', url, data: data);
    
    try {
      final response = await _dio.post(url, data: data);
      logApiResponse('POST', url, response.statusCode, response.data);
      return response;
    } on DioException catch (e) {
      logApiError('POST', url, e);
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }


  Future<Response> register(String name, String email, String password) async {
    final url = '$_baseUrl${ApiEndpoints.register}';
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': password,
      'fcm_token': 'dummy_fcm_token_for_now',
    };
    
    logApiRequest('POST', url, data: data);
    
    try {
      final response = await _dio.post(url, data: data);
      logApiResponse('POST', url, response.statusCode, response.data);
      return response;
    } on DioException catch (e) {
      logApiError('POST', url, e);
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }

  Future<Response> forgotPassword(String email) async {
    final url = '$_baseUrl${ApiEndpoints.forgotPassword}';
    final data = {'email': email};
    
    logApiRequest('POST', url, data: data);
    
    try {
      final response = await _dio.post(url, data: data);
      logApiResponse('POST', url, response.statusCode, response.data);
      return response;
    } on DioException catch (e) {
      logApiError('POST', url, e);
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }


  Future<Response> getUser(String token) async {
    final url = '$_baseUrl${ApiEndpoints.user}';
    final headers = {'Authorization': 'Bearer $token'};
    
    logApiRequest('GET', url, headers: headers);
    
    try {
      final response = await _dio.get(
        url,
        options: Options(headers: headers),
      );
      logApiResponse('GET', url, response.statusCode, response.data);
      return response;
    } on DioException catch (e) {
      logApiError('GET', url, e);
      if (e.response != null) {
        return e.response!;
      }
      rethrow;
    }
  }
}
