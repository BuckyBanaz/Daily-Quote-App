import 'package:flutter/foundation.dart';

/// Logs messages only if the app is run with --dart-define=verma=true
/// Example: flutter run --dart-define=verma=true
void devLog(Object? message) {
  const bool isDev = bool.fromEnvironment('verma');
  if (isDev) {
    debugPrint("$message");
  }
}

/// Logs API request details
void logApiRequest(String method, String url, {Map<String, dynamic>? headers, dynamic data}) {
  const bool isDev = bool.fromEnvironment('verma');
  if (isDev) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('🚀 API REQUEST');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📍 Method: $method');
    debugPrint('🔗 URL: $url');
    if (headers != null && headers.isNotEmpty) {
      debugPrint('📋 Headers: $headers');
    }
    if (data != null) {
      debugPrint('📦 Data: $data');
    }
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}

/// Logs API response details
void logApiResponse(String method, String url, int? statusCode, dynamic data) {
  const bool isDev = bool.fromEnvironment('verma');
  if (isDev) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('✅ API RESPONSE');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📍 Method: $method');
    debugPrint('🔗 URL: $url');
    debugPrint('📊 Status Code: $statusCode');
    debugPrint('📦 Response Data: $data');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}

/// Logs API error details
void logApiError(String method, String url, dynamic error) {
  const bool isDev = bool.fromEnvironment('verma');
  if (isDev) {
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('❌ API ERROR');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    debugPrint('📍 Method: $method');
    debugPrint('🔗 URL: $url');
    debugPrint('💥 Error: $error');
    debugPrint('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
  }
}

