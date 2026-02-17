import 'package:get/get.dart';
import '../../data/models/category_model.dart';
import '../../data/repo/quote_repository.dart';

class CategoriesController extends GetxController {
  final QuoteRepository _quoteRepo = QuoteRepository();
  final RxList<Category> categories = <Category>[].obs;
  final RxBool isLoading = true.obs;

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await _quoteRepo.getCategories();
      categories.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }
}
