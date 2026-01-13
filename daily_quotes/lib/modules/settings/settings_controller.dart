import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/auth_controller.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/auth_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();
  final AuthService _authService = Get.find<AuthService>();

  final RxBool notificationsEnabled = true.obs;
  
  // Theme & Appearance
  final RxBool isDarkMode = false.obs;
  final RxInt themeColorValue = 0xFF26A69A.obs; // Teal
  final RxDouble fontSizeScale = 1.0.obs;

  final RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  final RxInt userFavoritesCount = 0.obs;
  final RxInt userStreak = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadAppPreferences();
  }

  void loadAppPreferences() {
    isDarkMode.value = _storage.getDarkMode();
    themeColorValue.value = _storage.getThemeColor();
    fontSizeScale.value = _storage.getFontSize();
    
    // Apply theme immediately
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> loadUserData() async {
    // 1. Load from storage first for instant UI
    final localData = _storage.getUserData();
    if (localData != null) {
      userData.value = localData;
      userFavoritesCount.value = localData['favorites_count'] ?? 0;
    }
    userStreak.value = _storage.getStreak();

    // 2. Sync from server for latest counts
    isLoading.value = true;
    try {
      final result = await _authService.syncUser();
      if (result['success']) {
        final syncedData = result['data'];
        userData.value = syncedData;
        userFavoritesCount.value = syncedData['favorites_count'] ?? 0;
      }
    } finally {
      isLoading.value = false;
    }
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
  }

  // Theme Updates
  void toggleDarkMode(bool value) {
    isDarkMode.value = value;
    _storage.saveDarkMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  void updateThemeColor(int color) {
    themeColorValue.value = color;
    _storage.saveThemeColor(color);
    update(); // Force UI update for color-dependent components
  }

  void updateFontSize(double scale) {
    fontSizeScale.value = scale;
    _storage.saveFontSize(scale);
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed('/login');
  }
}
