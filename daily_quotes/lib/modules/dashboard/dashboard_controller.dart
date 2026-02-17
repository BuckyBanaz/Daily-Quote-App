import 'package:get/get.dart';

import '../home/home_controller.dart';
import '../categories/categories_controller.dart';
import '../favorites/favorites_controller.dart';
import '../settings/settings_controller.dart';

class DashboardController extends GetxController {
  final RxInt tabindex = 0.obs;
  final Set<int> _initializedIndices = {0}; // Home is default

  void changeTab(int index) {
    if (tabindex.value == index) return;
    
    tabindex.value = index;
    
    // Lazy load data only when tab is first visited
    if (!_initializedIndices.contains(index)) {
      _initializedIndices.add(index);
      _triggerTabLoading(index);
    }
  }

  void _triggerTabLoading(int index) {
    switch (index) {
      case 1:
        if (Get.isRegistered<CategoriesController>()) {
          Get.find<CategoriesController>().loadCategories();
        }
        break;
      case 2:
        if (Get.isRegistered<FavoritesController>()) {
          Get.find<FavoritesController>().loadInitialData();
        }
        break;
      case 3:
        if (Get.isRegistered<SettingsController>()) {
          Get.find<SettingsController>().loadUserData();
        }
        break;
    }
  }
}
