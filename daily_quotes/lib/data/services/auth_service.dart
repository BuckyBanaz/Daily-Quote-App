import 'package:get/get.dart' hide Response;
import '../repo/auth_repository.dart';
import './storage_service.dart';

class AuthService extends GetxService {
  final AuthRepository _authRepo = AuthRepository();
  final StorageService _storage = Get.find<StorageService>();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _authRepo.login(email, password);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Save token and user data
        await _storage.saveUserToken(data['token']);
        await _storage.saveUserData(data['user']);
        
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': response.data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      final response = await _authRepo.register(name, email, password);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': response.data};
      } else {
        return {'success': false, 'message': response.data['message'] ?? 'Registration failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      final response = await _authRepo.forgotPassword(email);
      
      if (response.statusCode == 200) {
        return {'success': true, 'message': response.data['message'] ?? 'Reset link sent'};
      } else {
        return {'success': false, 'message': response.data['message'] ?? 'Failed to send link'};
      }
    } catch (e) {
      return {'success': false, 'message': 'An error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> syncUser() async {
    try {
      final token = _storage.getUserToken();
      if (token == null) {
        return {'success': false, 'message': 'No token found'};
      }

      final response = await _authRepo.getUser(token);
      
      if (response.statusCode == 200) {
        final userData = response.data['user'];
        await _storage.saveUserData(userData);
        return {'success': true, 'data': userData};
      } else {
        // Token might be invalid, clear storage
        await logout();
        return {'success': false, 'message': 'Session expired'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Sync failed: $e'};
    }
  }

  Future<void> logout() async {
    await _storage.clearUser();
  }

  bool isLoggedIn() {
    return _storage.getUserToken() != null;
  }
}
