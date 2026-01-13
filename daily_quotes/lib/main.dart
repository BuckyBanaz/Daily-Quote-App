import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'data/services/auth_service.dart';
import 'data/services/notification_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'modules/settings/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => NotificationService().init());
  // Request Notification Permissions on App Start
  await Get.find<NotificationService>().requestPermissions();
  Get.put(ApiService());
  
  // Initialize AuthService
  final authService = Get.put(AuthService());
  
  // Global Settings Controller for Theme Handling
  Get.put(SettingsController());
  
  // Sync user data if logged in
  String initialRoute = AppRoutes.LOGIN;
  if (authService.isLoggedIn()) {
    final syncResult = await authService.syncUser();
    if (syncResult['success'] == true) {
      initialRoute = AppRoutes.HOME;
    }
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsController>();

    return Obx(() => GetMaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(
        isDark: false, 
        primaryColor: Color(settings.themeColorValue.value)
      ),
      darkTheme: AppTheme.getTheme(
        isDark: true, 
        primaryColor: Color(settings.themeColorValue.value)
      ),
      themeMode: settings.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: initialRoute,
      getPages: AppPages.pages,
      builder: (context, child) {
        return Obx(() => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(settings.fontSizeScale.value),
          ),
          child: child!,
        ));
      },
    ));
  }
}
