import 'package:get/get.dart';
import 'dashboard_controller.dart';
import '../home/home_controller.dart';
import '../favorites/favorites_controller.dart';
import '../categories/categories_controller.dart';
import '../settings/settings_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<CategoriesController>(() => CategoriesController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}
