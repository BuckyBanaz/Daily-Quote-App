import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Services
  await Get.putAsync(() => StorageService().init());
  Get.put(ApiService());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Quotes',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Applied the new theme
      initialRoute: AppRoutes.HOME,
      getPages: AppPages.pages,
    );
  }
}
