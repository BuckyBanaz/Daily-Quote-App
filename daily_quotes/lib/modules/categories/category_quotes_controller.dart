import 'package:get/get.dart';
import '../../data/models/quote_model.dart';
import '../../data/models/category_model.dart';
import '../../data/repo/quote_repository.dart';

class CategoryQuotesController extends GetxController {
  final Category category;
  final QuoteRepository _quoteRepo = QuoteRepository();
  
  final RxList<Quote> quotes = <Quote>[].obs;
  final RxBool isLoading = true.obs;

  CategoryQuotesController({required this.category});

  @override
  void onInit() {
    super.onInit();
    loadQuotes();
  }

  Future<void> loadQuotes() async {
    isLoading.value = true;
    try {
      final result = await _quoteRepo.getQuotes(categoryId: category.id);
      quotes.assignAll(result);
    } catch (e) {
      print('Error loading category quotes: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavorite(Quote quote) async {
    final index = quotes.indexWhere((q) => q.id == quote.id);
    if (index == -1) return;

    final isCurrentlyFavorited = quote.isFavorited;
    
    // Optimistic update
    final updatedQuote = Quote(
      id: quote.id,
      text: quote.text,
      author: quote.author,
      categoryId: quote.categoryId,
      isLiked: quote.isLiked,
      isFavorited: !isCurrentlyFavorited,
      likesCount: quote.likesCount,
    );
    
    quotes[index] = updatedQuote;

    try {
      if (isCurrentlyFavorited) {
        await _quoteRepo.unfavoriteQuote(quote.id ?? '');
      } else {
        await _quoteRepo.favoriteQuote(quote.id ?? '');
      }
    } catch (e) {
      // Revert on error
      quotes[index] = quote;
      Get.snackbar('Error', 'Failed to update favorite');
    }
  }
}
