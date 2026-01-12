import 'package:get/get.dart';
import 'app_routes.dart';
import '../modules/dashboard/dashboard_binding.dart';
import '../modules/dashboard/dashboard_view.dart';
// import '../modules/home/home_binding.dart'; // No longer needed as binding is in Dashboard
// import '../modules/home/home_view.dart';
import '../modules/favorites/favorites_binding.dart';
import '../modules/favorites/favorites_view.dart';

class AppPages {
  static const INITIAL = AppRoutes.HOME;

  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.FAVORITES,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
  ];
}
