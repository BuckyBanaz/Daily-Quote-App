import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt tabindex = 0.obs;

  void changeTab(int index) {
    tabindex.value = index;
  }
}
