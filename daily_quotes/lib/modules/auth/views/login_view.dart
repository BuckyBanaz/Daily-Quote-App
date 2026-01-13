import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../auth_controller.dart';
import 'forgot_password_view.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () => Get.back(),
        // ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Logo/Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: const Icon(Icons.menu_book_rounded, size: 40, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              'QuoteVault',
              style: GoogleFonts.outfit(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Refined inspiration for the modern mind.',
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Email Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Email", style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.loginEmailController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                hintText: 'Enter your email',
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Password Field
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Password", style: GoogleFonts.roboto(fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 8),
            Obx(() => TextField(
              controller: controller.loginPasswordController,
              obscureText: !controller.isPasswordVisible.value,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                hintText: '• • • • • • • •',
                hintStyle: TextStyle(color: Colors.grey[400]),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[200]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            )),
            
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Get.to(() => const ForgotPasswordView()),
                child: Text(
                  'Forgot password?', 
                  style: GoogleFonts.roboto(color: AppColors.primary, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Login Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: controller.isLoading.value 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text('Login →', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
              )),
            ),
            
            const SizedBox(height: 32),
            
            // Bottom Text
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: TextStyle(color: Colors.grey[600])),
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.REGISTER),
                  child: Text(
                    "Sign Up", 
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
