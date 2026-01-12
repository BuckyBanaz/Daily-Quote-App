import 'package:get/get.dart';
import 'favorites_controller.dart';
import '../../data/services/storage_service.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(() => FavoritesController());
  }
}
