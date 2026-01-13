import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/services/auth_service.dart';
import '../../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.isRegistered<AuthService>() 
      ? Get.find<AuthService>() 
      : Get.put(AuthService());

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();
  
  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (loginEmailController.text.isEmpty || loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final result = await _authService.login(loginEmailController.text, loginPasswordController.text);
      isLoading.value = false;

      if (result['success'] == true) {
        Get.snackbar('Success', 'Login Successful', backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(AppRoutes.HOME);
      } else {
        Get.snackbar('Error', result['message'] ?? 'Login Failed', backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  Future<void> register() async {
    if (registerNameController.text.isEmpty || registerEmailController.text.isEmpty || registerPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      final result = await _authService.register(registerNameController.text, registerEmailController.text, registerPasswordController.text);
      isLoading.value = false;

      if (result['success'] == true) {
        Get.snackbar('Success', 'Registration Successful. Please Login.', backgroundColor: Colors.green, colorText: Colors.white);
        Get.offNamed(AppRoutes.LOGIN);
      } else {
        Get.snackbar('Error', result['message'] ?? 'Registration Failed', backgroundColor: Colors.redAccent, colorText: Colors.white);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // Forgot Password Validation
  final forgotPasswordEmailController = TextEditingController();

  Future<bool> sendResetLink() async {
    if (forgotPasswordEmailController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter your email', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }

    try {
      isLoading.value = true;
      final result = await _authService.forgotPassword(forgotPasswordEmailController.text.trim());
      isLoading.value = false;

      if (result['success'] == true) {
        Get.snackbar('Success', 'Reset Link Sent Successfully', backgroundColor: Colors.green, colorText: Colors.white);
        return true;
      } else {
        Get.snackbar('Error', result['message'] ?? 'Failed to send link', backgroundColor: Colors.redAccent, colorText: Colors.white);
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'An error occurred: $e', backgroundColor: Colors.redAccent, colorText: Colors.white);
      return false;
    }
  }
}
