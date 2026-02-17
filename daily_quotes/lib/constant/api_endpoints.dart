class ApiEndpoints {
  // Base URLs
  static const String baseUrl = 'http://10.0.2.2:8000/api'; // Android Emulator
  static const String baseUrlIOS = 'http://127.0.0.1:8000/api'; // iOS Simulator
  
  // Auth Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String forgotPassword = '/forgot-password';
  
  // Quote Endpoints (for future use)
  static const String quotes = '/quotes';
  static const String randomQuote = '/quotes/random';
  
  // Helper method to get full URL
  static String getFullUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}
